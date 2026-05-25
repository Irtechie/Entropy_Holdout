param(
  [string]$Matrix = (Join-Path (Resolve-Path (Join-Path $PSScriptRoot '..')).Path 'benchmarks/entropy_workloads/matrix.default.json'),
  [ValidateSet('mock')]
  [string]$Mode = '',
  [string]$ResultPath = '',
  [switch]$KeepRunOutputs
)

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$matrixSpec = Get-Content -Raw -LiteralPath $Matrix | ConvertFrom-Json -Depth 32
if (-not $Mode) {
  $Mode = $matrixSpec.mode
}
if (-not $ResultPath) {
  $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
  $ResultPath = Join-Path $repoRoot "runs/entropy_matrix/$($matrixSpec.id)-$stamp/results.jsonl"
}

New-Item -ItemType Directory -Force -Path (Split-Path $ResultPath) | Out-Null
if (Test-Path -LiteralPath $ResultPath) {
  Remove-Item -LiteralPath $ResultPath -Force
}

$runRoot = Join-Path (Split-Path $ResultPath) 'workloads'
New-Item -ItemType Directory -Force -Path $runRoot | Out-Null

foreach ($target in @($matrixSpec.targets)) {
  foreach ($workload in @($matrixSpec.workloads)) {
    $workloadRoot = Join-Path $runRoot "$($target.target_set_id)-$workload"
    $workloadResults = Join-Path $workloadRoot 'results.jsonl'
    & (Join-Path $PSScriptRoot 'run_entropy_workload.ps1') -Workload $workload -Mode $Mode -OutputRoot $workloadRoot -ResultPath $workloadResults | Out-Host
    if (-not $?) {
      throw "workload run failed: $workload"
    }
    foreach ($line in Get-Content -LiteralPath $workloadResults) {
      if ([string]::IsNullOrWhiteSpace($line)) { continue }
      $row = $line | ConvertFrom-Json -Depth 32
      $row.target_set_id = $target.target_set_id
      $row.model_id = $target.model_id
      $row.context_tokens = $target.context_tokens
      $row.harness_mode = $target.harness_mode
      $row | ConvertTo-Json -Depth 32 -Compress | Add-Content -LiteralPath $ResultPath -Encoding UTF8
    }
  }
}

if (-not $KeepRunOutputs) {
  Remove-Item -LiteralPath $runRoot -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host "entropy matrix complete: $ResultPath"
