param(
    [Parameter(Mandatory=$true)][string]$ConfigPath,
    [Parameter(Mandatory=$true)][string]$ProductId
)

# Ensure dashboard folder exists
$configDir = Split-Path $ConfigPath
$rootDir = Split-Path $configDir
$dashboardDir = Join-Path $rootDir 'dashboard'
if (-not (Test-Path $dashboardDir)) {
    New-Item -ItemType Directory -Path $dashboardDir | Out-Null
}

# Load stations
try {
    $stations = Get-Content $ConfigPath -Raw | ConvertFrom-Json
} catch {
    Write-Error "Failed to load stations config: $_"
    exit 1
}

# Build route starting from intake
$route = @()
$current = $stations | Where-Object { $_.id -eq 'intake' } | Select-Object -First 1
if (-not $current) {
    Write-Error "Intake station not found."
    exit 1
}
while ($current) {
    $route += $current.name
    $next = $current.next
    if ([string]::IsNullOrEmpty($next)) { break }
    $current = $stations | Where-Object { $_.id -eq $next } | Select-Object -First 1
    if (-not $current) {
        Write-Error "Next station '$next' not found."
        exit 1
    }
}
$routeString = $route -join '->'
Write-Host $routeString

# Write report
$report = @{
    product_id = $ProductId
    route = $routeString
}
$reportPath = Join-Path $dashboardDir 'report.json'
$report | ConvertTo-Json -Depth 3 | Set-Content $reportPath

