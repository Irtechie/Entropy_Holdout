# Testing Operations

## Existing Activation Smoke Tests

Run all single-box Entropy activation targets:

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

These checks depend on the LLMCommune controller at `http://192.168.1.203:4000`, the serving lane on port `8000`, and SSH access to `dgx`.

## Existing Proof Files

- Single-box proof: `entropy-smoke-results-20260509-124418.jsonl`
- Qwen235 64K eager proof: `entropy-smoke-results-qwen235-2507-64k-eager-20260511-200059.jsonl`
- Latest Devstral spot check: `entropy-smoke-results-20260516-212329.jsonl`

## Future Benchmark Tests

The workload harness now has local deterministic mock checks before expensive model jobs:

```powershell
pwsh .\tools\entropy_workload_check.ps1
pwsh .\tools\run_entropy_workload.ps1 -Workload webpage-chain -Mode mock
pwsh .\tools\run_entropy_workload.ps1 -Workload library-chain -Mode mock
pwsh .\tools\run_entropy_workload.ps1 -Workload factory -Mode mock
pwsh .\tools\run_entropy_matrix.ps1 -Matrix .\benchmarks\entropy_workloads\matrix.default.json -ResultPath .\runs\entropy_matrix\verification-results.jsonl
pwsh .\tools\report_entropy_results.ps1 -ResultsPath .\runs\entropy_matrix\verification-results.jsonl
```

Current expected mock matrix summary:

- `webpage-chain`: 5/5 stages pass
- `library-chain`: 4/4 stages pass
- `factory`: 4/4 stages pass

External-service-dependent model runs should be separated from fast local validator tests.

## EB Serial Real Experiment Pattern

Run one target/workload first:

```powershell
pwsh .\tools\run_entropy_serial_experiment.ps1 -OnlySet entropy-qwen25-coder-05b-large -OnlyWorkload webpage-chain
```

Run the conservative small-target experiment:

```powershell
pwsh .\tools\run_entropy_serial_experiment.ps1 -ExperimentPath .\benchmarks\entropy_workloads\experiment.local-small.json
```

Run the full single-box experiment after the small run is understood:

```powershell
pwsh .\tools\run_entropy_serial_experiment.ps1 -ExperimentPath .\benchmarks\entropy_workloads\experiment.local-full-singlebox.json
```

The EB serial runner:

- activates one target at a time through the LLMCommune controller,
- discovers the served model id,
- runs each workload in `api` mode,
- appends all stage rows to one experiment `results.jsonl`,
- records controller/workload events in `events.jsonl`,
- writes reproducibility metadata to `run.json`,
- writes standardized critique files to `critique.md` and `critique.json`,
- keeps prompts, raw extracted model responses, raw API response JSON, token usage, and generated files under that run folder by default,
- continues after workload failure unless `-StopOnFailure` is passed.

The EB critique scale is the same for every target/workload:

- `0`: no valid stage output or strict output-contract failure before useful code evaluation.
- `1`: minimal first-stage progress.
- `2`: partial local continuity.
- `3`: meaningful cross-stage progress but incomplete workload invariants.
- `4`: all generation stages completed but final validation failed.
- `5`: all generation stages and final validation passed.

## First Real Baseline

Completed on 2026-05-25:

```text
runs/EB/EB-local-small-20260525-012128/results.jsonl
```

Report command:

```powershell
pwsh .\tools\report_entropy_results.ps1 -ResultsPath .\runs\EB\EB-local-small-20260525-012128\results.jsonl
```

Critique files:

```text
runs/EB/EB-local-small-20260525-012128/critique.md
runs/EB/EB-local-small-20260525-012128/critique.json
```

The first plain-mode EB run confirms the experiment loop works, preserves prompts/raw responses/token usage, and captures a comparable critique. The smallest models break early on strict JSON/file generation. Use this result as the baseline before adding a stronger harness mode.
