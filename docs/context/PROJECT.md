# Project Map

Bootstrap: 2026-05-24
Bootstrap confidence: mixed

## What This Is

Entropy holdout and planning repo for two related but distinct efforts:

- Existing LLMCommune model activation smoke artifacts for Entropy target sets.
- Staged code-generation benchmark work to measure how far Entropy/harnessing moves the model break point across model size, context, and harness mode.

## How To Run

Activation smoke runner:

```powershell
pwsh .\run-entropy-smoke.ps1
pwsh .\run-entropy-smoke.ps1 -OnlySet entropy-devstral-small2
pwsh .\run-entropy-smoke.ps1 -IncludeDualBox
```

Staged benchmark harness local/mock commands:

```powershell
pwsh .\tools\entropy_workload_check.ps1
pwsh .\tools\run_entropy_workload.ps1 -Workload webpage-chain -Mode mock
pwsh .\tools\run_entropy_workload.ps1 -Workload library-chain -Mode mock
pwsh .\tools\run_entropy_workload.ps1 -Workload factory -Mode mock
pwsh .\tools\run_entropy_matrix.ps1 -Matrix .\benchmarks\entropy_workloads\matrix.default.json
pwsh .\tools\report_entropy_results.ps1 -ResultsPath <results.jsonl>
```

Serial real-model experiment pattern:

```powershell
pwsh .\tools\run_entropy_serial_experiment.ps1 -ExperimentPath .\benchmarks\entropy_workloads\experiment.local-small.json
```

Start smaller while proving real generation:

```powershell
pwsh .\tools\run_entropy_serial_experiment.ps1 -OnlySet entropy-qwen25-coder-05b-large -OnlyWorkload webpage-chain
```

## How To Test

Current deterministic checks are mostly artifact inspection:

```powershell
git status --short --branch
pwsh .\run-entropy-smoke.ps1 -OnlySet <set_id>
```

Current local benchmark verification:

```powershell
pwsh .\tools\entropy_workload_check.ps1
pwsh .\tools\run_entropy_matrix.ps1 -Matrix .\benchmarks\entropy_workloads\matrix.default.json -ResultPath .\runs\entropy_matrix\verification-results.jsonl
pwsh .\tools\report_entropy_results.ps1 -ResultsPath .\runs\entropy_matrix\verification-results.jsonl
```

## Current Architecture

This repo currently has no application source tree. It contains:

- `run-entropy-smoke.ps1`: PowerShell activation/readiness smoke runner.
- `llmcommune-entropy-targets.json`: model target manifest.
- `llmcommune-prd-queue-contexts.json`: PRD queue top-context handoff.
- `llmcommune-entropy-smoke-summary.md`: existing activation summary.
- `entropy-smoke-results-*.jsonl`: proof/result logs.
- `RESUME.md`: local restart summary.
- `ACTUAL_TEST_CODE.md`: notes on the current activation runner.
- `benchmarks/entropy_workloads/`: staged workload specs.
- `tools/run_entropy_workload.ps1`: local/mock workload runner.
- `tools/run_entropy_matrix.ps1`: matrix orchestrator.
- `tools/run_entropy_serial_experiment.ps1`: one-target-at-a-time real experiment runner.
- `tools/report_entropy_results.ps1`: break-point report summarizer.
- `tools/validators/`: workload validators.

## Subsystem Index

| Area | Read This | Use When | Confidence |
|---|---|---|---|
| Activation smoke runner | `docs/context/operations/testing.md` | Checking existing model readiness proof | verified |
| Workload benchmark plan | `docs/context/architecture/entropy-workloads.md` | Building the staged generation harness | mixed |
| Existing target state | `llmcommune-entropy-smoke-summary.md` | Choosing model/context targets | verified |

## Current Work Pointers

- Board: `todo.md`
- Completed mock harness manifest: `docs/plans/2026-05-24-000-kb-entropy-workload-harness-manifest.md`
- Completed handoff archive: `docs/handoffs/done/2026-05-24-entropy-workload-harness.md`
- Next likely work: run the first real serial experiment on `entropy-qwen25-coder-05b-large`.

## Known Sharp Edges

- Do not confuse activation smoke tests with the staged code-generation benchmark.
- Qwen235 64K eager is the known-good qwen235 Entropy handoff.
- Qwen235 128K is not smoke-proven.
- The factory workload seed/spec may be missing from this checkout.
- `run_entropy_serial_experiment.ps1` can activate Entropy targets and run workloads in `api` mode one by one.
- Real API mode is intentionally conservative and should be proven on one small target/workload before broad runs.

## Research Index

- Existing local research is mainly in root-level summary and JSON files.
- No external research has been performed for benchmark harness design in this repo.

## Do Not Repeat

- Do not document only the activation smoke harness when the user is asking about generated workload code.
- Do not route from global memories when this repo has local KB memory.

## Maintenance Notes

Keep `todo.md` pointed at active work only. Move completed work summaries to `todo-done.md`.
