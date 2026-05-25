param(
  [string]$RunRoot = '',
  [string]$ResultsPath = '',
  [string]$OutputMarkdown = '',
  [string]$OutputJson = ''
)

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

if (-not $RunRoot -and -not $ResultsPath) {
  throw "provide -RunRoot or -ResultsPath"
}

if ($RunRoot) {
  $RunRoot = (Resolve-Path -LiteralPath $RunRoot).Path
  if (-not $ResultsPath) {
    $ResultsPath = Join-Path $RunRoot 'results.jsonl'
  }
}

$ResultsPath = (Resolve-Path -LiteralPath $ResultsPath).Path
if (-not $RunRoot) {
  $RunRoot = Split-Path -Parent $ResultsPath
}

if (-not $OutputMarkdown) {
  $OutputMarkdown = Join-Path $RunRoot 'critique.md'
}
if (-not $OutputJson) {
  $OutputJson = Join-Path $RunRoot 'critique.json'
}

$workloadSpecPath = Join-Path $repoRoot 'benchmarks/entropy_workloads/workloads.json'
$workloadSpec = Get-Content -Raw -LiteralPath $workloadSpecPath | ConvertFrom-Json -Depth 64
$workloadsById = @{}
foreach ($workload in @($workloadSpec.workloads)) {
  $workloadsById[[string]$workload.id] = $workload
}

$rows = @(Get-Content -LiteralPath $ResultsPath | Where-Object {
  -not [string]::IsNullOrWhiteSpace($_)
} | ForEach-Object {
  $_ | ConvertFrom-Json -Depth 64
})

if ($rows.Count -eq 0) {
  throw "results file has no rows: $ResultsPath"
}

function Get-PropValue($obj, $name) {
  if ($null -eq $obj) { return $null }
  $prop = $obj.PSObject.Properties[$name]
  if ($prop) { return $prop.Value }
  return $null
}

function Sum-Usage($items, $name) {
  $values = @($items | ForEach-Object {
    $value = Get-PropValue $_.token_usage $name
    if ($null -ne $value -and "$value" -match '^\d+$') { [int64]$value }
  })
  if ($values.Count -eq 0) { return $null }
  return [int64](($values | Measure-Object -Sum).Sum)
}

function Get-Cause($failureClass, $message) {
  $msg = [string]$message
  switch ($failureClass) {
    'generation' {
      if ($msg -match 'placeholder') { return 'The model copied the output schema placeholder instead of producing real files.' }
      if ($msg -match 'JSON|json') { return 'The model lost the strict JSON response contract before code could be evaluated.' }
      if ($msg -match 'expected artifact') { return 'The model produced files, but not at the paths required by the stage contract.' }
      return 'The model failed the code-generation output contract before validation could complete.'
    }
    'missing_artifact' { return 'The generated tree did not preserve or create a required artifact.' }
    'link_integrity' { return 'The model lost cross-page link state while extending the existing website.' }
    'shared_state' { return 'The model could not maintain a shared invariant across all previously generated files.' }
    'api_contract' { return 'The model drifted from the public API or dependency contract created in earlier stages.' }
    'dependency_graph' { return 'The generated components no longer form a valid dependency graph.' }
    'configuration' { return 'The model could not keep configuration and runtime behavior aligned.' }
    'runtime_behavior' { return 'The files existed, but the generated system did not execute the required behavior.' }
    'build' { return 'The generated project structure or source did not build.' }
    'harness' { return 'The harness or validator surfaced an unexpected failure outside the workload contract.' }
    'none' { return 'No failure was recorded for this target/workload.' }
    default { return 'The failure class is not mapped yet; inspect the raw response and generated files.' }
  }
}

function Get-Score($plannedStages, $maxPassStage, $firstFailureClass, $firstFailStage) {
  if ($plannedStages -le 0) { return 0 }
  if (-not $firstFailStage -and $maxPassStage -ge $plannedStages) { return 5 }
  if ($maxPassStage -le 0) { return 0 }
  if ($maxPassStage -ge $plannedStages) { return 4 }
  $ratio = $maxPassStage / $plannedStages
  if ($ratio -ge 0.75) { return 3 }
  if ($ratio -ge 0.5) { return 2 }
  return 1
}

