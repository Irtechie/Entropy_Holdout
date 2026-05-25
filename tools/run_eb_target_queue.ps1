param(
  [string]$QueuePath = (Join-Path (Resolve-Path (Join-Path $PSScriptRoot '..')).Path 'benchmarks/entropy_workloads/wave1.remaining.targets.json'),
  [string]$ExperimentPath = (Join-Path (Resolve-Path (Join-Path $PSScriptRoot '..')).Path 'benchmarks/entropy_workloads/experiment.local-full-singlebox.json'),
  [string]$ResultRootBase = (Join-Path (Resolve-Path (Join-Path $PSScriptRoot '..')).Path 'runs/EB'),
  [string]$RunPrefix = '',
  [string]$Remote = 'origin',
  [string]$Branch = '',
  [switch]$CommitEach,
  [switch]$PushEach,
  [switch]$SkipCompleted,
  [switch]$ContinueAfterWedge,
  [switch]$WhatIf
)

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$queue = Get-Content -Raw -LiteralPath $QueuePath | ConvertFrom-Json -Depth 32
$experiment = Get-Content -Raw -LiteralPath $ExperimentPath | ConvertFrom-Json -Depth 32
$baseUrl = if ($experiment.base_url) { [string]$experiment.base_url } else { 'http://192.168.1.203:4000' }
if (-not $RunPrefix) {
  if ($queue.run_prefix) {
    $RunPrefix = [string]$queue.run_prefix
  } elseif ($experiment.harness_mode -and [string]$experiment.harness_mode -ne 'plain') {
    $RunPrefix = "EB-$($experiment.harness_mode)"
  } else {
    $RunPrefix = 'EB'
  }
}
if (-not $Branch) {
  $Branch = (git -C $repoRoot rev-parse --abbrev-ref HEAD).Trim()
}

function Write-JsonFile($path, $obj) {
  New-Item -ItemType Directory -Force -Path (Split-Path $path) | Out-Null
  $obj | ConvertTo-Json -Depth 32 | Set-Content -LiteralPath $path -Encoding UTF8
}

function Test-CompletedTargetRun($targetSetId) {
  $pattern = "$RunPrefix-$targetSetId-*"
  $matches = @(Get-ChildItem -LiteralPath $ResultRootBase -Directory -Filter $pattern -ErrorAction SilentlyContinue | Where-Object {
    (Test-Path -LiteralPath (Join-Path $_.FullName 'results.jsonl')) -and
    (Test-Path -LiteralPath (Join-Path $_.FullName 'critique.md')) -and
    (Test-Path -LiteralPath (Join-Path $_.FullName 'critique.json'))
  })
  return ($matches.Count -gt 0)
}

function Get-ControllerWedgeState {
  try {
    $current = Invoke-RestMethod -TimeoutSec 20 -Uri "$baseUrl/api/llm-host/current"
    $reconcileNeeded = $false
    $desiredFailed = $false
    $detail = ''
    if ($current.swap -and $current.swap.reconcile_needed) {
      $reconcileNeeded = $true
      $detail = [string]$current.swap.failure_detail
    }
    if ($current.desired_state -and $current.desired_state.state -eq 'failed') {
      $desiredFailed = $true
      $detail = [string]$current.desired_state.status_detail
    }
    return [pscustomobject]@{
      ok = (-not $reconcileNeeded -and -not $desiredFailed)
      wedge_risk = ($reconcileNeeded -or $desiredFailed)
      detail = $detail
      raw = $current
    }
  } catch {
    return [pscustomobject]@{
      ok = $false
      wedge_risk = $true
      detail = $_.Exception.Message
      raw = $null
    }
  }
}

