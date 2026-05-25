# Todo Done

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

Completed work summaries go here after active entries are removed from `todo.md`.
