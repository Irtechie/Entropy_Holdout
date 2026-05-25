param(
  [string]$ExperimentPath = (Join-Path (Resolve-Path (Join-Path $PSScriptRoot '..')).Path 'benchmarks/entropy_workloads/experiment.local-small.json'),
  [string]$TargetsPath = (Join-Path (Resolve-Path (Join-Path $PSScriptRoot '..')).Path 'llmcommune-entropy-targets.json'),
  [string]$Base = '',
  [string]$ResultRoot = '',
  [string]$OnlySet = '',
  [string[]]$OnlyWorkload = @(),
  [switch]$IncludeDualBox,
  [switch]$KeepRunOutputs,
  [switch]$PruneRunOutputs,
  [switch]$SkipCritique,
  [switch]$StopOnFailure,
  [int]$MaxTargets = 0
)

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$experiment = Get-Content -Raw -LiteralPath $ExperimentPath | ConvertFrom-Json -Depth 64
$manifest = Get-Content -Raw -LiteralPath $TargetsPath | ConvertFrom-Json -Depth 64

if (-not $Base) {
  $Base = $experiment.base_url
}
if (-not $Base) {
  $Base = 'http://192.168.1.203:4000'
}
if (-not $ResultRoot) {
  $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
  $ResultRoot = Join-Path $repoRoot "runs/EB/$($experiment.id)-$stamp"
}

New-Item -ItemType Directory -Force -Path $ResultRoot | Out-Null
$aggregatePath = Join-Path $ResultRoot 'results.jsonl'
$eventsPath = Join-Path $ResultRoot 'events.jsonl'
$critiqueMarkdownPath = Join-Path $ResultRoot 'critique.md'
$critiqueJsonPath = Join-Path $ResultRoot 'critique.json'

function Write-Event($obj) {
  $obj | ConvertTo-Json -Depth 24 -Compress | Add-Content -LiteralPath $eventsPath -Encoding UTF8
}

function Invoke-JsonPost($url, $body, $timeoutSec) {
  $json = $body | ConvertTo-Json -Depth 24 -Compress
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
    $parsed = $null
    if (-not [string]::IsNullOrWhiteSpace($content)) {
      $parsed = $content | ConvertFrom-Json -Depth 64
    }
    if ($statusCode -ge 200 -and $statusCode -lt 300) {
      return $parsed
    }
    if ($parsed -and $parsed.ok -eq $true -and $parsed.status -eq 'skipped') {
      return $parsed
    }
    if ($parsed -and $parsed.code -eq 'RATE_LIMITED') {
      return $parsed
    }
    throw "HTTP $statusCode posting $url body=$content"
  } finally {
    Remove-Item -LiteralPath $tmp.FullName -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $bodyFile.FullName -Force -ErrorAction SilentlyContinue
  }
}

function Invoke-JsonGet($url, $timeoutSec) {
  Invoke-RestMethod -TimeoutSec $timeoutSec -Uri $url
}

function Get-RateLimitWaitSeconds($response) {
  if ($response.estimated_ready_at) {
    try {
      $readyText = [string]$response.estimated_ready_at
      if ($readyText -notmatch '(Z|[+-]\d\d:\d\d)$') {
        $readyText = "${readyText}Z"
      }
      $readyAt = [datetimeoffset]::Parse($readyText)
      $delta = [math]::Ceiling(($readyAt.ToUniversalTime() - [datetimeoffset]::UtcNow).TotalSeconds)
      if ($delta -gt 0) { return ($delta + 1) }
    } catch {
    }
  }
  if ($response.detail) {
    $match = [regex]::Match([string]$response.detail, '(\d+)s remaining')
    if ($match.Success) { return ([int]$match.Groups[1].Value + 1) }
  }
  return 20
}

function Activate-Set($baseUrl, $setId) {
  for ($attempt = 1; $attempt -le 20; $attempt++) {
    $act = Invoke-JsonPost "$baseUrl/api/llm-host/activate-set" @{ set_id=$setId; wait=$true; allow_preempt=$true } 1800
    if ($act -and $act.code -eq 'RATE_LIMITED') {
      $waitSeconds = Get-RateLimitWaitSeconds $act
      Write-Host "activation cooldown for $setId; waiting ${waitSeconds}s"
      Write-Event ([ordered]@{ ts=(Get-Date).ToString('o'); event='activation_cooldown'; set_id=$setId; wait_s=$waitSeconds })
      Start-Sleep -Seconds $waitSeconds
      continue
    }
    return $act
  }
  throw "activation cooldown did not clear for $setId after 20 attempts"
}

