# EB-LC Close Failure Audit

Date: 2026-05-25

## Question

For close Wave 0 failures, are we seeing environment/runtime defects, an unfair ask/validator, or real model failures?

## Findings

1. `entropy-qwen80nextcoder-256k` was initially under-scored by harness/validator issues.
   - The model returned `"files": []` when it had already generated the required artifacts in an earlier stage.
   - The harness treated that no-op as a null-method failure instead of checking whether the expected artifact already existed.
   - Fix: `tools/run_entropy_workload.ps1` now accepts a no-op only when the stage's expected artifact already exists.

2. Two validators were too rigid.
   - `library-chain` accepted only backslash project-reference text, but generated `.csproj` files can validly use `/`.
   - `factory` accepted only `{ "stations": [...] }`, but the prompt allowed `stations.json` to contain the station list directly.
   - Fixes:
     - `tools/validators/library_chain.ps1` normalizes reference slashes.
     - `tools/validators/factory.ps1` accepts root station arrays and optional `Route:` labels while still checking the same route sequence.

3. After those fixes, the Qwen Coder rerun is strong:
   - Run: `runs/EB-LC/EB-LC-wave0-model-repair-rerun2-entropy-qwen80nextcoder-256k-20260525-173146/`
   - `library-chain`: pass 4/4 plus final validation.
   - `factory`: pass 4/4 plus final validation.
   - `webpage-chain`: stage 5 generated, final validation failed because page 4 shared nav omitted `page-4.html`.

4. Remaining failures are now mostly real benchmark behavior.
   - Qwen Coder webpage failure is a shared-state preservation miss.
   - Devstral library failure is real: `SampleApp` was not executable.
   - GPT-OSS webpage failure is context-budget related after prompt growth.

## Interpretation

The benchmark is viable, but it was too brittle in a few places. The corrections did not make the workloads easier; they removed false negatives for equivalent artifact shapes and no-op stage behavior after overgeneration.

`entropy-qwen80nextcoder-256k` should stay in the final candidate set. It is currently the best evidence that the library/factory workloads can pass under `model-repair`.

## Updated Claims

Supported:

- Medium-or-better models can pass EB workloads.
- `entropy-qwen80nextcoder-256k` passes library-chain and factory under the corrected `model-repair` harness.
- `entropy-devstral-small2` passes webpage-chain and has a post-hoc-valid factory route under the corrected factory validator.

Still not supported:

- A full final wave without another local gate and updated judgment.
- Treating sub-1B coding targets as meaningful coding-agent candidates.
- Ranking all models from the old Wave 0 report without accounting for the validator fixes.

## Next Gate

1. Commit the corrected Qwen Coder rerun and trace exports.
2. Refresh the Wave 0 judgment to point at the corrected Qwen Coder run.
3. Curate the final model roster around plausible coding agents plus one or two lower-bound small models.
