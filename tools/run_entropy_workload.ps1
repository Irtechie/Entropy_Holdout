param(
  [ValidateSet('webpage-chain','library-chain','factory')]
  [string]$Workload = 'webpage-chain',
  [ValidateSet('mock','api')]
  [string]$Mode = 'mock',
  [string]$OutputRoot = '',
  [string]$ResultPath = '',
  [string]$ApiBaseUrl = '',
  [string]$Model = '',
  [string]$TargetSetId = 'mock',
  [int]$ContextTokens = 0,
  [string]$HarnessMode = '',
  [ValidateSet('direct','langchain')]
  [string]$CompletionProvider = 'direct',
  [bool]$RequireLangfuse = $false
)

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
. (Join-Path $PSScriptRoot 'Import-DotEnv.ps1')

if (-not $OutputRoot) {
  $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
  $OutputRoot = Join-Path $repoRoot "runs/entropy_workloads/$Workload-$Mode-$stamp"
}
if (-not $ResultPath) {
  $ResultPath = Join-Path $OutputRoot 'results.jsonl'
}
if (-not $HarnessMode) {
  $HarnessMode = $Mode
}

function Write-Result($row) {
  $row | ConvertTo-Json -Depth 16 -Compress | Add-Content -LiteralPath $ResultPath -Encoding UTF8
}

function Invoke-JsonPost($url, $body, $timeoutSec) {
  $json = $body | ConvertTo-Json -Depth 32 -Compress
  $tmp = New-TemporaryFile
  $bodyFile = New-TemporaryFile
  try {
    [System.IO.File]::WriteAllText($bodyFile.FullName, $json, (New-Object System.Text.UTF8Encoding($false)))
    $statusText = & curl.exe -sS -m $timeoutSec -o $tmp.FullName -w '%{http_code}' -X POST $url -H 'Content-Type: application/json' --data-binary "@$($bodyFile.FullName)"
    $exitCode = $LASTEXITCODE
    $content = Get-Content -Raw -LiteralPath $tmp.FullName
    if ($exitCode -ne 0) {
      throw "curl exited $exitCode posting $url body=$content"
    }
    $statusCode = [int]$statusText
    if ($statusCode -lt 200 -or $statusCode -ge 300) {
      throw "HTTP $statusCode posting $url body=$content"
    }
    if ([string]::IsNullOrWhiteSpace($content)) { return $null }
    return $content | ConvertFrom-Json -Depth 64
  } finally {
    Remove-Item -LiteralPath $tmp.FullName -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $bodyFile.FullName -Force -ErrorAction SilentlyContinue
  }
}

function Invoke-DirectModelCompletion($prompt) {
  if (-not $ApiBaseUrl) { throw "-ApiBaseUrl is required for api mode" }
  if (-not $Model) { throw "-Model is required for api mode" }

  $resp = $null
  try {
    $resp = Invoke-JsonPost "$ApiBaseUrl/v1/chat/completions" @{
      model = $Model
      messages = @(
        @{ role = 'system'; content = 'You are a code generator. Return only the requested JSON object. No prose.' },
        @{ role = 'user'; content = $prompt }
      )
      max_tokens = 4096
      temperature = 0
    } 600
  } catch {
    $resp = Invoke-JsonPost "$ApiBaseUrl/v1/completions" @{
      model = $Model
      prompt = $prompt
      max_tokens = 4096
      temperature = 0
    } 600
  }

  $text = $null
  if ($resp.choices -and $resp.choices[0].text) {
    $text = [string]$resp.choices[0].text
  } elseif ($resp.choices -and $resp.choices[0].message -and $resp.choices[0].message.content) {
    $text = [string]$resp.choices[0].message.content
  }
  if ($null -ne $text) {
    return [pscustomobject]@{
      text = $text
      raw = $resp
      usage = $resp.usage
    }
  }
  throw "model response did not include choices text"
}

