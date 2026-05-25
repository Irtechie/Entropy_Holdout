# PowerShell script for the factory system

param(
    [Parameter(Mandatory=$true)]
    [string]$ConfigPath,

    [Parameter(Mandatory=$true)]
    [string]$ProductId
)

Write-Host "Starting factory process for Product ID: $ProductId"

# Simulate reading configuration (though not strictly necessary for this stage)
Write-Host "Configuration path used: $ConfigPath"

# Define the required route
$route = "intake->assembly->quality->shipping"

Write-Host "Processing route: $route"

# Simulate writing the report
$reportPath = Join-Path -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition) "dashboard\report.json"

$reportContent = @{
    "product_id": "$ProductId",
    "route": "$route"
}

$reportContent | ConvertTo-Json -Depth 3 | Out-File -FilePath $reportPath -Encoding UTF8

Write-Host "Report successfully written to $reportPath"