function Get-DimensionScores($plannedStages, $maxPassStage, $firstFailureClass, $firstFailStage, $error) {
  $completion = Get-Score $plannedStages $maxPassStage $firstFailureClass $firstFailStage
  $ratioScore = if ($plannedStages -gt 0) { [math]::Min(5, [math]::Round(($maxPassStage / $plannedStages) * 5, 0)) } else { 0 }
  $output = $completion
  if ($firstFailureClass -eq 'generation') {
    $output = if ([string]$error -match 'placeholder|JSON|json') { 0 } else { 1 }
  }
  $continuity = $completion
  if ($firstFailureClass -in @('missing_artifact','link_integrity','shared_state')) {
    $continuity = [math]::Max(0, $completion - 1)
  }
  $dependency = $completion
  if ($firstFailureClass -in @('api_contract','dependency_graph','configuration','runtime_behavior','build')) {
    $dependency = [math]::Max(0, $completion - 1)
  }
  $validator = if (-not $firstFailStage -and $maxPassStage -ge $plannedStages) {
    5
  } elseif ($firstFailStage -eq 'final-validation') {
    3
  } else {
    [math]::Min(2, $completion)
  }

  return [ordered]@{
    output_contract = [int]$output
    artifact_continuity = [int]$continuity
    dependency_retention = [int]$dependency
    validator_readiness = [int]$validator
    entropy_pressure = [int]$ratioScore
  }
}

$groups = $rows | Group-Object target_set_id, model_id, context_tokens, harness_mode, workload_id
$critiques = foreach ($group in $groups) {
  $items = @($group.Group | Sort-Object stage_order)
  $first = $items[0]
  $workloadId = [string]$first.workload_id
  $plannedStages = 0
  $breakpointMetric = ''
  if ($workloadsById.ContainsKey($workloadId)) {
    $plannedStages = @($workloadsById[$workloadId].stages).Count
    $breakpointMetric = [string]$workloadsById[$workloadId].breakpoint_metric
  }

  $failed = @($items | Where-Object { $_.status -ne 'pass' } | Select-Object -First 1)
  $passed = @($items | Where-Object { $_.status -eq 'pass' })
  $maxPassStage = if ($passed.Count) { [int](($passed | Measure-Object stage_order -Maximum).Maximum) } else { 0 }
  $firstFailStage = if ($failed.Count) { [string]$failed[0].stage_id } else { $null }
  $failureClass = if ($failed.Count) { [string]$failed[0].failure_class } else { 'none' }
  $firstError = if ($failed.Count) { [string]$failed[0].error } else { '' }
  $score = Get-Score $plannedStages $maxPassStage $failureClass $firstFailStage
  $dimensions = Get-DimensionScores $plannedStages $maxPassStage $failureClass $firstFailStage $firstError
  $normalized = if ($plannedStages -gt 0) { [math]::Round($maxPassStage / $plannedStages, 3) } else { 0 }
  $rawPaths = @($items | ForEach-Object { $_.raw_response_json_path; $_.raw_response_path } | Where-Object { $_ } | Select-Object -Unique)
  $promptPaths = @($items | ForEach-Object { $_.prompt_path } | Where-Object { $_ } | Select-Object -Unique)
  $generatedFiles = @($items | ForEach-Object { @($_.generated_files) } | Where-Object { $_ } | Select-Object -Unique)

  [ordered]@{
    target_set_id = [string]$first.target_set_id
    model_id = [string]$first.model_id
    context_tokens = [int]$first.context_tokens
    harness_mode = [string]$first.harness_mode
    workload_id = $workloadId
    planned_stage_count = [int]$plannedStages
    stages_seen = [int]$items.Count
    max_pass_stage = [int]$maxPassStage
    entropy_right_shift = [ordered]@{
      passed_stages = [int]$maxPassStage
      possible_stages = [int]$plannedStages
      normalized = $normalized
      final_validation_passed = (-not $firstFailStage -and $maxPassStage -ge $plannedStages)
    }
    first_fail_stage = $firstFailStage
    first_failure_class = $failureClass
    first_error = $firstError
    likely_entropy_cause = Get-Cause $failureClass $firstError
    eb_score = [int]$score
    dimension_scores = $dimensions
    token_usage = [ordered]@{
      prompt_tokens = Sum-Usage $items 'prompt_tokens'
      completion_tokens = Sum-Usage $items 'completion_tokens'
      total_tokens = Sum-Usage $items 'total_tokens'
    }
    breakpoint_metric = $breakpointMetric
    raw_response_paths = $rawPaths
    prompt_paths = $promptPaths
    generated_file_count = [int]$generatedFiles.Count
    generated_files = $generatedFiles
  }
}

$totals = [ordered]@{
  target_workload_count = [int]$critiques.Count
  fully_validated_count = [int]@($critiques | Where-Object { $_.entropy_right_shift.final_validation_passed }).Count
  prompt_tokens = Sum-Usage $rows 'prompt_tokens'
  completion_tokens = Sum-Usage $rows 'completion_tokens'
  total_tokens = Sum-Usage $rows 'total_tokens'
}