function Invoke-LangChainCompletion($prompt, $stage, $attemptIndex, $attemptReason) {
  if (-not $ApiBaseUrl) { throw "-ApiBaseUrl is required for api mode" }
  if (-not $Model) { throw "-Model is required for api mode" }

  $script = Join-Path $PSScriptRoot 'langchain_completion.py'
  $requestFile = New-TemporaryFile
  try {
    [ordered]@{
      base_url = $ApiBaseUrl
      model = $Model
      system = 'You are a code generator. Return only the requested JSON object. No prose.'
      prompt = $prompt
      max_tokens = 4096
      temperature = 0
      timeout_s = 600
      require_langfuse = $RequireLangfuse
      run_id = (Split-Path -Leaf $OutputRoot)
      session_id = (Split-Path -Leaf $OutputRoot)
      run_name = "EB $TargetSetId $Workload $($stage.id)"
      tags = @('EB', $HarnessMode, $CompletionProvider, $TargetSetId, $Workload)
      metadata = [ordered]@{
        benchmark = 'EB'
        target_set_id = $TargetSetId
        workload_id = $Workload
        stage_id = [string]$stage.id
        stage_order = [int]$stage.order
        harness_mode = $HarnessMode
        completion_provider = $CompletionProvider
        attempt_index = $attemptIndex
        attempt_reason = $attemptReason
        context_tokens = $ContextTokens
      }
    } | ConvertTo-Json -Depth 32 | Set-Content -LiteralPath $requestFile.FullName -Encoding UTF8

    $output = & python $script --request $requestFile.FullName 2>&1
    $exitCode = $LASTEXITCODE
    $text = ($output | ForEach-Object { [string]$_ }) -join [Environment]::NewLine
    if ($exitCode -ne 0) {
      throw "langchain adapter exited ${exitCode}: $text"
    }
    $resp = $text | ConvertFrom-Json -Depth 64
    return [pscustomobject]@{
      text = [string]$resp.text
      raw = $resp.raw
      usage = $resp.usage
      langfuse_trace_id = $resp.langfuse_trace_id
    }
  } finally {
    Remove-Item -LiteralPath $requestFile.FullName -Force -ErrorAction SilentlyContinue
  }
}

function Invoke-ModelCompletion($prompt, $stage, $attemptIndex, $attemptReason) {
  if ($CompletionProvider -eq 'langchain') {
    return Invoke-LangChainCompletion $prompt $stage $attemptIndex $attemptReason
  }
  return Invoke-DirectModelCompletion $prompt
}

function ConvertFrom-JsonObjectText($text) {
  $trimmed = [string]$text
  $start = $trimmed.IndexOf('{')
  $end = $trimmed.LastIndexOf('}')
  if ($start -lt 0 -or $end -le $start) {
    throw "model did not return a JSON object"
  }
  $json = $trimmed.Substring($start, $end - $start + 1)
  return $json | ConvertFrom-Json -Depth 64
}

