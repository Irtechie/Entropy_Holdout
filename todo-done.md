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

Completed work summaries go here after active entries are removed from `todo.md`.
