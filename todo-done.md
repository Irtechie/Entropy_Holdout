# Todo Done

## 2026-05-25 - EB Wave 2 Repair-Extract Single-Box Complete

Completed Wave 2 `repair-extract` EB for all 19 single-box targets from the Wave 1 baseline set.

Harness/config baseline commit:

```text
2028e28 feat: add EB wave 2 repair-extract queue
```

Queue command:

```powershell
pwsh .\tools\run_eb_target_queue.ps1 -QueuePath .\benchmarks\entropy_workloads\wave2.repair-extract.targets.json -ExperimentPath .\benchmarks\entropy_workloads\experiment.wave2-repair-extract-singlebox.json -CommitEach -PushEach -SkipCompleted
```

Run folders:

```text
runs/EB/EB-wave2-repair-extract-*
```

Notes:

- All 19 targets classified as `completed-data-run`.
- Each run was committed and pushed individually after completion.
- Repair-extract keeps every initial and repair prompt/response under `_raw/`, records `repair_count`, `repair_history`, and aggregates token usage in each result row.
- No generated files were manually edited; repairs were model calls inside the named Wave 2 harness mode.
- Historical direct-run folders were later archived at tag `archive/pre-langchain-eb-evidence` and removed from active `main`; canonical reruns use `runs/EB-LC/`.

## 2026-05-25 - EB Failure-Origin Audit Added

Added `tools/write_eb_failure_origin_audit.ps1` and generated first-pass failure-origin audits:

```text
docs/reports/EB-wave1-plain-failure-origin-audit.md
docs/reports/EB-wave1-plain-failure-origin-audit.json
docs/reports/EB-wave2-repair-extract-failure-origin-audit.md
docs/reports/EB-wave2-repair-extract-failure-origin-audit.json
```

First-pass origin counts:

- Wave 1 plain: `model_or_entropy=36`, `prompt_spec_or_validator=13`, `infra_or_serving=7`, `context_budget=1`.
- Wave 2 repair-extract: `model_or_entropy=14`, `prompt_spec_or_validator=21`, `infra_or_serving=10`, `context_budget=12`.

The audits make completed data runs distinct from clean benchmark datapoints. These derived audit artifacts were later archived at tag `archive/pre-langchain-eb-evidence` and removed from active `main` with the old direct-run evidence.

## 2026-05-25 - EB Wave Skills Versioned

Created EB wave skills and kept the versioned copies in the repo:

```text
skills/eb-wave-runner/
skills/eb-wave-1-plain/
skills/eb-wave-2-repair-extract/
```

The skills encode first-principles failure-origin discipline, Wave 1 plain rules, Wave 2 repair-extract rules, and the requirement that LangChain/Langfuse remain pass-through instrumentation unless a later wave explicitly measures them as harness behavior. Repo-specific EB skills are intentionally not installed globally.

## 2026-05-25 - EB-LC Harness Prepared

Added the canonical LangChain/Langfuse pass-through harness path:

```text
tools/langchain_completion.py
tools/check_langchain_langfuse.ps1
requirements-eb-langchain.txt
docs/operations/langchain-langfuse-eb.md
benchmarks/entropy_workloads/experiment.langchain-wave1-plain-singlebox.json
benchmarks/entropy_workloads/experiment.langchain-wave2-repair-extract-singlebox.json
benchmarks/entropy_workloads/wave1.langchain.targets.json
benchmarks/entropy_workloads/wave2.langchain.targets.json
```

The harness keeps LangChain behavior-pass-through, requires Langfuse env vars for canonical runs, and writes clean reruns under `runs/EB-LC/`.

## 2026-05-25 - EB Wave 1 Plain Single-Box Baseline Complete

Completed the full Wave 1 `plain` EB baseline for every single-box target in `llmcommune-entropy-targets.json`.

Primary queue manifest:

```text
docs/plans/2026-05-25-000-kb-eb-remaining-singlebox-runs-manifest.md
```

Overnight queue runner:

```powershell
pwsh .\tools\run_eb_target_queue.ps1 -QueuePath .\benchmarks\entropy_workloads\wave1.remaining.targets.json -CommitEach -PushEach -SkipCompleted
```

All run folders live under:

```text
runs/EB/
```

Notes:

- Each target has its own EB folder with `run.json`, `events.jsonl`, `results.jsonl`, `critique.md`, `critique.json`, `report.json`, raw prompts/responses, token usage, and generated files.
- LLMCommune/model-serving recovery was allowed; generated model output was not repaired inside Wave 1.
- The final MiniMax commit initially hit a GitHub server-side 500 on normal push, then pushed successfully with `git push --no-thin origin main`.
- Next work is Wave 2: a separate repair/extract harness mode compared against these Wave 1 plain results.
- Historical direct-run folders were later archived at tag `archive/pre-langchain-eb-evidence` and removed from active `main`; canonical reruns use `runs/EB-LC/`.

## 2026-05-24 - Entropy Workload Harness Mock Baseline

Implemented the first local/mock Entropy staged code-generation benchmark harness.

Files added include workload specs under `benchmarks/entropy_workloads/`, validators under `tools/validators/`, a workload runner, a matrix runner, and a report summarizer.

Verification passed:

```powershell
pwsh .\tools\entropy_workload_check.ps1
pwsh .\tools\run_entropy_matrix.ps1 -Matrix .\benchmarks\entropy_workloads\matrix.default.json -ResultPath .\runs\entropy_matrix\verification-results.jsonl
pwsh .\tools\report_entropy_results.ps1 -ResultsPath .\runs\entropy_matrix\verification-results.jsonl
```

Mock matrix result:

- `webpage-chain`: 5/5 stages pass
- `library-chain`: 4/4 stages pass
- `factory`: 4/4 stages pass

Notes:

- Factory uses a generic seed because the exact dropped-in seed was not present in this checkout.
- Real model/Entropy harness calls are the next step.

## 2026-05-25 - First EB Small-Model Baseline

Ran:

```powershell
pwsh .\tools\run_entropy_serial_experiment.ps1 -ExperimentPath .\benchmarks\entropy_workloads\experiment.local-small.json
```

Result path:

```text
runs/EB/EB-local-small-20260525-012128/results.jsonl
```

Critique files:

```text
runs/EB/EB-local-small-20260525-012128/critique.md
runs/EB/EB-local-small-20260525-012128/critique.json
```

Summary:

- `entropy-qwen25-coder-05b-large`: failed stage 1 on all workloads.
- `entropy-gemma4-e2b`: reached webpage stage 4/5, library stage 3/4, and factory stage 1/4 before strict artifact-path failures.
- `entropy-granite-code-3b`: failed stage 1 on all workloads due JSON generation failures.
- `entropy-smollm3-3b`: reached webpage stage 1/5, failed stage 1 on library/factory JSON generation.

Conclusion:

The serial experiment pattern works and now preserves replay metadata, prompts, raw responses, token usage, generated files, and a standardized 0-5 critique. Plain JSON/file-output prompting is too brittle for the smallest models and should be followed by a stricter harness mode or a repair/extraction pass before broad single-box execution.

This historical direct-run result was later archived at tag `archive/pre-langchain-eb-evidence` and removed from active `main`.

Completed work summaries go here after active entries are removed from `todo.md`.
