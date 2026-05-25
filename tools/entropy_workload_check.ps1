param(
  [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path,
  [string]$SpecPath = '',
  [string]$SchemaPath = ''
)

$ErrorActionPreference = 'Stop'

if (-not $SpecPath) {
  $SpecPath = Join-Path $Root 'benchmarks/entropy_workloads/workloads.json'
}
if (-not $SchemaPath) {
  $SchemaPath = Join-Path $Root 'benchmarks/entropy_workloads/schema.json'
}

function Fail($message) {
  throw "entropy workload check failed: $message"
}

function Assert-File($path) {
  if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
    Fail "missing file: $path"
  }
}

function Read-JsonFile($path) {
  Assert-File $path
  try {
    return Get-Content -Raw -LiteralPath $path | ConvertFrom-Json -Depth 64
  } catch {
    Fail "invalid json in ${path}: $($_.Exception.Message)"
  }
}

function Assert-NonEmptyString($value, $field) {
  if ($null -eq $value -or [string]::IsNullOrWhiteSpace([string]$value)) {
    Fail "missing or empty field: $field"
  }
}

function Assert-Array($value, $field, [int]$minCount = 1) {
  if ($null -eq $value) { Fail "missing array: $field" }
  $items = @($value)
  if ($items.Count -lt $minCount) {
    Fail "array $field must contain at least $minCount item(s)"
  }
  return $items
}

function Assert-UniqueIds($items, $field) {
  $seen = @{}
  foreach ($item in $items) {
    Assert-NonEmptyString $item.id "$field.id"
    if ($seen.ContainsKey($item.id)) {
      Fail "duplicate id in ${field}: $($item.id)"
    }
    $seen[$item.id] = $true
  }
}

$schema = Read-JsonFile $SchemaPath
$spec = Read-JsonFile $SpecPath

Assert-NonEmptyString $schema.schema_version 'schema.schema_version'
Assert-NonEmptyString $schema.result_record.description 'schema.result_record.description'

$requiredResultFields = Assert-Array $schema.result_record.required_fields 'schema.result_record.required_fields' 8
foreach ($field in @('run_id','target_set_id','model_id','context_tokens','harness_mode','workload_id','stage_id','status','failure_class')) {
  if ($requiredResultFields -notcontains $field) {
    Fail "schema.result_record.required_fields missing $field"
  }
}

Assert-NonEmptyString $spec.schema_version 'workloads.schema_version'
$workloads = Assert-Array $spec.workloads 'workloads.workloads' 3
Assert-UniqueIds $workloads 'workloads'

$requiredWorkloads = @('webpage-chain','library-chain','factory')
foreach ($required in $requiredWorkloads) {
  if (-not ($workloads | Where-Object { $_.id -eq $required })) {
    Fail "missing workload: $required"
  }
}

foreach ($workload in $workloads) {
  Assert-NonEmptyString $workload.id 'workload.id'
  Assert-NonEmptyString $workload.name "workload[$($workload.id)].name"
  Assert-NonEmptyString $workload.breakpoint_metric "workload[$($workload.id)].breakpoint_metric"
  $stages = Assert-Array $workload.stages "workload[$($workload.id)].stages" 2
  Assert-UniqueIds $stages "workload[$($workload.id)].stages"

  $expectedOrder = 1
  foreach ($stage in $stages) {
    if ([int]$stage.order -ne $expectedOrder) {
      Fail "workload $($workload.id) stage $($stage.id) has order $($stage.order), expected $expectedOrder"
    }
    Assert-NonEmptyString $stage.prompt_goal "workload[$($workload.id)].stage[$($stage.id)].prompt_goal"
    $artifacts = Assert-Array $stage.expected_artifacts "workload[$($workload.id)].stage[$($stage.id)].expected_artifacts"
    $validators = Assert-Array $stage.validators "workload[$($workload.id)].stage[$($stage.id)].validators"
    foreach ($artifact in $artifacts) {
      Assert-NonEmptyString $artifact.path "workload[$($workload.id)].stage[$($stage.id)].artifact.path"
      Assert-NonEmptyString $artifact.kind "workload[$($workload.id)].stage[$($stage.id)].artifact.kind"
    }
    foreach ($validator in $validators) {
      Assert-NonEmptyString $validator.id "workload[$($workload.id)].stage[$($stage.id)].validator.id"
      Assert-NonEmptyString $validator.failure_class "workload[$($workload.id)].stage[$($stage.id)].validator.failure_class"
    }
    $expectedOrder++
  }
}

Write-Host "entropy workload check passed: $($workloads.Count) workloads, $((@($workloads | ForEach-Object { @($_.stages).Count }) | Measure-Object -Sum).Sum) stages"
