param(
    [string]$ConfigPath,
    [string]$ProductId
)

$scriptRoot = $PSScriptRoot
$config = Get-Content -Raw $ConfigPath | ConvertFrom-Json
$stations = $config

$current = $stations | Where-Object { $_.id -eq 'intake' }
$routeParts = @()
while ($current) {
    $routeParts += $current.name
    if ($current.next) {
        $current = $stations | Where-Object { $_.id -eq $current.next }
    } else {
        $current = $null
    }
}
$route = ($routeParts -join '->')
Write-Output $route

New-Item -ItemType Directory -Force -Path "$scriptRoot/dashboard"
$report = @{
    product_id = 'entropy-widget-001'
    route = $route
}
$report | ConvertTo-Json -Depth 3 | Set-Content -Path "$scriptRoot/dashboard/report.json"
