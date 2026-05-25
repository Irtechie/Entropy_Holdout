---
name: eb-wave-2-repair-extract
description: Run or audit EB Wave 2 repair-extract. Use with eb-wave-runner when the user asks for Wave 2, repair-extract harness runs, reruns of contaminated Wave 2 target/workloads, or comparisons of repair-extract against Wave 1 plain. Enforces model-driven repair prompts only, full repair evidence capture, separate run prefix, and failure-origin audit before claims.
---

# EB Wave 2 Repair-Extract

## Purpose

Measure how far a named repair/extract harness moves the EB breakpoint relative to Wave 1. Wave 2 may repair malformed output through model calls, but it must preserve every attempt as evidence.

## Allowed

- Use experiment config with `harness_mode: repair-extract`.
- Use a distinct run prefix such as `EB-wave2-repair-extract`.
- After output-contract or artifact-path failure, ask the model a bounded repair prompt.
- Preserve initial and repair prompts, raw response text, raw API JSON, token usage, `repair_count`, and `repair_history`.
- Recover infrastructure separately from generated-output repair.

## Forbidden

- Do not manually edit generated output.
- Do not silently parse prose or invent files outside the named repair harness.
- Do not overwrite Wave 1 folders or use Wave 1 completion detection.
- Do not treat context overflow caused by larger repair prompts as a model failure.
- Do not call observability, LangChain, Langfuse, or Playwright behavior "transparent" if it changes prompts, retries, extraction, memory, routing, tools, or repair.
- LangChain is allowed as pass-through workflow structure only: same prompt bytes, same model endpoint/options, same call count, and same raw response. Disable output parsers, retry policies, fallback models, memory, tools, and hidden prompt templates unless they are explicitly the Wave 2 harness being measured.

## Required Harness Artifact

Before broad Wave 2 execution, make sure the repo contains:

- experiment JSON with `harness_mode: repair-extract`
- queue JSON with distinct `run_prefix`
- repair prompt template
- retry/attempt limit
- raw attempt preservation
- token aggregation
- critique and failure-origin audit scripts
- replay command in each run folder

## Required Audit

After running Wave 2 or rerunning any contaminated Wave 2 slice:

```powershell
pwsh .\tools\write_eb_failure_origin_audit.ps1 -WaveId EB-wave2-repair-extract -RunGlob 'EB-wave2-repair-extract-*'
```

Report `model_or_entropy`, `prompt_spec_or_validator`, `infra_or_serving`, `context_budget`, `harness`, and `needs_manual_review` counts separately.

## Interpretation

Wave 2 only proves right-shift where the failure origin is clean or where the repair harness explicitly handled a Wave 1 output failure. Increased context-budget failures are harness contamination, not model regression.
