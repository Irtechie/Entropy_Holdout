# Actual Test Code

This repo does not generate a separate test program. The test code is the PowerShell smoke runner in `run-entropy-smoke.ps1`, driven by `llmcommune-entropy-targets.json`.

The runner writes one JSONL result row per target to:

```powershell
E:/Dev/AI/remote/Entropy/entropy-smoke-results-<timestamp>.jsonl
```

## Commands

Run default single-box targets:

```powershell
pwsh .\run-entropy-smoke.ps1
```

Run one target:

```powershell
pwsh .\run-entropy-smoke.ps1 -OnlySet entropy-devstral-small2
```

Run single-box plus dual-box/GX10 targets:

```powershell
pwsh .\run-entropy-smoke.ps1 -IncludeDualBox
```

## Test Rounds

There are three to four practical rounds in this repo, depending on whether the later one-off validations are counted as their own round.

### Round 1: Single-Box Sweep

Command:

```powershell
pwsh .\run-entropy-smoke.ps1
```

This runs all manifest targets where `requires_gx10` is false. Historically, the primary proof file was:

```text
entropy-smoke-results-20260509-124418.jsonl
```

That round proved the normal Entropy large-lane GGUF targets could activate, report healthy, expose an OpenAI-compatible endpoint, show the intended context, and return one tiny completion.

### Round 2: Top-Context / PRD Queue One-Offs

Command shape:

```powershell
pwsh .\run-entropy-smoke.ps1 -OnlySet <set_id>
```

These are targeted validation runs for specific PRD queue handoff entries, especially when the top-context target is not the same as the base manifest target.

Examples from the repo:

```text
entropy-qwen80nextcoder-256k
entropy-nemotron3-super-120b
entropy-devstral-small2
```

The latest local untracked result is:

```text
entropy-smoke-results-20260516-212329.jsonl
```

That result is a one-target pass for `entropy-devstral-small2`.

### Round 3: Dual-Box Qwen235 Failure/Replacement Search

Command shape:

```powershell
pwsh .\run-entropy-smoke.ps1 -IncludeDualBox -OnlySet <qwen235-set>
```

This round tested qwen235 separately because it needs Spark plus GX10.

Historical qwen235 path:

```text
entropy-qwen235
```

Result: failed. The old TensorRT-LLM Entropy copy could not launch correctly and was retired.

Replacement candidates:

```text
entropy-qwen235-2507-128k
entropy-qwen235-2507-64k
entropy-qwen235-2507-64k-eager
```

Known outcomes:

```text
entropy-qwen235-2507-128k
- not smoke-proven
- got through launcher fixes but timed out before API readiness

entropy-qwen235-2507-64k
- not smoke-proven
- reached API-ready, then first completion crashed in the compiled CUDA path

entropy-qwen235-2507-64k-eager
- pass
- current qwen235 handoff
```

### Round 4: Post-Fix Spot Checks

Command shape:

```powershell
pwsh .\run-entropy-smoke.ps1 -OnlySet <set_id>
```

This is the optional follow-up round after harness fixes. The May 16 Devstral run is in this category: it confirmed the harness can handle an already-active healthy target and still produce a clean result row.

## Control Rules Fixed In The Harness

The important control-flow fix is the activation retry path. It is not a load test loop; it is an activation cooldown rule.

Current rule:

- Try activation up to 20 times.
- If the controller returns `RATE_LIMITED`, parse `estimated_ready_at` or the `"Ns remaining"` detail.
- Sleep until that cooldown expires, plus one second.
- Retry the same target instead of writing an immediate failure row.
- If the cooldown never clears after 20 attempts, throw a real failure.

Actual code:

```powershell
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
```

The other important fixed rule is that "already active and healthy" is not a failure, even when the controller returns it as HTTP 400. The runner accepts `ok=true/status=skipped` as a usable activation result and continues to health/model/completion checks.

## Inputs

The runner defaults to:

```powershell
param(
  [string]$Base = 'http://192.168.1.203:4000',
  [string]$TargetsPath = 'E:/Dev/AI/remote/Entropy/llmcommune-entropy-targets.json',
  [string]$ResultPath = '',
  [string]$OnlySet = '',
  [switch]$IncludeDualBox
)
```

If `-ResultPath` is omitted, it creates a timestamped JSONL result file:

```powershell
if (-not $ResultPath) {
  $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
  $ResultPath = "E:/Dev/AI/remote/Entropy/entropy-smoke-results-$stamp.jsonl"
}
```

