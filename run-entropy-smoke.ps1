param(
  [string]$Base = 'http://192.168.1.203:4000',
  [string]$TargetsPath = 'E:/Dev/AI/remote/Entropy/llmcommune-entropy-targets.json',
  [string]$ResultPath = '',
  [string]$OnlySet = '',
  [switch]$IncludeDualBox
)

$ErrorActionPreference = 'Stop'

if (-not $ResultPath) {
  $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
  $ResultPath = "E:/Dev/AI/remote/Entropy/entropy-smoke-results-$stamp.jsonl"
}

function Write-Result($obj) {
  $obj | ConvertTo-Json -Depth 14 -Compress | Add-Content -LiteralPath $ResultPath -Encoding UTF8
}

function Read-ResponseBody($err) {
  try {
    if ($err.ErrorDetails -and $err.ErrorDetails.Message) {
      return $err.ErrorDetails.Message
    }
    $response = $err.Exception.Response
    if ($null -eq $response) { return $null }
    if ($response -is [System.Net.Http.HttpResponseMessage]) {
      return $response.Content.ReadAsStringAsync().GetAwaiter().GetResult()
    }
    $stream = $response.GetResponseStream()
    if ($null -eq $stream) { return $null }
    $reader = New-Object System.IO.StreamReader($stream)
    return $reader.ReadToEnd()
  } catch {
    return $null
  }
}

function Invoke-JsonPost($url, $body, $timeoutSec) {
  $json = $body | ConvertTo-Json -Depth 10 -Compress
  $tmp = New-TemporaryFile
  $bodyFile = New-TemporaryFile
  try {
    [System.IO.File]::WriteAllText($bodyFile.FullName, $json, (New-Object System.Text.UTF8Encoding($false)))
    $statusText = & curl.exe -sS -m $timeoutSec -o $tmp.FullName -w '%{http_code}' -X POST $url -H 'Content-Type: application/json' --data-binary "@$($bodyFile.FullName)"
    $exitCode = $LASTEXITCODE
    $content = Get-Content -Raw -LiteralPath $tmp.FullName
    if ($exitCode -ne 0) {
      throw "curl exited $exitCode posting $url body=$content"
    }
    $statusCode = [int]$statusText
    $parsed = $null
    if (-not [string]::IsNullOrWhiteSpace($content)) {
      $parsed = $content | ConvertFrom-Json
    }
    if ($statusCode -ge 200 -and $statusCode -lt 300) {
      return $parsed
    }
    if ($parsed -and $parsed.ok -eq $true -and $parsed.status -eq 'skipped') {
      return $parsed
    }
    if ($parsed -and $parsed.code -eq 'RATE_LIMITED') {
      return $parsed
    }
    throw "HTTP $statusCode posting $url body=$content"
  } finally {
    Remove-Item -LiteralPath $tmp.FullName -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $bodyFile.FullName -Force -ErrorAction SilentlyContinue
  }
}

function Get-RateLimitWaitSeconds($response) {
  if ($response.estimated_ready_at) {
    try {
      $readyText = [string]$response.estimated_ready_at
      if ($readyText -notmatch '(Z|[+-]\d\d:\d\d)$') {
        $readyText = "${readyText}Z"
      }
      $readyAt = [datetimeoffset]::Parse($readyText)
      $delta = [math]::Ceiling(($readyAt.ToUniversalTime() - [datetimeoffset]::UtcNow).TotalSeconds)
      if ($delta -gt 0) { return ($delta + 1) }
    } catch {
    }
  }
  if ($response.detail) {
    $match = [regex]::Match([string]$response.detail, '(\d+)s remaining')
    if ($match.Success) { return ([int]$match.Groups[1].Value + 1) }
  }
  return 20
}

function Activate-Set($baseUrl, $setId) {
  for ($attempt = 1; $attempt -le 20; $attempt++) {
    $act = Invoke-JsonPost "$baseUrl/api/llm-host/activate-set" @{ set_id=$setId; wait=$true; allow_preempt=$true } 1800
    if ($act -and $act.code -eq 'RATE_LIMITED') {
      $waitSeconds = Get-RateLimitWaitSeconds $act
      Write-Host "activation cooldown for $setId; waiting ${waitSeconds}s"
      Start-Sleep -Seconds $waitSeconds
      continue
    }
    return $act
  }
  throw "activation cooldown did not clear for $setId after 20 attempts"
}

function Invoke-JsonGet($url, $timeoutSec) {
  Invoke-RestMethod -TimeoutSec $timeoutSec -Uri $url
}

function Get-ServedModelId($lane) {
  $models = Invoke-JsonGet "$($lane.base_url)/v1/models" 20
  if ($models.data -and $models.data.Count -gt 0 -and $models.data[0].id) { return $models.data[0].id }
  if ($models.models -and $models.models.Count -gt 0 -and $models.models[0].model) { return $models.models[0].model }
  return $lane.model_id
}

function Get-ObservedContext($processText) {
  $ctxMatch = [regex]::Match($processText, '--ctx-size\s+(\d+)')
  if ($ctxMatch.Success) { return [int]$ctxMatch.Groups[1].Value }

  $maxTokMatch = [regex]::Match($processText, '--max_num_tokens\s+(\d+)')
  if ($maxTokMatch.Success) { return [int]$maxTokMatch.Groups[1].Value }

  $envCtxMatch = [regex]::Match($processText, 'CTX_SIZE=(\d+)')
  if ($envCtxMatch.Success) { return [int]$envCtxMatch.Groups[1].Value }

  return $null
}