function Invoke-GitCommitAndPush($targetSetId, $runRoot) {
  if (-not $CommitEach) { return }

  $relativeRunRoot = [System.IO.Path]::GetRelativePath($repoRoot, (Resolve-Path -LiteralPath $runRoot).Path).Replace('\','/')
  git -C $repoRoot add -- $relativeRunRoot
  $status = (git -C $repoRoot status --short -- $relativeRunRoot)
  if (-not $status) {
    Write-Host "No staged changes for $targetSetId"
    return
  }

  git -C $repoRoot commit -m "data: add EB run for $targetSetId"
  if ($PushEach) {
    git -C $repoRoot push $Remote $Branch
  }
}

$targets = @($queue.targets | Where-Object { $_.enabled -ne $false })
Write-Host "EB target queue: $($queue.id)"
Write-Host "Targets: $($targets.Count)"
Write-Host "RunPrefix=$RunPrefix"
Write-Host "CommitEach=$($CommitEach.IsPresent) PushEach=$($PushEach.IsPresent) SkipCompleted=$($SkipCompleted.IsPresent)"

foreach ($target in $targets) {
  $setId = [string]$target.set_id
  if ($SkipCompleted -and (Test-CompletedTargetRun $setId)) {
    Write-Host "=== skip completed $setId ==="
    continue
  }

  $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
  $runRoot = Join-Path $ResultRootBase "$RunPrefix-$setId-$stamp"
  Write-Host "=== EB target $setId ==="
  Write-Host "Run root: $runRoot"

  if ($WhatIf) {
    continue
  }

  $started = Get-Date
  $runnerExitCode = 0
  try {
    & (Join-Path $PSScriptRoot 'run_entropy_serial_experiment.ps1') `
      -ExperimentPath $ExperimentPath `
      -OnlySet $setId `
      -ResultRoot $runRoot | Out-Host
    $runnerExitCode = $LASTEXITCODE
  } catch {
    $runnerExitCode = 1
    Write-Host "Runner threw for ${setId}: $($_.Exception.Message)"
  }

  $resultsPath = Join-Path $runRoot 'results.jsonl'
  $critiquePath = Join-Path $runRoot 'critique.md'
  $critiqueJsonPath = Join-Path $runRoot 'critique.json'
  $reportPath = Join-Path $runRoot 'report.json'
  $statusPath = Join-Path $runRoot 'queue-status.json'
  $hasCompleteRun = (
    (Test-Path -LiteralPath $resultsPath) -and
    (Test-Path -LiteralPath $critiquePath) -and
    (Test-Path -LiteralPath $critiqueJsonPath)
  )

  $infraState = $null
  if ($hasCompleteRun) {
    try {
      $report = & (Join-Path $PSScriptRoot 'report_entropy_results.ps1') -ResultsPath $resultsPath -Json
      $report | Set-Content -LiteralPath $reportPath -Encoding UTF8
      $classification = 'completed-data-run'
    } catch {
      $classification = 'completed-with-report-failure'
      $reportError = $_.Exception.Message
    }
  } else {
    $infraState = Get-ControllerWedgeState
    $classification = if ($infraState.wedge_risk) { 'blocked-wedge-risk' } else { 'infra-failure-non-wedge' }
    Write-JsonFile (Join-Path $runRoot 'infra-failure.json') ([ordered]@{
      target_set_id = $setId
      classification = $classification
      controller = $baseUrl
      runner_exit_code = $runnerExitCode
      wedge_detail = $infraState.detail
      checked_at = (Get-Date).ToString('o')
    })
  }

  Write-JsonFile $statusPath ([ordered]@{
    queue_id = $queue.id
    target_set_id = $setId
    slice_id = $target.slice_id
    classification = $classification
    run_root = $runRoot
    started_at = $started.ToString('o')
    finished_at = (Get-Date).ToString('o')
    elapsed_s = [math]::Round(((Get-Date) - $started).TotalSeconds, 1)
    runner_exit_code = $runnerExitCode
    results = if (Test-Path -LiteralPath $resultsPath) { $resultsPath } else { $null }
    critique = if (Test-Path -LiteralPath $critiquePath) { $critiquePath } else { $null }
    critique_json = if (Test-Path -LiteralPath $critiqueJsonPath) { $critiqueJsonPath } else { $null }
    report_json = if (Test-Path -LiteralPath $reportPath) { $reportPath } else { $null }
    wedge_risk = if ($infraState) { $infraState.wedge_risk } else { $false }
    wedge_detail = if ($infraState) { $infraState.detail } else { $null }
  })

  Invoke-GitCommitAndPush $setId $runRoot

  if ($classification -eq 'blocked-wedge-risk' -and -not $ContinueAfterWedge) {
    throw "Stopping EB queue after wedge-risk failure for ${setId}: $($infraState.detail)"
  }
}

Write-Host "EB target queue complete"