function Get-RelativeFiles($root) {
  if (-not (Test-Path -LiteralPath $root -PathType Container)) { return @() }
  $base = (Resolve-Path $root).Path
  return @(Get-ChildItem -LiteralPath $root -Recurse -File | ForEach-Object {
    if ($_.Name -eq 'results.jsonl') { return }
    $rel = $_.FullName.Substring($base.Length).TrimStart('\','/')
    [pscustomobject]@{
      path = $rel.Replace('\','/')
      content = Get-Content -Raw -LiteralPath $_.FullName
    }
  })
}

function Write-GeneratedFiles($runRoot, $files) {
  $written = @()
  if ($null -eq $files) {
    return @()
  }
  foreach ($file in @($files)) {
    if (-not $file.path -or $null -eq $file.content) {
      throw "generated file entry must include path and content"
    }
    if ([string]$file.path -eq 'relative/path/from/run/root') {
      throw "model copied placeholder path instead of generating a real file path"
    }
    if ([string]$file.content -eq 'complete file content') {
      throw "model copied placeholder content instead of generating real file content"
    }
    $relative = ([string]$file.path).Replace('/', [System.IO.Path]::DirectorySeparatorChar)
    if ([System.IO.Path]::IsPathRooted($relative) -or $relative -like '*..*') {
      throw "refusing unsafe generated path: $($file.path)"
    }
    $target = Join-Path $runRoot $relative
    Write-TextFile $target ([string]$file.content)
    $written += ([string]$file.path).Replace('\','/')
  }
  return $written
}

function Test-ArtifactExists($runRoot, $relativePath) {
  $relative = ([string]$relativePath).Replace('/', [System.IO.Path]::DirectorySeparatorChar)
  if ([System.IO.Path]::IsPathRooted($relative) -or $relative -like '*..*') {
    return $false
  }
  $target = Join-Path $runRoot $relative
  return (Test-Path -LiteralPath $target)
}

function Assert-StageArtifactsWritten($runRoot, $stage, $written) {
  $writtenPaths = @($written | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) })
  foreach ($artifact in @($stage.expected_artifacts)) {
    $expected = ([string]$artifact.path).Replace('\','/')
    $matched = @($writtenPaths | Where-Object {
      $_ -eq $expected -or ([string]$_).StartsWith("$expected/")
    })
    if ($matched.Count -eq 0 -and -not (Test-ArtifactExists $runRoot $expected)) {
      throw "model did not generate expected artifact path: $expected"
    }
  }
}

function New-StagePrompt($workloadId, $stage, $existingFiles) {
  if (@($existingFiles).Count) {
    $existingChunks = @($existingFiles | ForEach-Object {
      "FILE: $($_.path)`n---BEGIN FILE---`n$($_.content)`n---END FILE---"
    })
    $existingText = $existingChunks -join ([Environment]::NewLine + [Environment]::NewLine)
  } else {
    $existingText = "No existing generated files."
  }

  $artifactText = (@($stage.expected_artifacts) | ForEach-Object { "- $($_.path) ($($_.kind))" }) -join "`n"
  $validatorText = (@($stage.validators) | ForEach-Object { "- $($_.id): failure_class=$($_.failure_class)" }) -join "`n"
  $contractText = New-ValidatorContractText $workloadId

  return @"
You are running an Entropy staged code-generation benchmark.

Workload: $workloadId
Stage: $($stage.id)
Order: $($stage.order)

Stage goal:
$($stage.prompt_goal)

Expected artifacts:
$artifactText

Validators that will run:
$validatorText

Exact validator contract:
$contractText

Existing generated files:
$existingText

Return ONLY a JSON object in this exact shape:
{
  "files": [
    { "path": "relative/path/from/run/root", "content": "complete file content" }
  ],
  "notes": "short note"
}

Rules:
- Include every new or modified file needed for this stage to pass.
- Use only relative paths.
- Do not include markdown fences outside the JSON.
- Do not explain the answer outside the JSON.
"@
}

function New-ValidatorContractText($workloadId) {
  switch ($workloadId) {
    'webpage-chain' {
      $spec = Get-Content -Raw -LiteralPath (Join-Path $repoRoot 'benchmarks/entropy_workloads/webpage_chain.json') | ConvertFrom-Json -Depth 32
      $pages = (@($spec.pages) | ForEach-Object {
        $backlinkText = if ($_.backlink) { "; backlink href must be '$($_.backlink)'" } else { '' }
        "- $($_.path): title text must include '$($_.title)'$backlinkText"
      }) -join "`n"
      return @"
Generate files under site/ only.
Every HTML page must include <!doctype html>.
Required pages and literals:
$pages
From page order $($spec.shared_nav_required_from_stage), every page must link to index.html, page-2.html, page-3.html, and page-4.html.
By stage $($spec.shared_table_required_from_stage), index.html and page-5.html must include data-entropy-shared-table="factory-links".
"@
    }
    'library-chain' {
      $spec = Get-Content -Raw -LiteralPath (Join-Path $repoRoot 'benchmarks/entropy_workloads/library_chain.json') | ConvertFrom-Json -Depth 32
      $projects = (@($spec.projects) | ForEach-Object {
        $refs = if (@($_.references).Count) { " references: $(@($_.references) -join ', ')" } else { '' }
        "- $($_.name): $($_.path)$refs"
      }) -join "`n"
      return @"
Generate a .NET project tree under library-chain/.
Target framework must be $($spec.target_framework).
Required project files:
$projects
SampleApp must build and dotnet run --project SampleApp/SampleApp.csproj --no-build --nologo must print exactly $($spec.sample_expected_output).
"@
    }
    'factory' {
      $spec = Get-Content -Raw -LiteralPath (Join-Path $repoRoot 'benchmarks/entropy_workloads/factory.json') | ConvertFrom-Json -Depth 32
      $stations = (@($spec.stations) | ForEach-Object { "- id=$($_.id), name=$($_.name), next=$($_.next)" }) -join "`n"
      return @"
Generate a PowerShell-runnable factory under factory-system/.
Required final files include factory-system/config/stations.json, factory-system/src/factory.ps1, and factory-system/dashboard/report.json.
stations.json must contain exactly these stations:
$stations
factory.ps1 must accept -ConfigPath and -ProductId, print route intake->assembly->quality->shipping, and write dashboard/report.json.
dashboard/report.json must contain product_id $($spec.sample_product.id) and route intake->assembly->quality->shipping.
"@
    }
  }
  return ''
}

function New-RepairPrompt($workloadId, $stage, $existingFiles, $failedResponse, $failureMessage) {
  if (@($existingFiles).Count) {
    $existingChunks = @($existingFiles | ForEach-Object {
      "FILE: $($_.path)`n---BEGIN FILE---`n$($_.content)`n---END FILE---"
    })
    $existingText = $existingChunks -join ([Environment]::NewLine + [Environment]::NewLine)
  } else {
    $existingText = "No existing generated files."
  }

  $artifactText = (@($stage.expected_artifacts) | ForEach-Object { "- $($_.path) ($($_.kind))" }) -join "`n"
  $contractText = New-ValidatorContractText $workloadId

  return @"
You are repairing an Entropy staged code-generation benchmark response.

Workload: $workloadId
Stage: $($stage.id)
Order: $($stage.order)

Stage goal:
$($stage.prompt_goal)

Expected artifacts:
$artifactText

Exact validator contract:
$contractText

The previous response failed with:
$failureMessage

Previous response text:
---BEGIN FAILED RESPONSE---
$failedResponse
---END FAILED RESPONSE---

Current generated files:
$existingText

Return ONLY a corrected JSON object in this exact shape:
{
  "files": [
    { "path": "relative/path/from/run/root", "content": "complete file content" }
  ],
  "notes": "short note"
}

Rules:
- Include every new or modified file needed for this stage to pass.
- Use only relative paths.
- Do not include markdown fences outside the JSON.
- Do not explain the answer outside the JSON.
- Do not copy placeholder path or content values from the schema.
"@
}

function Add-TokenUsage($total, $usage) {
  if (-not $total) {
    $total = [ordered]@{
      prompt_tokens = 0
      completion_tokens = 0
      total_tokens = 0
    }
  }

  if ($usage) {
    foreach ($name in @('prompt_tokens','completion_tokens','total_tokens')) {
      $prop = $usage.PSObject.Properties[$name]
      if ($prop -and $null -ne $prop.Value -and "$($prop.Value)" -match '^\d+$') {
        $total[$name] = [int64]$total[$name] + [int64]$prop.Value
      }
    }
  }

  return $total
}

function Save-CompletionArtifacts($rawDir, $stageId, $label, $prompt, $completion) {
  $prefix = if ($label) { "$stageId.$label" } else { $stageId }

  $promptPath = Join-Path $rawDir "$prefix.prompt.txt"
  Set-Content -LiteralPath $promptPath -Value $prompt -Encoding UTF8

  $rawPath = Join-Path $rawDir "$prefix.txt"
  Set-Content -LiteralPath $rawPath -Value $completion.text -Encoding UTF8

  $rawJsonPath = Join-Path $rawDir "$prefix.response.json"
  $completion.raw | ConvertTo-Json -Depth 64 | Set-Content -LiteralPath $rawJsonPath -Encoding UTF8

  return [ordered]@{
    prompt_path = (Resolve-Path -LiteralPath $promptPath).Path
    raw_response_path = (Resolve-Path -LiteralPath $rawPath).Path
    raw_response_json_path = (Resolve-Path -LiteralPath $rawJsonPath).Path
  }
}

function Get-WorkloadStages($workloadId) {
  $spec = Get-Content -Raw -LiteralPath (Join-Path $repoRoot 'benchmarks/entropy_workloads/workloads.json') | ConvertFrom-Json -Depth 64
  $workload = @($spec.workloads | Where-Object { $_.id -eq $workloadId } | Select-Object -First 1)
  if (-not $workload) { throw "workload not found in workloads.json: $workloadId" }
  return @($workload.stages | Sort-Object order)
}

function Invoke-WorkloadValidator($workloadId, $runRoot) {
  switch ($workloadId) {
    'webpage-chain' { return & (Join-Path $PSScriptRoot 'validators/webpage_chain.ps1') -RunRoot $runRoot }
    'library-chain' { return & (Join-Path $PSScriptRoot 'validators/library_chain.ps1') -RunRoot $runRoot }
    'factory' { return & (Join-Path $PSScriptRoot 'validators/factory.ps1') -RunRoot $runRoot }
  }
}

function Get-FailureClass($message) {
  if ($message -match 'missing|not found') { return 'missing_artifact' }
  if ($message -match 'build') { return 'build' }
  if ($message -match 'link|href') { return 'link_integrity' }
  if ($message -match 'json|JSON|placeholder|generate') { return 'generation' }
  if ($message -match 'config') { return 'configuration' }
  if ($message -match 'route|run|output|behavior') { return 'runtime_behavior' }
  return 'harness'
}

function Complete-ApiWorkloadValidation($runRoot) {
  $lastStage = @(Get-WorkloadStages $Workload | Sort-Object order | Select-Object -Last 1)[0]
  try {
    $validation = Invoke-WorkloadValidator $Workload $runRoot
    Write-Host $validation
  } catch {
    $message = $_.Exception.Message
    Write-Result ([ordered]@{
      run_id = Split-Path -Leaf $runRoot
      target_set_id = $TargetSetId
      model_id = $Model
      context_tokens = $ContextTokens
      harness_mode = $HarnessMode
      workload_id = $Workload
      completion_provider = $CompletionProvider
      stage_id = 'final-validation'
      stage_order = ([int]$lastStage.order + 1)
      status = 'fail'
      failure_class = Get-FailureClass $message
      generated_files = @()
      validator_results = @()
      raw_response_path = $null
      raw_response_json_path = $null
      prompt_path = $null
      token_usage = $null
      langfuse_trace_id = $null
      elapsed_s = 0
      error = $message
    })
    throw
  }
}

function New-ApiWorkload($runRoot) {
  $stages = Get-WorkloadStages $Workload
  foreach ($stage in $stages) {
    $started = Get-Date
    $row = [ordered]@{
      run_id = Split-Path -Leaf $runRoot
      target_set_id = $TargetSetId
      model_id = $Model
      context_tokens = $ContextTokens
      harness_mode = $HarnessMode
      workload_id = $Workload
      completion_provider = $CompletionProvider
      stage_id = $stage.id
      stage_order = [int]$stage.order
      status = 'fail'
      failure_class = 'generation'
      generated_files = @()
      validator_results = @()
      raw_response_path = $null
      raw_response_json_path = $null
      prompt_path = $null
      token_usage = $null
      langfuse_trace_id = $null
      repair_count = 0
      repair_history = @()
      elapsed_s = $null
      error = $null
    }

    try {
      $existing = Get-RelativeFiles $runRoot
      $prompt = New-StagePrompt $Workload $stage $existing
      $rawDir = Join-Path $runRoot '_raw'
      New-Item -ItemType Directory -Force -Path $rawDir | Out-Null
      $usesModelRepair = $HarnessMode -in @('model-repair','repair-extract')
      $maxRepairs = if ($usesModelRepair) { 2 } else { 0 }
      $attemptIndex = 0
      $attemptPrompt = $prompt
      $attemptReason = 'initial'
      $repairHistory = @()
      $tokenUsage = $null

      while ($true) {
        $label = if ($usesModelRepair) {
          if ($attemptIndex -eq 0) { 'attempt-00' } else { "attempt-$('{0:d2}' -f $attemptIndex)-repair" }
        } else {
          ''
        }

        $completion = Invoke-ModelCompletion $attemptPrompt $stage $attemptIndex $attemptReason
        $paths = Save-CompletionArtifacts $rawDir $stage.id $label $attemptPrompt $completion
        $row.prompt_path = $paths.prompt_path
        $row.raw_response_path = $paths.raw_response_path
        $row.raw_response_json_path = $paths.raw_response_json_path
        $tokenUsage = Add-TokenUsage $tokenUsage $completion.usage
        $row.token_usage = [pscustomobject]$tokenUsage
        $row.langfuse_trace_id = $completion.langfuse_trace_id
        $text = $completion.text

        try {
          $parsed = ConvertFrom-JsonObjectText $text
          $written = Write-GeneratedFiles $runRoot $parsed.files
          Assert-StageArtifactsWritten $runRoot $stage $written
          $row.generated_files = @($written)
          $row.status = 'pass'
          $row.failure_class = 'none'
          $row.repair_count = $attemptIndex
          $row.repair_history = @($repairHistory)
          break
        } catch {
          $attemptError = $_.Exception.Message
          $attemptFailureClass = Get-FailureClass $attemptError
          $repairHistory += [ordered]@{
            attempt_index = $attemptIndex
            reason = $attemptReason
            status = 'fail'
            failure_class = $attemptFailureClass
            error = $attemptError
            prompt_path = $paths.prompt_path
            raw_response_path = $paths.raw_response_path
            raw_response_json_path = $paths.raw_response_json_path
            token_usage = $completion.usage
            langfuse_trace_id = $completion.langfuse_trace_id
          }

          if ($attemptIndex -ge $maxRepairs) {
            $row.repair_count = $attemptIndex
            $row.repair_history = @($repairHistory)
            throw $attemptError
          }

          $attemptIndex += 1
          $attemptReason = $attemptFailureClass
          $attemptPrompt = New-RepairPrompt $Workload $stage (Get-RelativeFiles $runRoot) $text $attemptError
        }
      }
    } catch {
      $row.error = $_.Exception.Message
      $row.failure_class = Get-FailureClass $row.error
    } finally {
      $row.elapsed_s = [math]::Round(((Get-Date) - $started).TotalSeconds, 1)
      Write-Result $row
    }

    if ($row.status -ne 'pass') { throw $row.error }
  }
}

function New-WebpageChainMock($runRoot) {
  $specPath = Join-Path $repoRoot 'benchmarks/entropy_workloads/webpage_chain.json'
  $spec = Get-Content -Raw -LiteralPath $specPath | ConvertFrom-Json -Depth 32
  $siteRoot = Join-Path $runRoot $spec.output_dir
  New-Item -ItemType Directory -Force -Path $siteRoot | Out-Null

  $pages = @($spec.pages)
  foreach ($page in $pages) {
    $links = foreach ($navPage in $pages) {
      if ([int]$navPage.order -le [int]$page.order -or [int]$page.order -ge [int]$spec.shared_nav_required_from_stage) {
        "<a href=""$($navPage.path)"">$($navPage.title)</a>"
      }
    }
    $back = ''
    if ($page.backlink) {
      $back = "<p><a href=""$($page.backlink)"">Back to previous page</a></p>"
    }
    $table = ''
    if ([int]$page.order -eq 1 -or [int]$page.order -ge [int]$spec.shared_table_required_from_stage) {
      $table = @'
<table data-entropy-shared-table="factory-links">
  <tr><th>Layer</th><th>Pages</th></tr>
  <tr><td>chain</td><td>1 -> 2 -> 3 -> 4 -> 5</td></tr>
  <tr><td>shared</td><td>navigation and nested table</td></tr>
</table>
'@
    }
    $html = @"
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>$($page.title)</title>
</head>
<body>
  <nav>
    $($links -join "`n    ")
  </nav>
  <main>
    <h1>$($page.title)</h1>
    <p>Mock generated page for $($page.stage_id).</p>
    $back
    $table
  </main>
</body>
</html>
"@
    Set-Content -LiteralPath (Join-Path $siteRoot $page.path) -Value $html -Encoding UTF8

    Write-Result ([ordered]@{
      run_id = Split-Path -Leaf $runRoot
      target_set_id = 'mock'
      model_id = 'mock'
      context_tokens = 0
      harness_mode = $Mode
      workload_id = $Workload
      stage_id = $page.stage_id
      stage_order = [int]$page.order
      status = 'pass'
      failure_class = 'none'
      generated_files = @((Join-Path $spec.output_dir $page.path).Replace('\','/'))
      validator_results = @()
      elapsed_s = 0
    })
  }
}

function Write-TextFile($path, $content) {
  New-Item -ItemType Directory -Force -Path (Split-Path $path) | Out-Null
  Set-Content -LiteralPath $path -Value $content -Encoding UTF8
}

function New-Csproj($name, $targetFramework, $references, [switch]$Exe) {
  $outputType = ''
  if ($Exe) {
    $outputType = @'
    <OutputType>Exe</OutputType>
'@
  }
  $referenceXml = ''
  foreach ($reference in @($references)) {
    $path = $reference.Replace('/', '\')
    $referenceXml += "    <ProjectReference Include=""..\$path"" />`n"
  }
  if ($referenceXml) {
    $referenceXml = @"
  <ItemGroup>
$referenceXml  </ItemGroup>
"@
  }
  return @"
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
$outputType
    <TargetFramework>$targetFramework</TargetFramework>
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>
  </PropertyGroup>
$referenceXml
</Project>
"@
}

function New-LibraryChainMock($runRoot) {
  $specPath = Join-Path $repoRoot 'benchmarks/entropy_workloads/library_chain.json'
  $spec = Get-Content -Raw -LiteralPath $specPath | ConvertFrom-Json -Depth 32
  $chainRoot = Join-Path $runRoot $spec.output_dir
  New-Item -ItemType Directory -Force -Path $chainRoot | Out-Null

  Write-TextFile (Join-Path $chainRoot 'CoreLib/CoreLib.csproj') (New-Csproj 'CoreLib' $spec.target_framework @())
  Write-TextFile (Join-Path $chainRoot 'CoreLib/CorePart.cs') @'
namespace CoreLib;

public static class CorePart
{
    public static string Value() => "core";
}
'@

  Write-TextFile (Join-Path $chainRoot 'FeatureLib/FeatureLib.csproj') (New-Csproj 'FeatureLib' $spec.target_framework @('CoreLib/CoreLib.csproj'))
  Write-TextFile (Join-Path $chainRoot 'FeatureLib/FeaturePart.cs') @'
using CoreLib;

namespace FeatureLib;

public static class FeaturePart
{
    public static string Value() => $"{CorePart.Value()}->feature";
}
'@

  Write-TextFile (Join-Path $chainRoot 'PipelineLib/PipelineLib.csproj') (New-Csproj 'PipelineLib' $spec.target_framework @('FeatureLib/FeatureLib.csproj'))
  Write-TextFile (Join-Path $chainRoot 'PipelineLib/PipelinePart.cs') @'
using FeatureLib;

namespace PipelineLib;

public static class PipelinePart
{
    public static string Value() => $"{FeaturePart.Value()}->pipeline";
}
'@

  Write-TextFile (Join-Path $chainRoot 'Contracts/Contracts.csproj') (New-Csproj 'Contracts' $spec.target_framework @())
  Write-TextFile (Join-Path $chainRoot 'Contracts/IEntropyStage.cs') @'
namespace Contracts;

public interface IEntropyStage
{
    string Value();
}
'@

  Write-TextFile (Join-Path $chainRoot 'SampleApp/SampleApp.csproj') (New-Csproj 'SampleApp' $spec.target_framework @('PipelineLib/PipelineLib.csproj','Contracts/Contracts.csproj') -Exe)
  Write-TextFile (Join-Path $chainRoot 'SampleApp/Program.cs') @'
using PipelineLib;

Console.WriteLine($"{PipelinePart.Value()}->contract");
'@

  foreach ($stageGroup in @($spec.projects | Group-Object stage_id)) {
    $projects = @($stageGroup.Group)
    $order = [int]($projects | Select-Object -First 1).order
    Write-Result ([ordered]@{
      run_id = Split-Path -Leaf $runRoot
      target_set_id = 'mock'
      model_id = 'mock'
      context_tokens = 0
      harness_mode = $Mode
      workload_id = $Workload
      stage_id = $stageGroup.Name
      stage_order = $order
      status = 'pass'
      failure_class = 'none'
      generated_files = @($projects | ForEach-Object { (Join-Path $spec.output_dir $_.path).Replace('\','/') })
      validator_results = @()
      elapsed_s = 0
    })
  }
}

function New-FactoryMock($runRoot) {
  $specPath = Join-Path $repoRoot 'benchmarks/entropy_workloads/factory.json'
  $spec = Get-Content -Raw -LiteralPath $specPath | ConvertFrom-Json -Depth 32
  $factoryRoot = Join-Path $runRoot $spec.output_dir
  New-Item -ItemType Directory -Force -Path $factoryRoot | Out-Null

  $config = [ordered]@{
    stations = @($spec.stations)
    product = $spec.sample_product
  }
  Write-TextFile (Join-Path $factoryRoot 'config/stations.json') ($config | ConvertTo-Json -Depth 16)

  Write-TextFile (Join-Path $factoryRoot 'src/factory.ps1') @'
param(
  [Parameter(Mandatory=$true)]
  [string]$ConfigPath,
  [Parameter(Mandatory=$true)]
  [string]$ProductId
)

$ErrorActionPreference = 'Stop'
$config = Get-Content -Raw -LiteralPath $ConfigPath | ConvertFrom-Json -Depth 16
$stations = @($config.stations)
$byId = @{}
foreach ($station in $stations) {
  $byId[$station.id] = $station
}

$route = New-Object System.Collections.Generic.List[string]
$current = 'intake'
while ($current) {
  if (-not $byId.ContainsKey($current)) {
    throw "Missing station $current"
  }
  $route.Add($current)
  $current = $byId[$current].next
}

$dashboardRoot = Join-Path (Split-Path $PSScriptRoot) 'dashboard'
New-Item -ItemType Directory -Force -Path $dashboardRoot | Out-Null
[ordered]@{
  product_id = $ProductId
  route = @($route)
  station_count = $route.Count
} | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $dashboardRoot 'report.json') -Encoding UTF8

Write-Output ($route -join '->')
'@

  Write-TextFile (Join-Path $factoryRoot 'dashboard/README.md') @'
# Factory Dashboard

The generated factory script writes `report.json` here after routing a product through the configured stations.
'@

  foreach ($stage in @('factory-001-layout','factory-002-stations','factory-003-configuration','factory-004-dashboard')) {
    $order = [array]::IndexOf(@('factory-001-layout','factory-002-stations','factory-003-configuration','factory-004-dashboard'), $stage) + 1
    Write-Result ([ordered]@{
      run_id = Split-Path -Leaf $runRoot
      target_set_id = 'mock'
      model_id = 'mock'
      context_tokens = 0
      harness_mode = $Mode
      workload_id = $Workload
      stage_id = $stage
      stage_order = $order
      status = 'pass'
      failure_class = 'none'
      generated_files = @($spec.output_dir)
      validator_results = @()
      elapsed_s = 0
    })
  }
}

New-Item -ItemType Directory -Force -Path $OutputRoot | Out-Null

switch ($Workload) {
  'webpage-chain' {
    if ($Mode -eq 'mock') { New-WebpageChainMock $OutputRoot } else { New-ApiWorkload $OutputRoot }
    if ($Mode -eq 'mock') {
      $validation = Invoke-WorkloadValidator $Workload $OutputRoot
      Write-Host $validation
    } else {
      Complete-ApiWorkloadValidation $OutputRoot
    }
  }
  'library-chain' {
    if ($Mode -eq 'mock') { New-LibraryChainMock $OutputRoot } else { New-ApiWorkload $OutputRoot }
    if ($Mode -eq 'mock') {
      $validation = Invoke-WorkloadValidator $Workload $OutputRoot
      Write-Host $validation
    } else {
      Complete-ApiWorkloadValidation $OutputRoot
    }
  }
  'factory' {
    if ($Mode -eq 'mock') { New-FactoryMock $OutputRoot } else { New-ApiWorkload $OutputRoot }
    if ($Mode -eq 'mock') {
      $validation = Invoke-WorkloadValidator $Workload $OutputRoot
      Write-Host $validation
    } else {
      Complete-ApiWorkloadValidation $OutputRoot
    }
  }
}

Write-Host "entropy workload complete: $OutputRoot"
