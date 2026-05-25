param(
    [Parameter(Mandatory=$true)][string]$ConfigPath,
    [Parameter(Mandatory=$true)][string]$ProductId
)

$stations = Get-Content -Path $ConfigPath | ConvertFrom-Json
$route = @()
$currentId = "intake"
while ($currentId -ne "") {
    $station = $stations | Where-Object { $_.id -eq $currentId }
    if ($null -eq $station) { break }
    $route += $station.name
    $currentId = $station.next
}
Write-Output ($route -join "->")

$report = @{
    product_id = $ProductId
    route = ($route -join "->")
}

$reportDir = Join-Path $PSScriptRoot "../dashboard"
if (-not (Test-Path $reportDir)) { New-Item -ItemType Directory -Path $reportDir | Out-Null }
$report | ConvertTo-Json | Set-Content (Join-Path $reportDir "report.json")
