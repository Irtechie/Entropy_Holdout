# Entropy Workload Benchmark Specs

These files define staged code-generation workloads for measuring how far an Entropy model/harness combination can progress before generated code breaks.

The benchmark is not a throughput test and is not the same as the LLMCommune activation smoke runner. Activation proves a model endpoint is alive. These workloads prove whether a model can keep extending a generated codebase under growing dependency pressure.

## Workloads

### `webpage-chain`

The model writes a small website over multiple stages. Each new page must preserve links and shared structure from earlier stages.

Breakage examples:

- missing page file,
- broken backlink,
- shared navigation/table inconsistent across pages,
- generated HTML cannot be parsed.

### `library-chain`

The model writes a chain of libraries where later libraries depend on earlier public APIs.

Breakage examples:

- missing project/library file,
- invalid reference/import,
- incompatible public API,
- sample app cannot call through the chain.

### `factory`

The model writes a growing factory/system with multiple connected components. This is intended to stress architecture retention more than linear file creation.

Breakage examples:

- missing component,
- broken dependency graph,
- invalid configuration,
- no end-to-end factory behavior.

## Result Contract

Every stage result should record:

- target model/set,
- observed or requested context,
- harness mode,
- workload and stage,
- generated files,
- validator outcomes,
- pass/fail status,
- first failure class,
- timing/token usage when available.

Run the local contract check:

```powershell
pwsh .\tools\entropy_workload_check.ps1
```

Run a conservative real serial experiment:

```powershell
pwsh .\tools\run_entropy_serial_experiment.ps1 -ExperimentPath .\benchmarks\entropy_workloads\experiment.local-small.json
```

For the first real run, use one target and one workload:

```powershell
pwsh .\tools\run_entropy_serial_experiment.ps1 -OnlySet entropy-qwen25-coder-05b-large -OnlyWorkload webpage-chain
```
