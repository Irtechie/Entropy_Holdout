param(
  [Parameter(Mandatory=$true)]
  [string]$ResultsPath,
  [switch]$Json
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $ResultsPath -PathType Leaf)) {
  throw "missing results file: $ResultsPath"
}

$rows = @(Get-Content -LiteralPath $ResultsPath | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object {
  $_ | ConvertFrom-Json -Depth 32
})

if ($rows.Count -eq 0) {
  throw "results file has no rows: $ResultsPath"
}

$groups = $rows | Group-Object target_set_id, model_id, context_tokens, harness_mode, workload_id
$summary = foreach ($group in $groups) {
  $items = @($group.Group | Sort-Object stage_order)
  $failed = @($items | Where-Object { $_.status -ne 'pass' } | Select-Object -First 1)
  $passed = @($items | Where-Object { $_.status -eq 'pass' })
  $first = $items[0]
  [pscustomobject]@{
    target_set_id = $first.target_set_id
    model_id = $first.model_id
    context_tokens = [int]$first.context_tokens
    harness_mode = $first.harness_mode
    workload_id = $first.workload_id
    stages_seen = $items.Count
    max_pass_stage = if ($passed.Count) { [int](($passed | Measure-Object stage_order -Maximum).Maximum) } else { 0 }
    first_fail_stage = if ($failed.Count) { $failed[0].stage_id } else { $null }
    first_failure_class = if ($failed.Count) { $failed[0].failure_class } else { 'none' }
  }
}

if ($Json) {
  $summary | ConvertTo-Json -Depth 8
  return
}

$summary | Sort-Object target_set_id, workload_id | Format-Table target_set_id, model_id, context_tokens, harness_mode, workload_id, stages_seen, max_pass_stage, first_fail_stage, first_failure_class -AutoSize
