param(
  [Parameter(Mandatory=$true)]
  [string]$RunRoot,
  [string]$SpecPath = (Join-Path (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path 'benchmarks/entropy_workloads/library_chain.json')
)

$ErrorActionPreference = 'Stop'

function Fail($message) {
  throw "library-chain validation failed: $message"
}

function Read-JsonFile($path) {
  if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
    Fail "missing spec: $path"
  }
  return Get-Content -Raw -LiteralPath $path | ConvertFrom-Json -Depth 32
}

function Assert-Contains($text, $needle, $message) {
  if ($text -notlike "*$needle*") {
    Fail $message
  }
}

$spec = Read-JsonFile $SpecPath
$chainRoot = Join-Path $RunRoot $spec.output_dir
if (-not (Test-Path -LiteralPath $chainRoot -PathType Container)) {
  Fail "missing library chain directory: $chainRoot"
}

foreach ($project in @($spec.projects)) {
  $projectPath = Join-Path $chainRoot $project.path
  if (-not (Test-Path -LiteralPath $projectPath -PathType Leaf)) {
    Fail "missing project: $($project.path)"
  }
  $projectXml = Get-Content -Raw -LiteralPath $projectPath
  $normalizedProjectXml = $projectXml.Replace('/', '\')
  Assert-Contains $projectXml "<TargetFramework>$($spec.target_framework)</TargetFramework>" "project $($project.name) has wrong target framework"
  foreach ($reference in @($project.references)) {
    $expected = $reference.Replace('/', '\')
    Assert-Contains $normalizedProjectXml $expected "project $($project.name) missing reference $reference"
  }
}

$sampleProject = Join-Path $chainRoot 'SampleApp/SampleApp.csproj'
$buildOutput = & dotnet build $sampleProject --nologo --verbosity quiet 2>&1
if ($LASTEXITCODE -ne 0) {
  Fail "dotnet build failed: $($buildOutput -join "`n")"
}

$runOutput = & dotnet run --project $sampleProject --no-build --nologo 2>&1
if ($LASTEXITCODE -ne 0) {
  Fail "dotnet run failed: $($runOutput -join "`n")"
}

$actual = ($runOutput -join "`n").Trim()
if ($actual -ne $spec.sample_expected_output) {
  Fail "sample output '$actual' did not match '$($spec.sample_expected_output)'"
}

[pscustomobject]@{
  ok = $true
  workload = $spec.id
  projects_checked = @($spec.projects).Count
  sample_output = $actual
  chain_root = $chainRoot
} | ConvertTo-Json -Compress
