# LLMCommune Entropy Smoke Summary

Date: 2026-05-09

Updated: 2026-05-11

Controller: `http://192.168.1.203:4000`

Primary single-box results: `entropy-smoke-results-20260509-124418.jsonl`

Retired dual-box Qwen235 TRT result: `entropy-smoke-results-qwen235-20260509-130552.jsonl`

Dual-box Qwen235 2507 vLLM 128K result: `entropy-smoke-results-qwen235-2507-128k-socket90-jobs2-20260510-122915.jsonl`

Dual-box Qwen235 2507 vLLM 64K eager result: `entropy-smoke-results-qwen235-2507-64k-eager-20260511-200059.jsonl`

PRD queue top-context handoff: `llmcommune-prd-queue-contexts.json`

Target manifest: `llmcommune-entropy-targets.json`

Smoke runner: `run-entropy-smoke.ps1`

## Policy

- Entropy profiles are solo large-lane runs; mini lane stays dark.
- Existing LLMCommune loader/runtime type was preserved for every profile.
- GGUF profiles stayed on llama.cpp.
- The old `entropy-qwen235` TensorRT-LLM copy was retired after the 2507 eager path passed and became canonical LLMCommune `qwen235`.
- Qwen235 2507 targets use the newer 2507 NVFP4 model on Ray/vLLM after operator approval to evaluate a better path than the old TRT copy.
- Single-box targets were tested smallest to largest before Qwen235.

## Single-Box Sweep

All 16 single-box Entropy targets activated, reported healthy, exposed the expected OpenAI-compatible endpoint, and completed a tiny `/v1/completions` probe.

| Set | Params | Target ctx | Observed ctx | Status |
| --- | ---: | ---: | ---: | --- |
| `entropy-qwen25-coder-05b-large` | 0.5B | 262144 | 262144 | pass |
| `entropy-gemma4-e2b` | 2B | 262144 | 262144 | pass |
| `entropy-smollm3-3b` | 3B | 262144 | 262144 | pass |
| `entropy-granite-code-3b` | 3B | 262144 | 262144 | pass |
| `entropy-gemma4-e4b` | 4B | 262144 | 262144 | pass |
| `entropy-qwen35-4b` | 4B | 262144 | 262144 | pass |
| `entropy-gptoss20` | 20B | 131072 | 131072 | pass |
| `entropy-devstral-small2` | 24B | 131072 | 131072 | pass |
| `entropy-nemotron-cascade-30b` | 30B | 131072 | 131072 | pass |
| `entropy-gemma431` | 31B | 262144 | 262144 | pass |
| `entropy-qwen36` | 35B | 262144 | 262144 | pass |
| `entropy-qwen80next` | 80B | 131072 | 131072 | pass |
| `entropy-gptoss120` | 120B | 65536 | 65536 | pass |
| `entropy-nemotron120` | 120B | 65536 | 65536 | pass |
| `entropy-qwen35-122b` | 122B | 65536 | 65536 | pass |
| `entropy-minimax-m27` | 230B | 16384 | 16384 | pass |

## PRD Queue Coverage

The corrected PRD queue targets now have a top-context handoff file for Entropy.

| PRD id | Entropy set | Top smoke-passed ctx | Proof |
| --- | --- | ---: | --- |
| `qwen25-coder-05b` | `entropy-qwen25-coder-05b-large` | 262144 | `entropy-smoke-results-20260509-124418.jsonl` |
| `gemma4-e2b` | `entropy-gemma4-e2b` | 262144 | `entropy-smoke-results-20260509-124418.jsonl` |
| `smollm3-3b` | `entropy-smollm3-3b` | 262144 | `entropy-smoke-results-20260509-124418.jsonl` |
| `granite-code-3b` | `entropy-granite-code-3b` | 262144 | `entropy-smoke-results-20260509-124418.jsonl` |
| `gemma4-e4b` | `entropy-gemma4-e4b` | 262144 | `entropy-smoke-results-20260509-124418.jsonl` |
| `qwen35-4b` | `entropy-qwen35-4b` | 262144 | `entropy-smoke-results-20260509-124418.jsonl` |
| `nemotron-cascade-30b` | `entropy-nemotron-cascade-30b` | 131072 | `entropy-smoke-results-20260509-124418.jsonl` |
| `qwen80nextcoder` | `entropy-qwen80nextcoder-256k` | 262144 | `entropy-smoke-results-qwen80nextcoder-256k-20260509-135555.jsonl` |
| `gptoss120` | `entropy-gptoss120` | 65536 | `entropy-smoke-results-20260509-124418.jsonl` |
| `nemotron120` | `entropy-nemotron3-super-120b` | 65536 | `entropy-smoke-results-nemotron3-alias-20260509-135101.jsonl` |
| `qwen235` | `entropy-qwen235-2507-64k-eager` | 65536 | `entropy-smoke-results-qwen235-2507-64k-eager-20260511-200059.jsonl` |

Notes:

- `qwen80nextcoder` has both a 128K target and a smoke-passed 256K top target. Use `entropy-qwen80nextcoder-256k` for the PRD run.
- `nemotron120` now has a MODEL_MAP-compatible activation set, `entropy-nemotron3-super-120b`, using profile id `gguf_nemotron3_super_120b_large`.
- `gptoss120` is covered even though the PRD marks it as an out-of-order rerun.

