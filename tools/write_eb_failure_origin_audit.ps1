param(
  [string]$RunRootBase = (Join-Path (Resolve-Path (Join-Path $PSScriptRoot '..')).Path 'runs/EB'),
  [string]$RunGlob = 'EB-entropy-*',
  [string]$WaveId = 'EB-wave',
  [string]$OutputMarkdown = '',
  [string]$OutputJson = '',
  [switch]$IncludeAllFailures
)

$ErrorActionPreference = 'Stop'

if (-not $OutputMarkdown) {
  $OutputMarkdown = Join-Path (Resolve-Path (Join-Path $PSScriptRoot '..')).Path "docs/reports/$WaveId-failure-origin-audit.md"
}
if (-not $OutputJson) {
  $OutputJson = Join-Path (Resolve-Path (Join-Path $PSScriptRoot '..')).Path "docs/reports/$WaveId-failure-origin-audit.json"
}

function Get-Origin($error, $failureClass) {
  $message = [string]$error
  if ($message -match 'exceeds the available context size') {
    return 'context_budget'
  }
  if ($message -match 'curl exited|model response did not include choices text|HTTP 5\d\d|connection|timeout|timed out|controller|reconcile_needed') {
    return 'infra_or_serving'
  }
  if ($message -match 'missing title text|missing project: CoreLib|wrong target framework|missing factory script|missing json file: .*config[\\/]stations\.json') {
    return 'prompt_spec_or_validator'
  }
  if ($message -match 'placeholder|did not generate expected artifact path|missing station id|station count mismatch|route mismatch|build failed|script failed|missing page:|missing site directory|missing library chain directory') {
    return 'model_or_entropy'
  }
  if ($failureClass -eq 'harness') {
    return 'harness'
  }
  if ($failureClass -in @('generation','missing_artifact','link_integrity','shared_state','api_contract','dependency_graph','configuration','runtime_behavior','build')) {
    return 'model_or_entropy'
  }
  return 'needs_manual_review'
}

function Read-JsonLines($path) {
  if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { return @() }
  return @(Get-Content -LiteralPath $path | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object {
    $_ | ConvertFrom-Json -Depth 64
  })
}

$runDirs = @(Get-ChildItem -LiteralPath $RunRootBase -Directory -Filter $RunGlob | Sort-Object Name)
if ($runDirs.Count -eq 0) {
  throw "no run folders matched $RunGlob under $RunRootBase"
}

$records = foreach ($run in $runDirs) {
  $resultsPath = Join-Path $run.FullName 'results.jsonl'
  $rows = Read-JsonLines $resultsPath
  if ($rows.Count -eq 0) {
    [pscustomobject]@{
      wave_id = $WaveId
      run_name = $run.Name
      target_set_id = $null
      workload_id = $null
      stage_id = $null
      stage_order = $null
      harness_mode = $null
      context_tokens = $null
      status = 'missing-results'
      failure_class = 'harness'
      failure_origin = 'harness'
      error = "missing or empty results: $resultsPath"
      run_root = $run.FullName
    }
    continue
  }

  $groups = $rows | Group-Object target_set_id, workload_id
  foreach ($group in $groups) {
    $items = @($group.Group | Sort-Object stage_order)
    $failedRows = @($items | Where-Object { $_.status -ne 'pass' })
    if (-not $IncludeAllFailures) {
      $failedRows = @($failedRows | Select-Object -First 1)
    }
    foreach ($failed in $failedRows) {
      $origin = Get-Origin $failed.error $failed.failure_class
      [pscustomobject]@{
        wave_id = $WaveId
        run_name = $run.Name
        target_set_id = [string]$failed.target_set_id
        model_id = [string]$failed.model_id
        context_tokens = $failed.context_tokens
        harness_mode = [string]$failed.harness_mode
        workload_id = [string]$failed.workload_id
        stage_id = [string]$failed.stage_id
        stage_order = $failed.stage_order
        status = [string]$failed.status
        failure_class = [string]$failed.failure_class
        failure_origin = $origin
        error = [string]$failed.error
        run_root = $run.FullName
      }
    }
  }
}

$originCounts = @($records | Group-Object failure_origin | Sort-Object Name | ForEach-Object {
  [ordered]@{ origin = $_.Name; count = $_.Count }
})
$classCounts = @($records | Group-Object failure_class | Sort-Object Name | ForEach-Object {
  [ordered]@{ failure_class = $_.Name; count = $_.Count }
})

$audit = [ordered]@{
  schema_version = 1
  wave_id = $WaveId
  generated_at = (Get-Date).ToString('o')
  run_root_base = (Resolve-Path -LiteralPath $RunRootBase).Path
  run_glob = $RunGlob
  run_count = $runDirs.Count
  failure_count = @($records).Count
  origin_counts = $originCounts
  failure_class_counts = $classCounts
  records = @($records)
}

New-Item -ItemType Directory -Force -Path (Split-Path $OutputJson) | Out-Null
$audit | ConvertTo-Json -Depth 64 | Set-Content -LiteralPath $OutputJson -Encoding UTF8

$lines = New-Object System.Collections.Generic.List[string]
$lines.Add("# $WaveId Failure Origin Audit")
$lines.Add("")
$lines.Add("- Generated: $($audit.generated_at)")
$lines.Add('- Run glob: `' + $RunGlob + '`')
$lines.Add("- Run count: $($audit.run_count)")
$lines.Add("- Failure rows audited: $($audit.failure_count)")
$lines.Add('- Audit JSON: `' + $OutputJson + '`')
$lines.Add("")
$lines.Add("## Origin Counts")
$lines.Add("")
$lines.Add("| Origin | Count |")
$lines.Add("|---|---:|")
foreach ($count in $originCounts) {
  $lines.Add("| $($count.origin) | $($count.count) |")
}
$lines.Add("")
$lines.Add("## First Failures")
$lines.Add("")
$lines.Add("| Target | Workload | Stage | Class | Origin | Error |")
$lines.Add("|---|---|---|---|---|---|")
foreach ($record in @($records | Sort-Object target_set_id, workload_id, stage_order)) {
  $err = ([string]$record.error).Replace('|','\|').Replace("`r",' ').Replace("`n",' ')
  if ($err.Length -gt 220) { $err = $err.Substring(0, 217) + '...' }
  $lines.Add("| $($record.target_set_id) | $($record.workload_id) | $($record.stage_id) | $($record.failure_class) | $($record.failure_origin) | $err |")
}

New-Item -ItemType Directory -Force -Path (Split-Path $OutputMarkdown) | Out-Null
$lines | Set-Content -LiteralPath $OutputMarkdown -Encoding UTF8

Write-Host "Wrote EB failure-origin audit: $OutputMarkdown"
Write-Host "Wrote EB failure-origin audit JSON: $OutputJson"