$critiqueJson = [ordered]@{
  schema_version = 1
  benchmark = 'EB'
  generated_at = (Get-Date).ToString('o')
  run_root = $RunRoot
  results_path = $ResultsPath
  rubric = [ordered]@{
    scale = '0-5'
    score_meaning = [ordered]@{
      '0' = 'No valid stage output or strict output contract failure before code evaluation.'
      '1' = 'Only first-stage or minimal artifact progress.'
      '2' = 'Some local continuity, but breaks before deeper dependency pressure.'
      '3' = 'Meaningful cross-stage progress, but breaks before completing workload invariants.'
      '4' = 'All planned generation stages completed, but final validator failed.'
      '5' = 'All planned generation stages and final validation passed.'
    }
    dimensions = @('output_contract','artifact_continuity','dependency_retention','validator_readiness','entropy_pressure')
  }
  totals = $totals
  critiques = @($critiques)
}

$critiqueJson | ConvertTo-Json -Depth 64 | Set-Content -LiteralPath $OutputJson -Encoding UTF8

$lines = New-Object System.Collections.Generic.List[string]
$lines.Add('# EB Run Critique')
$lines.Add('')
$lines.Add("- Generated: $($critiqueJson.generated_at)")
$lines.Add("- Run root: ``$RunRoot``")
$lines.Add("- Results: ``$ResultsPath``")
$lines.Add("- Critique JSON: ``$OutputJson``")
$lines.Add('')
$lines.Add('## Rubric')
$lines.Add('')
$lines.Add('Score is always 0-5: 0 means output-contract failure before useful code evaluation; 1 means minimal first-stage progress; 2 means partial local continuity; 3 means meaningful cross-stage progress; 4 means all generation stages completed but final validation failed; 5 means full workload validation passed.')
$lines.Add('')
$lines.Add('Each critique also scores output contract, artifact continuity, dependency retention, validator readiness, and entropy pressure on the same 0-5 scale.')
$lines.Add('')
$lines.Add('## Summary')
$lines.Add('')
$lines.Add('| Target | Workload | Harness | Context | EB | Right shift | First fail | Cause | Tokens |')
$lines.Add('|---|---|---|---:|---:|---:|---|---|---:|')
foreach ($item in @($critiques | Sort-Object target_set_id, workload_id)) {
  $tokens = if ($null -ne $item.token_usage.total_tokens) { $item.token_usage.total_tokens } else { '' }
  $fail = if ($item.first_fail_stage) { "$($item.first_fail_stage) / $($item.first_failure_class)" } else { 'none' }
  $lines.Add("| $($item.target_set_id) | $($item.workload_id) | $($item.harness_mode) | $($item.context_tokens) | $($item.eb_score) | $($item.entropy_right_shift.passed_stages)/$($item.entropy_right_shift.possible_stages) | $fail | $($item.likely_entropy_cause) | $tokens |")
}

$lines.Add('')
$lines.Add('## Professional Critique')
foreach ($item in @($critiques | Sort-Object target_set_id, workload_id)) {
  $lines.Add('')
  $lines.Add("### $($item.target_set_id) / $($item.workload_id)")
  $lines.Add('')
  $lines.Add("- Model: ``$($item.model_id)``")
  $lines.Add("- Context: $($item.context_tokens)")
  $lines.Add("- EB score: $($item.eb_score)/5")
  $lines.Add("- Entropy right shift: $($item.entropy_right_shift.passed_stages)/$($item.entropy_right_shift.possible_stages) stages ($($item.entropy_right_shift.normalized))")
  $failText = if ($item.first_fail_stage) { "$($item.first_fail_stage) / $($item.first_failure_class)" } else { 'none' }
  $lines.Add("- First failure: $failText")
  if ($item.first_error) {
    $lines.Add("- Failure detail: $($item.first_error)")
  }
  $lines.Add("- Likely entropy cause: $($item.likely_entropy_cause)")
  $lines.Add("- Token usage: prompt=$($item.token_usage.prompt_tokens), completion=$($item.token_usage.completion_tokens), total=$($item.token_usage.total_tokens)")
  $lines.Add("- Dimension scores: output=$($item.dimension_scores.output_contract), continuity=$($item.dimension_scores.artifact_continuity), dependency=$($item.dimension_scores.dependency_retention), validator=$($item.dimension_scores.validator_readiness), pressure=$($item.dimension_scores.entropy_pressure)")
}

$lines | Set-Content -LiteralPath $OutputMarkdown -Encoding UTF8

Write-Host "Wrote EB critique: $OutputMarkdown"
Write-Host "Wrote EB critique JSON: $OutputJson"