function Get-ServedModelId($lane) {
  $models = Invoke-JsonGet "$($lane.base_url)/v1/models" 20
  if ($models.data -and $models.data.Count -gt 0 -and $models.data[0].id) { return $models.data[0].id }
  if ($models.models -and $models.models.Count -gt 0 -and $models.models[0].model) { return $models.models[0].model }
  return $lane.model_id
}

function Get-SelectedTargets() {
  $allTargets = @($manifest.targets)
  $includeDual = $IncludeDualBox.IsPresent -or $experiment.include_dual_box -eq $true
  if (-not $includeDual) {
    $allTargets = @($allTargets | Where-Object { -not $_.requires_gx10 })
  }

  if ($OnlySet) {
    return @($allTargets | Where-Object { $_.set_id -eq $OnlySet })
  }

  if ($experiment.targets -is [string] -and $experiment.targets -eq 'all-singlebox') {
    return @($allTargets | Where-Object { -not $_.requires_gx10 })
  }

  $ids = @($experiment.targets)
  if ($ids.Count -gt 0) {
    $selected = foreach ($id in $ids) {
      $match = @($allTargets | Where-Object { $_.set_id -eq $id } | Select-Object -First 1)
      if (-not $match) { throw "target in experiment not found or filtered out: $id" }
      $match
    }
    return @($selected)
  }

  return @($allTargets)
}

$targets = @(Get-SelectedTargets)
if ($MaxTargets -gt 0) {
  $targets = @($targets | Select-Object -First $MaxTargets)
}

$workloads = if ($OnlyWorkload.Count -gt 0) { @($OnlyWorkload) } else { @($experiment.workloads) }
if ($workloads.Count -eq 0) {
  $workloads = @('webpage-chain','library-chain','factory')
}

$harnessMode = if ($experiment.harness_mode) { [string]$experiment.harness_mode } else { 'plain' }
$gitHead = ''
try {
  $gitHead = (git -C $repoRoot rev-parse HEAD).Trim()
} catch {
  $gitHead = ''
}

function Format-ReplayArg($value) {
  return '"' + ([string]$value).Replace('"','\"') + '"'
}

$replayCommand = @(
  'pwsh'
  (Format-ReplayArg $MyInvocation.MyCommand.Path)
  '-ExperimentPath'
  (Format-ReplayArg (Resolve-Path -LiteralPath $ExperimentPath).Path)
  '-TargetsPath'
  (Format-ReplayArg (Resolve-Path -LiteralPath $TargetsPath).Path)
  '-Base'
  (Format-ReplayArg $Base)
  '-ResultRoot'
  (Format-ReplayArg (Resolve-Path -LiteralPath $ResultRoot).Path)
)
if ($OnlySet) {
  $replayCommand += @('-OnlySet', (Format-ReplayArg $OnlySet))
}
foreach ($workload in @($OnlyWorkload)) {
  $replayCommand += @('-OnlyWorkload', (Format-ReplayArg $workload))
}
if ($IncludeDualBox) { $replayCommand += '-IncludeDualBox' }
if ($KeepRunOutputs) { $replayCommand += '-KeepRunOutputs' }
if ($PruneRunOutputs) { $replayCommand += '-PruneRunOutputs' }
if ($SkipCritique) { $replayCommand += '-SkipCritique' }
if ($StopOnFailure) { $replayCommand += '-StopOnFailure' }
if ($MaxTargets -gt 0) {
  $replayCommand += @('-MaxTargets', [string]$MaxTargets)
}
$replayCommandText = $replayCommand -join ' '

Write-Host "EB serial experiment"
Write-Host "Experiment: $($experiment.id)"
Write-Host "Controller: $Base"
Write-Host "Targets: $($targets.Count)"
Write-Host "Workloads: $($workloads -join ', ')"
Write-Host "Results: $aggregatePath"

Write-Event ([ordered]@{
  ts = (Get-Date).ToString('o')
  event = 'experiment_start'
  experiment_id = $experiment.id
  controller = $Base
  target_count = $targets.Count
  workloads = $workloads
})

[ordered]@{
  schema_version = 1
  benchmark = 'EB'
  created_at = (Get-Date).ToString('o')
  experiment_path = (Resolve-Path -LiteralPath $ExperimentPath).Path
  targets_path = (Resolve-Path -LiteralPath $TargetsPath).Path
  controller = $Base
  git_head = $gitHead
  command = $replayCommandText
  result_root = (Resolve-Path -LiteralPath $ResultRoot).Path
  aggregate_results = (Join-Path $ResultRoot 'results.jsonl')
  events = (Join-Path $ResultRoot 'events.jsonl')
  critique = (Join-Path $ResultRoot 'critique.md')
  critique_json = (Join-Path $ResultRoot 'critique.json')
  keep_run_outputs = (-not $PruneRunOutputs.IsPresent) -or $KeepRunOutputs.IsPresent
  targets = @($targets | ForEach-Object {
    [ordered]@{
      set_id = $_.set_id
      profile_id = $_.profile_id
      parameter_count_b = $_.parameter_count_b
      context_tokens = $_.context_tokens
      runtime_family = $_.runtime_family
      requires_gx10 = $_.requires_gx10
    }
  })
  workloads = $workloads
} | ConvertTo-Json -Depth 16 | Set-Content -LiteralPath (Join-Path $ResultRoot 'run.json') -Encoding UTF8

