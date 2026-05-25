# Entropy Resume

This repo is a small handoff bundle for Entropy LLMCommune smoke testing.

The purpose of the test is to prove which Entropy model activation sets can start, report healthy, expose an OpenAI-compatible endpoint, and return a tiny completion at the intended context size. The main controller used by the existing artifacts is `http://192.168.1.203:4000`.

## Source Files

- `llmcommune-entropy-smoke-summary.md` is the human-readable summary.
- `llmcommune-entropy-targets.json` is the target manifest consumed by the smoke runner.
- `llmcommune-prd-queue-contexts.json` is the top-context PRD queue handoff.
- `run-entropy-smoke.ps1` is the smoke runner.
- `entropy-smoke-results-*.jsonl` files are proof/result logs from individual runs.

There is no `docs` directory in the current checkout; the research and handoff files are at the repo root.

## Current Understanding

- Entropy profiles are solo large-lane runs. The mini lane stays dark.
- The runner preserves each profile's existing LLMCommune loader/runtime family.
- GGUF profiles stay on llama.cpp.
- Single-box Entropy targets were smoke-tested smallest to largest and passed.
- Qwen235 is the special dual-box case involving Spark plus GX10.

## Qwen235 State

Use `entropy-qwen235-2507-64k-eager` as the current qwen235 Entropy handoff.

Evidence:

- Result file: `entropy-smoke-results-qwen235-2507-64k-eager-20260511-200059.jsonl`
- Runtime: Ray/vLLM
- Model: `nvidia/Qwen3-235B-A22B-Instruct-2507-NVFP4`
- Context: 65536 target, 65536 observed
- Probe response: `qwen235 64k eager ready`

Do not treat the qwen235 128K rung as proven. `entropy-qwen235-2507-128k` got through several launcher fixes but timed out before API readiness during first-time FlashInfer/CUTLASS compilation. The normal non-eager 64K rung reached API-ready, then failed during the first chat completion with a CUDA/CUBLAS failure in the compiled execution path.

## Latest Local State

As of this resume file, the worktree already had these pre-existing local changes:

- Modified: `run-entropy-smoke.ps1`
- Untracked: `entropy-smoke-results-20260516-212329.jsonl`

The untracked May 16 result is a one-target smoke pass for `entropy-devstral-small2`, already active and healthy at 131072 context.

## Useful Commands

Run all single-box targets:

```powershell
pwsh .\run-entropy-smoke.ps1
```

Run one target:

```powershell
pwsh .\run-entropy-smoke.ps1 -OnlySet entropy-devstral-small2
```

Run dual-box targets too:

```powershell
pwsh .\run-entropy-smoke.ps1 -IncludeDualBox
```

Check current repo state:

```powershell
git status --short --branch
```

## Next Agent Notes

Start with `llmcommune-entropy-smoke-summary.md`, then verify any specific target against its proof result file before changing the handoff. If qwen235 work resumes, keep the eager 64K profile as the known-good baseline and treat 128K as experimental until it has a readiness check and real completion proof.
