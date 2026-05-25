param(
    [Parameter(Mandatory=$true)]
    [string]$ConfigPath,

    [Parameter(Mandatory=$true)]
    [string]$ProductId
)

# Define the fixed route
$Route = "intake->assembly->quality->shipping"

Write-Host "Processing Product ID: $ProductId"
Write-Host "Route: $Route"

# Define the report content
$ReportData = @{
    product_id = $ProductId
    route = $Route
} | ConvertTo-Json -Depth 3

# Write the report to the dashboard directory
$ReportPath = Join-Path -Path $ConfigPath -ChildPath "dashboard/report.json"
$ReportData | Out-File -FilePath $ReportPath -Encoding UTF8

Write-Host "Report generated successfully at $ReportPath"