function Wait-ActivationReady($baseUrl, $setId, $profileId, $timeoutSec) {
  $deadline = (Get-Date).AddSeconds($timeoutSec)
  do {
    $cur = Invoke-JsonGet "$baseUrl/api/llm-host/current" 20
    if ($cur.swap -and $cur.swap.reconcile_needed) {
      throw "controller reports reconcile_needed=true detail=$($cur.swap.failure_detail)"
    }
    if ($cur.desired_state -and $cur.desired_state.state -eq 'failed') {
      throw "controller desired_state failed detail=$($cur.desired_state.status_detail)"
    }
    $activeSet = $null
    if ($cur.desired_state) { $activeSet = $cur.desired_state.active_set_id }
    $largeProfile = $null
    if ($cur.lanes -and $cur.lanes.large) { $largeProfile = $cur.lanes.large.profile_id }
    if ($activeSet -eq $setId -and $largeProfile -eq $profileId -and $cur.desired_state.state -eq 'ready') {
      return $cur
    }
    Start-Sleep -Seconds 2
  } while ((Get-Date) -lt $deadline)

  throw "timed out waiting for $setId / $profileId to become ready"
}

$manifest = Get-Content -Raw -LiteralPath $TargetsPath | ConvertFrom-Json
$targets = @($manifest.targets)
if (-not $IncludeDualBox) {
  $targets = @($targets | Where-Object { -not $_.requires_gx10 })
}
if ($OnlySet) {
  $targets = @($targets | Where-Object { $_.set_id -eq $OnlySet })
}

New-Item -ItemType Directory -Force -Path (Split-Path $ResultPath) | Out-Null
if (Test-Path -LiteralPath $ResultPath) { Remove-Item -LiteralPath $ResultPath -Force }

Write-Host "Writing results to $ResultPath"
Write-Host "Targets: $($targets.Count). IncludeDualBox=$($IncludeDualBox.IsPresent). OnlySet=$OnlySet"

foreach ($t in $targets) {
  $started = Get-Date
  $row = [ordered]@{
    ts = $started.ToString('o')
    set_id = $t.set_id
    profile_id_expected = $t.profile_id
    parameter_count_b = $t.parameter_count_b
    expected_context = $t.context_tokens
    requires_gx10 = $t.requires_gx10
    activation_status = $null
    activation_detail = $null
    profile_id_observed = $null
    model_id = $null
    runtime_family = $null
    lane_base_url = $null
    served_model_id = $null
    process = $null
    observed_context = $null
    health = $null
    completion_ok = $false
    completion_text = $null
    usage = $null
    timings = $null
    error = $null
    elapsed_s = $null
  }

  try {
    Write-Host "=== activating $($t.set_id) ($($t.parameter_count_b)B, ctx $($t.context_tokens)) ==="
    $act = Activate-Set $Base $t.set_id
    Write-Host "activation returned for $($t.set_id)"
    if ($act) {
      $row.activation_status = $act.status
      if ($act.status_detail) { $row.activation_detail = $act.status_detail }
      elseif ($act.detail) { $row.activation_detail = $act.detail }
    }

    $cur = Invoke-JsonGet "$Base/api/llm-host/current" 20
    Write-Host "current state read for $($t.set_id)"
    if ($cur.swap -and $cur.swap.reconcile_needed) {
      throw "controller reports reconcile_needed=true detail=$($cur.swap.failure_detail)"
    }

    $lane = $cur.lanes.large
    $row.profile_id_observed = $lane.profile_id
    $row.model_id = $lane.model_id
    $row.runtime_family = $lane.runtime_family
    $row.lane_base_url = $lane.base_url
    $row.health = Invoke-JsonGet "$($lane.base_url)/health" 10
    Write-Host "health ok for $($t.set_id)"
    $row.served_model_id = Get-ServedModelId $lane
    Write-Host "served model $($row.served_model_id)"

    $proc = ssh -o BatchMode=yes -o ConnectTimeout=10 dgx "pgrep -af 'llama-server|trtllm-serve|trtllm-llmapi-launch|vllm' | grep -v pgrep | head -20"
    $row.process = ($proc -join "`n")
    $row.observed_context = Get-ObservedContext $row.process
    Write-Host "observed context $($row.observed_context)"

    $prompt = "SMOKE $($t.set_id): answer with the single word READY."
    Write-Host "completion probe for $($t.set_id)"
    if ($lane.runtime_family -eq 'trtllm') {
      $resp = Invoke-JsonPost "$($lane.base_url)/v1/chat/completions" @{
        model = $row.served_model_id
        messages = @(@{ role='user'; content=$prompt })
        max_tokens = 12
        temperature = 0
      } 180
      $row.completion_text = $resp.choices[0].message.content
    } else {
      $resp = Invoke-JsonPost "$($lane.base_url)/v1/completions" @{
        model = $row.served_model_id
        prompt = $prompt
        max_tokens = 12
        temperature = 0
      } 180
      $row.completion_text = $resp.choices[0].text
    }

    $row.completion_ok = $true
    $row.usage = $resp.usage
    $row.timings = $resp.timings
  } catch {
    $row.error = $_.Exception.Message
    Write-Host "FAILED $($t.set_id): $($row.error)"
  } finally {
    $row.elapsed_s = [math]::Round(((Get-Date) - $started).TotalSeconds, 1)
    Write-Result $row
    Write-Host "done $($t.set_id) status=$($row.activation_status) ctx=$($row.observed_context) elapsed=$($row.elapsed_s)s"
  }
}

Write-Host "Complete: $ResultPath"
