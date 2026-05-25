param(
    [string]$ConfigPath,
    [string]$ProductId
)

# Read stations from config
$stations = Get-Content -Path $ConfigPath | ConvertFrom-Json

# Build route
$route = @()
foreach ($station in $stations) {
    $route += $station.id
}

# Print route
$route -join "->"

# Write report
$report = @{
    product_id = $ProductId
    route = $route -join "->"
}

$report | ConvertTo-Json -Depth 10 | Out-File -FilePath "factory-system/dashboard/report.json" -Encoding utf8
