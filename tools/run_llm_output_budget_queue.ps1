param(
  [string]$QueuePath = (Join-Path (Resolve-Path (Join-Path $PSScriptRoot '..')).Path 'benchmarks/entropy_workloads/output-budget.final-candidates.targets.json'),
  [string]$BaseUrl = 'http://192.168.1.203:4000',
  [string]$ResultRoot = (Join-Path (Resolve-Path (Join-Path $PSScriptRoot '..')).Path 'runs/llmcommune_output_budget'),
  [int[]]$MaxTokens = @(),
  [string]$MirrorNotePath = 'E:\Dev\AI\remote\llmcommune\docs\output-budget-findings.md',
  [switch]$SkipCompleted
)

$ErrorActionPreference = 'Stop'

$queue = Get-Content -Raw -LiteralPath $QueuePath | ConvertFrom-Json -Depth 32
New-Item -ItemType Directory -Force -Path $ResultRoot | Out-Null
if ($MirrorNotePath) {
  New-Item -ItemType Directory -Force -Path (Split-Path $MirrorNotePath) | Out-Null
  if (-not (Test-Path -LiteralPath $MirrorNotePath)) {
    @(
      '# LLMCommune Output Budget Findings'
      ''
      'This file records live completion-budget probes for Entropy/EB targets served through LLMCommune.'
      ''
      '| Checked | Set | Profile | Context | Requested | Completion | Finish | Seconds | Result |'
      '|---|---|---|---:|---:|---:|---|---:|---|'
    ) | Set-Content -LiteralPath $MirrorNotePath -Encoding UTF8
  }
}

function Get-TargetTokens($target) {
  $targetTokens = @()
  if ($MaxTokens.Count -gt 0) {
    $targetTokens = @($MaxTokens)
  } elseif ($target.max_tokens) {
    $targetTokens = @($target.max_tokens | ForEach-Object { [int]$_ })
  } elseif ($queue.max_tokens) {
    $targetTokens = @($queue.max_tokens | ForEach-Object { [int]$_ })
  } else {
    $targetTokens = @(8192, 16384, 32768)
  }
  return @($targetTokens | Sort-Object -Unique)
}

function Test-Completed($path, $tokens) {
  if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { return $false }
  $rows = @(Get-Content -LiteralPath $path | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object { $_ | ConvertFrom-Json -Depth 32 })
  foreach ($token in $tokens) {
    if (-not @($rows | Where-Object { [int]$_.requested_max_tokens -eq [int]$token }).Count) {
      return $false
    }
  }
  return $true
}

function Append-MirrorRows($path) {
  if (-not $MirrorNotePath) { return }
  if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { return }
  $rows = @(Get-Content -LiteralPath $path | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object { $_ | ConvertFrom-Json -Depth 32 })
  foreach ($row in $rows) {
    $result = if ($row.result) { [string]$row.result } elseif ($row.ok -eq $true) { 'ok' } else { 'fail' }
    $finish = if ($row.finish_reason) { [string]$row.finish_reason } else { '' }
    $completion = if ($null -ne $row.completion_tokens) { [string]$row.completion_tokens } else { '' }
    $line = "| $($row.checked_at) | $($row.set_id) | $($row.profile_id) | $($row.context_tokens) | $($row.requested_max_tokens) | $completion | $finish | $($row.elapsed_s) | $result |"
    Add-Content -LiteralPath $MirrorNotePath -Value $line -Encoding UTF8
  }
}

$targets = @($queue.targets | Where-Object { $_.enabled -ne $false })
Write-Host "LLM output-budget queue: $($queue.id)"
Write-Host "Targets: $($targets.Count)"

foreach ($target in $targets) {
  $setId = [string]$target.set_id
  $tokens = Get-TargetTokens $target
  $resultPath = Join-Path $ResultRoot "$setId.output-budget.jsonl"

  if ($SkipCompleted -and (Test-Completed $resultPath $tokens)) {
    Write-Host "=== skip completed $setId ==="
    continue
  }

  Write-Host "=== output budget probe $setId tokens=$($tokens -join ',') ==="
  & (Join-Path $PSScriptRoot 'probe_llm_output_budget.ps1') `
    -BaseUrl $BaseUrl `
    -SetId $setId `
    -MaxTokens $tokens `
    -ResultPath $resultPath | Out-Host

  Append-MirrorRows $resultPath
}

Write-Host "LLM output-budget queue complete"