## Qwen235

`entropy-qwen235` was run last, separately with `-IncludeDualBox`.

Result: fail.

- Target context: 32768
- Activation status: `failed`
- Elapsed: 1220.3s
- Probe error: `No connection could be made because the target machine actively refused it. (192.168.1.203:8000)`
- Controller state after failure was `failed_known_idle` with `failure_code=LAUNCH_FAILED`.
- Root cause from `workspace/jobs/_lanes/qwen235/serve-8000.log`: TensorRT-LLM reached both ranks, then failed during executor initialization with `Please set max_seq_len to at least 32768 for kv cache manager`.

The non-Entropy `qwen235` path has prior successful activations in LLMCommune audit history, so this should be treated as a failed Entropy copy/activation attempt, not evidence that the proven base Qwen235 recipe is invalid.

This was not a short wait problem. The qwen235 launcher waited the configured 1200s API timeout after the TRT executor had already failed. It also was not an obvious GX10 cleanup miss: the worker container started on GX10 and NCCL initialized both ranks.

This target is now retired from LLMCommune. The stale `nvidia/Qwen3-235B-A22B-NVFP4` model directory was removed from both Spark and GX10, and canonical LLMCommune `qwen235` now points at the 2507 64K eager vLLM profile.

### Qwen235 2507 Ray/vLLM 128K

`entropy-qwen235-2507-128k` was added as an experimental replacement candidate using `nvidia/Qwen3-235B-A22B-Instruct-2507-NVFP4`.

Result: not smoke-proven.

- Target context: 131072
- Runtime: Ray/vLLM across Spark and GX10
- Result file: `entropy-smoke-results-qwen235-2507-128k-socket90-jobs2-20260510-122915.jsonl`
- Final smoke error: activation timed out after 1800s before the API became ready.
- Earlier attempts showed the default NCCL path selected `NET/IBext_v11` and failed on RoCE GID mismatch. The launcher now forces `NCCL_NET=Socket`, `NCCL_IB_DISABLE=1`, and `NCCL_IBEXT_DISABLE=1`.
- At `GPU_MEMORY_UTILIZATION=0.94`, vLLM failed memory preflight. The launcher now uses `GPU_MEMORY_UTILIZATION=0.90`.
- First-time FlashInfer/CUTLASS kernel compilation caused a severe compile storm until the launcher was patched to mount `/root/.cache/flashinfer` and cap compile concurrency with `MAX_JOBS=2`, `NVCC_THREADS=1`, and `FLASHINFER_NVCC_THREADS=1`.
- The latest controlled run loaded all 28 shards and remained responsive, but it was still compiling kernels when both the 1800s smoke activation timeout and the 2400s launcher ready window elapsed.

Do not use this target as the PRD top-context qwen235 handoff. Use the 64K eager target below.

### Qwen235 2507 Ray/vLLM 64K

`entropy-qwen235-2507-64k` was added to check whether the 128K target was too high.

Result: not smoke-proven.

- Target context: 65536
- Runtime: Ray/vLLM across Spark and GX10
- Result: API reached ready, then the first chat completion crashed EngineCore.
- Root cause from `workspace/jobs/_lanes/qwen235_2507_64k/serve-8000.log`: `CUBLAS_STATUS_INTERNAL_ERROR` in the torch/inductor compiled CUDA graph path.

This showed that context size was not the only blocker. The normal 64K rung could start, but the compiled execution path was not stable enough for Entropy.

### Qwen235 2507 Ray/vLLM 64K Eager

`entropy-qwen235-2507-64k-eager` keeps the same Ray/vLLM dual-box loader and model, but adds `--enforce-eager` and `--disable-custom-all-reduce`.

Result: pass.

- Target context: 65536
- Observed context: 65536
- Runtime: Ray/vLLM across Spark and GX10
- Result file: `entropy-smoke-results-qwen235-2507-64k-eager-20260511-200059.jsonl`
- Probe: `/v1/chat/completions` returned `qwen235 64k eager ready`
- Controller still reported `entropy-qwen235-2507-64k-eager` ready after the probe.

Use this as the current top qwen235 Entropy handoff. This is also canonical LLMCommune `qwen235` now. Keep the 128K rung as not-top until it can pass readiness and a real completion.

## Final Runtime State

After the failed Qwen235 2507 128K and normal 64K attempts, the eager 64K rung was activated and passed a real completion.

Final checked state:

- Controller desired state: ready
- Active set: `qwen235`
- Large lane process: Ray/vLLM Qwen3 235B A22B Instruct 2507 NVFP4 on Spark+GX10 port 8000 with 65536 target context
- Mini lane: dark
- GX10: participates in the active qwen235 Ray/vLLM run

## Runner Notes

The smoke runner now handles:

- Already-active controller responses returned as HTTP 400 with `ok=true/status=skipped`.
- Activation cooldown responses with UTC-safe backoff.
- Deterministic manifest order instead of sorting hashtables incorrectly.
- Optional dual-box inclusion via `-IncludeDualBox`.
- One-target validation via `-OnlySet`.