## Target Selection

The manifest is loaded from `llmcommune-entropy-targets.json`.

By default, GX10/dual-box targets are filtered out:

```powershell
$manifest = Get-Content -Raw -LiteralPath $TargetsPath | ConvertFrom-Json
$targets = @($manifest.targets)
if (-not $IncludeDualBox) {
  $targets = @($targets | Where-Object { -not $_.requires_gx10 })
}
if ($OnlySet) {
  $targets = @($targets | Where-Object { $_.set_id -eq $OnlySet })
}
```

## Activation Request

For each target, the runner activates the set through the LLMCommune controller:

```powershell
$act = Invoke-JsonPost "$baseUrl/api/llm-host/activate-set" @{
  set_id=$setId
  wait=$true
  allow_preempt=$true
} 1800
```

Activation cooldown responses are retried:

```powershell
if ($act -and $act.code -eq 'RATE_LIMITED') {
  $waitSeconds = Get-RateLimitWaitSeconds $act
  Write-Host "activation cooldown for $setId; waiting ${waitSeconds}s"
  Start-Sleep -Seconds $waitSeconds
  continue
}
```

## Controller And Health Checks

After activation, the runner reads current controller state:

```powershell
$cur = Invoke-JsonGet "$Base/api/llm-host/current" 20
```

It fails the row if the controller reports reconciliation trouble:

```powershell
if ($cur.swap -and $cur.swap.reconcile_needed) {
  throw "controller reports reconcile_needed=true detail=$($cur.swap.failure_detail)"
}
```

Then it checks the active large lane:

```powershell
$lane = $cur.lanes.large
$row.profile_id_observed = $lane.profile_id
$row.model_id = $lane.model_id
$row.runtime_family = $lane.runtime_family
$row.lane_base_url = $lane.base_url
$row.health = Invoke-JsonGet "$($lane.base_url)/health" 10
```

It also reads `/v1/models` to determine the served model id:

```powershell
$models = Invoke-JsonGet "$($lane.base_url)/v1/models" 20
```

## Process And Context Check

The runner SSHes to `dgx` and records model-serving processes:

```powershell
$proc = ssh -o BatchMode=yes -o ConnectTimeout=10 dgx "pgrep -af 'llama-server|trtllm-serve|trtllm-llmapi-launch|vllm' | grep -v pgrep | head -20"
$row.process = ($proc -join "`n")
```

It extracts observed context from process text:

```powershell
$ctxMatch = [regex]::Match($processText, '--ctx-size\s+(\d+)')
$maxTokMatch = [regex]::Match($processText, '--max_num_tokens\s+(\d+)')
$envCtxMatch = [regex]::Match($processText, 'CTX_SIZE=(\d+)')
```

## Completion Probe

The actual smoke prompt is:

```powershell
$prompt = "SMOKE $($t.set_id): answer with the single word READY."
```

For TensorRT-LLM runtimes, it calls chat completions:

```powershell
$resp = Invoke-JsonPost "$($lane.base_url)/v1/chat/completions" @{
  model = $row.served_model_id
  messages = @(@{ role='user'; content=$prompt })
  max_tokens = 12
  temperature = 0
} 180
$row.completion_text = $resp.choices[0].message.content
```

For all other runtimes, including llama.cpp and vLLM in this harness, it calls completions:

```powershell
$resp = Invoke-JsonPost "$($lane.base_url)/v1/completions" @{
  model = $row.served_model_id
  prompt = $prompt
  max_tokens = 12
  temperature = 0
} 180
$row.completion_text = $resp.choices[0].text
```

## Result Row Written

Each target writes this row shape:

```powershell
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
```

On success:

```powershell
$row.completion_ok = $true
$row.usage = $resp.usage
$row.timings = $resp.timings
```

On failure:

```powershell
$row.error = $_.Exception.Message
```

The row is always written, success or failure:

```powershell
$row.elapsed_s = [math]::Round(((Get-Date) - $started).TotalSeconds, 1)
$obj | ConvertTo-Json -Depth 14 -Compress | Add-Content -LiteralPath $ResultPath -Encoding UTF8
```

## What This Proves

This is an activation and API smoke test. It proves each target can:

- activate through the controller,
- report a healthy large lane,
- expose `/health` and `/v1/models`,
- show the intended context in the serving process,
- return one tiny OpenAI-compatible completion.

It does not benchmark throughput, test long-context correctness, validate quality, or run sustained load.
