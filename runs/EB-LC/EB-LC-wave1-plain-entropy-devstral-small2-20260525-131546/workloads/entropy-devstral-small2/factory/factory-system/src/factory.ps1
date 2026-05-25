param (
    [Parameter(Mandatory=$true)]
    [string]$ConfigPath,
    [Parameter(Mandatory=$true)]
    [string]$ProductId
)

# Load stations configuration
$stations = Get-Content -Path $ConfigPath | ConvertFrom-Json

# Build the route
$route = @()
$currentStation = $stations | Where-Object { $_.id -eq 'intake' }
while ($currentStation -ne $null) {
    $route += $currentStation.id
    $currentStation = $stations | Where-Object { $_.id -eq $currentStation.next }
}

# Print the route
Write-Output ("Route: " + ($route -join '->'))

# Create dashboard directory if it doesn't exist
if (-not (Test-Path -Path "dashboard")) {
    New-Item -ItemType Directory -Path "dashboard" | Out-Null
}

# Write report.json
$report = @{
    "product_id" = $ProductId
    "route" = ($route -join '->')
} | ConvertTo-Json

Set-Content -Path "dashboard/report.json" -Value $report
