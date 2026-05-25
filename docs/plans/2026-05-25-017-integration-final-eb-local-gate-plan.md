# Slice 002: Pass Local No-Spend Gate

## Goal

Prove the benchmark harness is coherent before using model-fleet time.

## Expected Files

| Path | Op | Scope |
|---|---|---|
| `benchmarks/entropy_workloads/workloads.json` | edit | Align expected artifacts and harness-mode list with actual validators and experiment configs. |
| `tools/run_entropy_workload.ps1` | edit | Only if needed for harness-mode naming, deterministic extraction, or factory null handling. |
| `tools/validators/*.ps1` | edit | Only if validator defects are proven by golden fixtures. |
| `docs/reports/*` | create | Gate output or failure-origin audit if generated. |

## Verification

Run locally before any model queue:

```powershell
pwsh .\tools\entropy_workload_check.ps1
pwsh .\tools\run_entropy_matrix.ps1 -Matrix .\benchmarks\entropy_workloads\matrix.default.json -ResultPath .\runs\entropy_matrix\final-gate-results.jsonl
pwsh .\tools\report_entropy_results.ps1 -ResultsPath .\runs\entropy_matrix\final-gate-results.jsonl
```

Additional gate checks:

- Workload expected artifacts match validator-required paths.
- A known-good fixture or mock path validates all final workload outputs.
- Factory null-method failure is reproduced and fixed, or impossible to reproduce and quarantined with evidence.
- Current `repair-extract` is renamed/adjudicated as model-assisted repair unless deterministic extraction is implemented.

## Stop Conditions

- Any mock/golden validator failure.
- Any mismatch between prompt contract, expected artifacts, and validator.
- Any ambiguous harness exception.
