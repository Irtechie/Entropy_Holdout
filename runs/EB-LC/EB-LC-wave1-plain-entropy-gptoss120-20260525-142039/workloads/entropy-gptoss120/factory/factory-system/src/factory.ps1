param(
    [Parameter(Mandatory=$true)]
    [string]$ConfigPath,
    [Parameter(Mandatory=$true)]
    [string]$ProductId
)

# Load stations configuration
$config = Get-Content -Path $ConfigPath -Raw | ConvertFrom-Json

# Build route following 'next' links starting at intake
$route = @()
$current = "intake"
while ($current) {
    $route += $current
    $station = $config.stations | Where-Object { $_.id -eq $current }
    if (-not $station) { break }
    $next = $station.next
    if ([string]::IsNullOrEmpty($next)) { break }
    $current = $next
}

Write-Host "Route: $($route -join '->')"

# Prepare report
$report = @{
    product_id = $ProductId
    route = $route -join '->'
}
$reportJson = $report | ConvertTo-Json -Depth 3

# Write report to dashboard/report.json relative to script location
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$reportPath = Join-Path $scriptDir "..\\dashboard\\report.json"
Set-Content -Path $reportPath -Value $reportJson -Encoding UTF8

Write-Host "Report written to $reportPath"
