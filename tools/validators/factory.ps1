param(
  [Parameter(Mandatory=$true)]
  [string]$RunRoot,
  [string]$SpecPath = (Join-Path (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path 'benchmarks/entropy_workloads/factory.json')
)

$ErrorActionPreference = 'Stop'

function Fail($message) {
  throw "factory validation failed: $message"
}

function Read-JsonFile($path) {
  if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
    Fail "missing json file: $path"
  }
  return Get-Content -Raw -LiteralPath $path | ConvertFrom-Json -Depth 32
}

$spec = Read-JsonFile $SpecPath
$factoryRoot = Join-Path $RunRoot $spec.output_dir
if (-not (Test-Path -LiteralPath $factoryRoot -PathType Container)) {
  Fail "missing factory directory: $factoryRoot"
}

$configPath = Join-Path $factoryRoot 'config/stations.json'
$scriptPath = Join-Path $factoryRoot 'src/factory.ps1'
$reportPath = Join-Path $factoryRoot 'dashboard/report.json'

$config = Read-JsonFile $configPath
if (@($config.stations).Count -ne @($spec.stations).Count) {
  Fail "station count mismatch"
}

$stationIds = @($config.stations | ForEach-Object { $_.id })
foreach ($expectedId in @($spec.expected_route)) {
  if ($stationIds -notcontains $expectedId) {
    Fail "missing station id $expectedId"
  }
}

if (-not (Test-Path -LiteralPath $scriptPath -PathType Leaf)) {
  Fail "missing factory script: $scriptPath"
}

$runOutput = & pwsh $scriptPath -ConfigPath $configPath -ProductId $spec.sample_product.id 2>&1
if ($LASTEXITCODE -ne 0) {
  Fail "factory script failed: $($runOutput -join "`n")"
}

$actualRoute = (($runOutput -join "`n").Trim() -split '\s*->\s*')
$expectedRoute = @($spec.expected_route)
if ($actualRoute.Count -ne $expectedRoute.Count) {
  Fail "route length mismatch: $($actualRoute -join '->')"
}
for ($i = 0; $i -lt $expectedRoute.Count; $i++) {
  if ($actualRoute[$i] -ne $expectedRoute[$i]) {
    Fail "route mismatch at $i expected $($expectedRoute[$i]) got $($actualRoute[$i])"
  }
}

$report = Read-JsonFile $reportPath
if ($report.product_id -ne $spec.sample_product.id) {
  Fail "dashboard report product id mismatch"
}
if (($report.route -join '->') -ne ($expectedRoute -join '->')) {
  Fail "dashboard report route mismatch"
}

[pscustomobject]@{
  ok = $true
  workload = $spec.id
  stations_checked = $stationIds.Count
  route = ($actualRoute -join '->')
  factory_root = $factoryRoot
} | ConvertTo-Json -Compress
