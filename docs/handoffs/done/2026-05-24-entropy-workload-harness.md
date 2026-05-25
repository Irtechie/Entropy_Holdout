# Entropy Workload Harness Handoff

Created: 2026-05-24
Last refreshed: 2026-05-24
Status: done

## Intent

Build staged code-generation benchmark workloads that measure how far Entropy/harnessing moves model breakage to the right across model size, context length, and harness behavior.

## Completed State

The local/mock benchmark baseline is implemented.

Completed manifest:

```text
docs/plans/2026-05-24-000-kb-entropy-workload-harness-manifest.md
```

Implemented:

- workload spec/scoring contract,
- webpage-chain mock runner and validator,
- library-chain mock runner and validator,
- generic factory mock runner and validator,
- default mock matrix runner,
- result reporter.

## Verification

Passed:

```powershell
pwsh .\tools\entropy_workload_check.ps1
pwsh .\tools\run_entropy_matrix.ps1 -Matrix .\benchmarks\entropy_workloads\matrix.default.json -ResultPath .\runs\entropy_matrix\verification-results.jsonl
pwsh .\tools\report_entropy_results.ps1 -ResultsPath .\runs\entropy_matrix\verification-results.jsonl
```

Mock matrix result:

- `webpage-chain`: 5/5 stages pass
- `library-chain`: 4/4 stages pass
- `factory`: 4/4 stages pass

## Next Work

Create a new plan for real model execution:

- add non-mock harness modes,
- call OpenAI-compatible model endpoints,
- use LLMCommune/Entropy target metadata,
- decide artifact retention policy for expensive runs,
- run the first small target before broad matrix execution.

## Human Required

Provide the exact factory seed/spec if the generic factory workload should be replaced.
