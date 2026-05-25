param(
  [string]$RunRoot = '',
  [string]$RunRootBase = (Join-Path (Resolve-Path (Join-Path $PSScriptRoot '..')).Path 'runs/EB-LC'),
  [string]$RunGlob = 'EB-LC-wave*-*',
  [switch]$IncludeIncomplete,
  [switch]$Force
)

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
. (Join-Path $PSScriptRoot 'Import-DotEnv.ps1')

foreach ($name in @('LANGFUSE_PUBLIC_KEY', 'LANGFUSE_SECRET_KEY', 'LANGFUSE_HOST')) {
  if (-not (Get-Item "env:$name" -ErrorAction SilentlyContinue)) {
    throw "Missing required environment variable: $name"
  }
}

function Get-BasicAuthHeader {
  $pair = "$($env:LANGFUSE_PUBLIC_KEY):$($env:LANGFUSE_SECRET_KEY)"
  $bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
  return "Basic $([Convert]::ToBase64String($bytes))"
}

function Read-JsonLines($path) {
  if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { return @() }
  return @(Get-Content -LiteralPath $path | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object {
    $_ | ConvertFrom-Json -Depth 100
  })
}

function Write-JsonFile($path, $obj) {
  New-Item -ItemType Directory -Force -Path (Split-Path $path) | Out-Null
  $obj | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $path -Encoding UTF8
}

function Get-Trace($traceId, $headers) {
  $uri = "$($env:LANGFUSE_HOST.TrimEnd('/'))/api/public/traces/$traceId"
  return Invoke-RestMethod -TimeoutSec 30 -Uri $uri -Headers $headers
}

function Get-ObservationUsageTotal($trace) {
  $total = [ordered]@{
    input = 0
    output = 0
    total = 0
  }

  foreach ($obs in @($trace.observations)) {
    if ($obs.usage) {
      $total.input += [int]($obs.usage.input ?? 0)
      $total.output += [int]($obs.usage.output ?? 0)
      $total.total += [int]($obs.usage.total ?? 0)
    } elseif ($obs.usageDetails) {
      $total.input += [int]($obs.usageDetails.input ?? 0)
      $total.output += [int]($obs.usageDetails.output ?? 0)
      $total.total += [int]($obs.usageDetails.total ?? 0)
    } else {
      $total.input += [int]($obs.promptTokens ?? 0)
      $total.output += [int]($obs.completionTokens ?? 0)
      $total.total += [int]($obs.totalTokens ?? 0)
    }
  }

  return $total
}

if ($RunRoot) {
  $runDirs = @((Resolve-Path -LiteralPath $RunRoot).Path | ForEach-Object { Get-Item -LiteralPath $_ })
} else {
  $runDirs = @(Get-ChildItem -LiteralPath $RunRootBase -Directory -Filter $RunGlob | Sort-Object Name)
}

$headers = @{ Authorization = Get-BasicAuthHeader }
$exportedRuns = @()

foreach ($run in $runDirs) {
  $resultsPath = Join-Path $run.FullName 'results.jsonl'
  $statusPath = Join-Path $run.FullName 'queue-status.json'
  if (-not (Test-Path -LiteralPath $resultsPath -PathType Leaf)) { continue }
  if (-not $IncludeIncomplete -and -not (Test-Path -LiteralPath $statusPath -PathType Leaf)) { continue }

  $rows = Read-JsonLines $resultsPath
  $traceRows = @($rows | Where-Object { $_.langfuse_trace_id } | Sort-Object langfuse_trace_id -Unique)
  $exportDir = Join-Path $run.FullName 'langfuse'
  $traceDir = Join-Path $exportDir 'traces'
  New-Item -ItemType Directory -Force -Path $traceDir | Out-Null

  $summaries = @()
  $errors = @()

  foreach ($row in $traceRows) {
    $traceId = [string]$row.langfuse_trace_id
    $tracePath = Join-Path $traceDir "$traceId.json"
    if ((Test-Path -LiteralPath $tracePath -PathType Leaf) -and -not $Force) {
      $trace = Get-Content -Raw -LiteralPath $tracePath | ConvertFrom-Json -Depth 100
    } else {
      try {
        $trace = Get-Trace $traceId $headers
        Write-JsonFile $tracePath $trace
      } catch {
        $errors += [pscustomobject]@{
          trace_id = $traceId
          target_set_id = $row.target_set_id
          workload_id = $row.workload_id
          stage_id = $row.stage_id
          error = $_.Exception.Message
        }
        continue
      }
    }

    $usage = Get-ObservationUsageTotal $trace
    $summaries += [pscustomobject]@{
      trace_id = $traceId
      target_set_id = $row.target_set_id
      workload_id = $row.workload_id
      stage_id = $row.stage_id
      stage_order = $row.stage_order
      status = $row.status
      failure_class = $row.failure_class
      langfuse_name = $trace.name
      langfuse_timestamp = $trace.timestamp
      langfuse_latency_s = $trace.latency
      observation_count = @($trace.observations).Count
      model = if (@($trace.observations).Count -gt 0) { @($trace.observations)[0].model } else { $null }
      usage = $usage
      total_cost = $trace.totalCost
      html_path = $trace.htmlPath
      trace_file = [System.IO.Path]::GetRelativePath($run.FullName, $tracePath).Replace('\','/')
    }
  }

  $summaryPath = Join-Path $exportDir 'summary.json'
  $summaryJsonlPath = Join-Path $exportDir 'summary.jsonl'
  $manifestPath = Join-Path $exportDir 'manifest.json'

  $manifest = [ordered]@{
    schema_version = 1
    exported_at = (Get-Date).ToString('o')
    langfuse_host = $env:LANGFUSE_HOST
    run_root = $run.FullName
    results = $resultsPath
    row_count = @($rows).Count
    trace_row_count = @($traceRows).Count
    exported_trace_count = @($summaries).Count
    error_count = @($errors).Count
    errors = @($errors)
  }

  Write-JsonFile $manifestPath $manifest
  Write-JsonFile $summaryPath @($summaries)
  @($summaries | ForEach-Object { $_ | ConvertTo-Json -Depth 50 -Compress }) | Set-Content -LiteralPath $summaryJsonlPath -Encoding UTF8

  $exportedRuns += [pscustomobject]@{
    run = $run.Name
    rows = @($rows).Count
    traces = @($traceRows).Count
    exported = @($summaries).Count
    errors = @($errors).Count
    export_dir = $exportDir
  }
}

$exportedRuns | ConvertTo-Json -Depth 20
