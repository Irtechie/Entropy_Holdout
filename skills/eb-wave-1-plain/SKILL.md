---
name: eb-wave-1-plain
description: Run or audit EB Wave 1 plain baseline. Use with eb-wave-runner when the user asks for Wave 1, plain EB, baseline runs, reruns of contaminated Wave 1 target/workloads, or comparisons against later waves. Enforces no generated-output repair, no extraction assistance beyond the strict JSON contract, infrastructure-only recovery, one reproducible run folder per target, and failure-origin audit before claims.
---

# EB Wave 1 Plain

## Purpose

Measure the baseline model breakpoint with the simplest fair harness: prompt the model, require strict JSON file output, write files, validate. Wave 1 is the control group.

## Allowed

- Use the EB runner in `plain` harness mode.
- Retry or repair LLMCommune/controller/model-serving infrastructure before a benchmark call succeeds.
- Wait out activation cooldowns.
- Record model failures as data when the model responds and violates the output contract or generated-code contract.
- Commit one run folder per target when running individual targets.

## Forbidden

- Do not repair generated output.
- Do not ask the model a second "fix your JSON/files" prompt.
- Do not manually extract files from malformed prose.
- Do not edit generated artifacts.
- Do not count context overflow, no-choice API responses, controller failures, or load failures as model entropy failures.

## Required Harness Artifact

Before broad Wave 1 execution, make sure the repo contains:

- experiment JSON with `harness_mode: plain`
- queue JSON with run prefix `EB`
- workload specs
- validators
- runner scripts
- critique and failure-origin audit scripts
- replay command in each run folder

## Required Audit

After running Wave 1 or rerunning any contaminated Wave 1 slice:

```powershell
pwsh .\tools\write_eb_failure_origin_audit.ps1 -WaveId EB-wave1-plain -RunGlob 'EB-entropy-*'
```

Report `model_or_entropy`, `prompt_spec_or_validator`, `infra_or_serving`, `context_budget`, `harness`, and `needs_manual_review` counts separately.

## Interpretation

Only `model_or_entropy` rows are clean Wave 1 breakpoint evidence. Other origins are repair backlog for the benchmark, infrastructure, prompt, validator, or serving layer.
