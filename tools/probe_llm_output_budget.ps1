param(
  [string]$BaseUrl = 'http://192.168.1.203:4000',
  [string]$SetId = '',
  [int[]]$MaxTokens = @(8192, 16384, 32768),
  [string]$ResultPath = '',
  [int]$TimeoutSec = 1800,
  [switch]$SkipActivation
)

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
if (-not $ResultPath) {
  $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
  $ResultPath = Join-Path $repoRoot "runs/llmcommune_output_budget/output-budget-$stamp.jsonl"
}
New-Item -ItemType Directory -Force -Path (Split-Path $ResultPath) | Out-Null

function Invoke-JsonPost($url, $body, $timeoutSec) {
  $json = $body | ConvertTo-Json -Depth 32 -Compress
  $tmp = New-TemporaryFile
  $bodyFile = New-TemporaryFile
  try {
    [System.IO.File]::WriteAllText($bodyFile.FullName, $json, (New-Object System.Text.UTF8Encoding($false)))
    $statusText = & curl.exe -sS -m $timeoutSec -o $tmp.FullName -w '%{http_code}' -X POST $url -H 'Content-Type: application/json' --data-binary "@$($bodyFile.FullName)"
    $exitCode = $LASTEXITCODE
    $content = Get-Content -Raw -LiteralPath $tmp.FullName
    if ($exitCode -ne 0) { throw "curl exited $exitCode posting $url body=$content" }
    $statusCode = [int]$statusText
    if ($statusCode -lt 200 -or $statusCode -ge 300) { throw "HTTP $statusCode posting $url body=$content" }
    if ([string]::IsNullOrWhiteSpace($content)) { return $null }
    return $content | ConvertFrom-Json -Depth 64
  } finally {
    Remove-Item -LiteralPath $tmp.FullName -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $bodyFile.FullName -Force -ErrorAction SilentlyContinue
  }
}

function Invoke-JsonGet($url, $timeoutSec) {
  Invoke-RestMethod -TimeoutSec $timeoutSec -Uri $url
}

function Write-Row($obj) {
  $obj | ConvertTo-Json -Depth 32 -Compress | Add-Content -LiteralPath $ResultPath -Encoding UTF8
}

if ($SetId -and -not $SkipActivation) {
  Invoke-JsonPost "$BaseUrl/api/llm-host/activate-set" @{ set_id=$SetId; wait=$true; allow_preempt=$true } 1800 | Out-Null
}

$current = Invoke-JsonGet "$BaseUrl/api/llm-host/current" 30
if ($current.swap -and $current.swap.reconcile_needed) {
  throw "controller reconcile_needed=true detail=$($current.swap.failure_detail)"
}
if ($current.desired_state -and $current.desired_state.state -eq 'failed') {
  throw "controller desired_state failed detail=$($current.desired_state.status_detail)"
}

$lane = $current.lanes.large
if (-not $lane -or -not $lane.up) { throw "large lane is not up" }
$laneBase = [string]$lane.base_url
$models = Invoke-JsonGet "$laneBase/v1/models" 20
$servedModel = if ($models.data -and $models.data[0].id) { [string]$models.data[0].id } else { [string]$lane.model_id }

foreach ($max in $MaxTokens) {
  $started = Get-Date
  $prompt = @"
Generate a long plain-text output to test the served completion budget.

Rules:
- Do not summarize.
- Do not stop early.
- Write numbered lines in this exact form: LINE 000001 output-budget-probe abcdefghijklmnopqrstuvwxyz 0123456789
- Continue until the server stops you or until you have written at least $max tokens.
- No markdown fences.
"@

  try {
    $response = Invoke-JsonPost "$laneBase/v1/chat/completions" @{
      model = $servedModel
      messages = @(
        @{ role = 'system'; content = 'You are an output budget probe. Follow the user instruction exactly.' },
        @{ role = 'user'; content = $prompt }
      )
      max_tokens = $max
      temperature = 0
    } $TimeoutSec

    $choice = $response.choices[0]
    $text = if ($choice.message -and $choice.message.content) { [string]$choice.message.content } else { [string]$choice.text }
    $completionTokens = if ($response.usage -and $null -ne $response.usage.completion_tokens) { [int]$response.usage.completion_tokens } else { $null }
    $finishReason = [string]$choice.finish_reason
    $budgetOk = ($null -ne $completionTokens -and $completionTokens -ge $max)
    $result = if ($budgetOk) { 'ok' } else { 'serving_cap_below_requested' }
    Write-Row ([ordered]@{
      ok = $budgetOk
      result = $result
      checked_at = (Get-Date).ToString('o')
      set_id = if ($SetId) { $SetId } else { $current.desired_state.active_set_id }
      profile_id = $lane.profile_id
      model_id = $servedModel
      base_url = $laneBase
      context_tokens = $lane.adapter.context_tokens
      requested_max_tokens = $max
      finish_reason = $finishReason
      prompt_tokens = $response.usage.prompt_tokens
      completion_tokens = $completionTokens
      total_tokens = $response.usage.total_tokens
      response_chars = $text.Length
      elapsed_s = [math]::Round(((Get-Date) - $started).TotalSeconds, 1)
    })
  } catch {
    Write-Row ([ordered]@{
      ok = $false
      result = 'request_failed'
      checked_at = (Get-Date).ToString('o')
      set_id = if ($SetId) { $SetId } else { $current.desired_state.active_set_id }
      profile_id = $lane.profile_id
      model_id = $servedModel
      base_url = $laneBase
      context_tokens = $lane.adapter.context_tokens
      requested_max_tokens = $max
      error = $_.Exception.Message
      elapsed_s = [math]::Round(((Get-Date) - $started).TotalSeconds, 1)
    })
  }
}

Write-Host "LLM output budget probe complete: $ResultPath"
