# Entropy Workload Benchmark Architecture

## Purpose

The benchmark should measure how far a model/harness combination can continue a staged coding task before generated artifacts break.

The primary metric is the break point moving "to the right": more stages completed, deeper dependency pressure survived, larger context retained, and fewer harness-induced failures.

## Workload Families

### Webpage Chain

The model incrementally writes a small website:

1. Generate page 1.
2. Generate page 2 linking back to page 1.
3. Generate page 3 linking back to page 2.
4. Continue to page 5.
5. Add shared structure all pages must use, such as shared navigation or nested table data.

Validators should check file existence, link integrity, shared structure consistency, and render/build sanity.

### Library / DLL Chain

The model incrementally writes a dependency chain:

1. Build library 1.
2. Build library 2 that depends on library 1.
3. Build library 3 that depends on library 2.
4. Continue until the chain and shared API constraints stress dependency tracking.

Validators should check compilation, imports/references, public API compatibility, and executable sample output.

### Factory Workload

The model builds an increasingly connected factory/system. This is the high-entropy workload because later steps depend on an accumulating architecture, not just a linear chain.

Validators should check generated component boundaries, configuration, dependency graph integrity, and end-to-end behavior.

## Implemented Local Harness

The first implementation supports mock/local execution for all three workloads:

```powershell
pwsh .\tools\run_entropy_workload.ps1 -Workload webpage-chain -Mode mock
pwsh .\tools\run_entropy_workload.ps1 -Workload library-chain -Mode mock
pwsh .\tools\run_entropy_workload.ps1 -Workload factory -Mode mock
```

The default matrix runs all three workloads against a mock target:

```powershell
pwsh .\tools\run_entropy_matrix.ps1 -Matrix .\benchmarks\entropy_workloads\matrix.default.json
```

Mock mode proves the benchmark contract, validators, result JSONL shape, and report path before expensive model calls.

## Result Shape

Each run should record:

- model target and served model id,
- requested context and observed context where available,
- workload family,
- stage number,
- harness mode,
- prompt hash or prompt id,
- generated files,
- validator results,
- first failing stage,
- failure class,
- timing and token usage when available.

## Open Decisions

- Exact factory workload seed/spec if a dropped-in file exists outside this checkout.
- Whether generated artifacts should be retained per run or compacted into summaries after validation.
- Whether harness modes compare plain prompting, file-carrying prompting, and Entropy-specific context handling in the first version.
- How real model calls should be routed: direct OpenAI-compatible endpoint calls, LLMCommune activation plus call, or a separate Entropy harness adapter.