foreach ($target in $targets) {
  Write-Host "=== target $($target.set_id) ($($target.parameter_count_b)B ctx $($target.context_tokens)) ==="
  Write-Event ([ordered]@{ ts=(Get-Date).ToString('o'); event='target_start'; set_id=$target.set_id; context_tokens=$target.context_tokens })

  try {
    $act = Activate-Set $Base $target.set_id
    $cur = Invoke-JsonGet "$Base/api/llm-host/current" 20
    if ($cur.swap -and $cur.swap.reconcile_needed) {
      throw "controller reports reconcile_needed=true detail=$($cur.swap.failure_detail)"
    }
    if ($cur.desired_state -and $cur.desired_state.state -eq 'failed') {
      throw "controller desired_state failed detail=$($cur.desired_state.status_detail)"
    }
    $lane = $cur.lanes.large
    $servedModel = Get-ServedModelId $lane
    Write-Event ([ordered]@{
      ts = (Get-Date).ToString('o')
      event = 'target_ready'
      set_id = $target.set_id
      activation_status = if ($act) { $act.status } else { $null }
      lane_base_url = $lane.base_url
      served_model_id = $servedModel
    })

    foreach ($workload in $workloads) {
      Write-Host "--- workload $workload on $($target.set_id) ---"
      $workloadRoot = Join-Path $ResultRoot "workloads/$($target.set_id)/$workload"
      $workloadResults = Join-Path $workloadRoot 'results.jsonl'
      try {
        & (Join-Path $PSScriptRoot 'run_entropy_workload.ps1') `
          -Workload $workload `
          -Mode api `
          -ApiBaseUrl $lane.base_url `
          -Model $servedModel `
          -TargetSetId $target.set_id `
          -ContextTokens ([int]$target.context_tokens) `
          -HarnessMode $harnessMode `
          -OutputRoot $workloadRoot `
          -ResultPath $workloadResults | Out-Host

        if (Test-Path -LiteralPath $workloadResults) {
          Get-Content -LiteralPath $workloadResults | Add-Content -LiteralPath $aggregatePath -Encoding UTF8
        }
        Write-Event ([ordered]@{ ts=(Get-Date).ToString('o'); event='workload_done'; set_id=$target.set_id; workload=$workload })
      } catch {
        if (Test-Path -LiteralPath $workloadResults) {
          Get-Content -LiteralPath $workloadResults | Add-Content -LiteralPath $aggregatePath -Encoding UTF8
        }
        Write-Event ([ordered]@{ ts=(Get-Date).ToString('o'); event='workload_failed'; set_id=$target.set_id; workload=$workload; error=$_.Exception.Message })
        Write-Host "FAILED workload $workload on $($target.set_id): $($_.Exception.Message)"
        if ($StopOnFailure) { throw }
      }

      if ($PruneRunOutputs -and -not $KeepRunOutputs -and (Test-Path -LiteralPath $workloadRoot)) {
        Remove-Item -LiteralPath $workloadRoot -Recurse -Force -ErrorAction SilentlyContinue
      }
    }
  } catch {
    Write-Event ([ordered]@{ ts=(Get-Date).ToString('o'); event='target_failed'; set_id=$target.set_id; error=$_.Exception.Message })
    Write-Host "FAILED target $($target.set_id): $($_.Exception.Message)"
    if ($StopOnFailure) { throw }
  }
}

Write-Event ([ordered]@{ ts=(Get-Date).ToString('o'); event='experiment_done'; results=$aggregatePath })
if (-not $SkipCritique -and (Test-Path -LiteralPath $aggregatePath)) {
  & (Join-Path $PSScriptRoot 'write_eb_run_critique.ps1') -RunRoot $ResultRoot -OutputMarkdown $critiqueMarkdownPath -OutputJson $critiqueJsonPath | Out-Host
  Write-Event ([ordered]@{ ts=(Get-Date).ToString('o'); event='critique_written'; markdown=$critiqueMarkdownPath; json=$critiqueJsonPath })
}
Write-Host "Complete: $aggregatePath"
