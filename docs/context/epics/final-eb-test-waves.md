# Final EB Test Waves

Status: active
Created: 2026-05-25
Last refreshed: 2026-05-25

## Intent

Design and execute the final Entropy Benchmark test program one wave at a time, with explicit gates that prevent another time-wasting full run from being launched before the harness, workload contracts, trace export, and scoring logic are trustworthy.

The scarce resource is operator attention and model-fleet opportunity cost, not raw inference dollars. The protocol must avoid stealing another week of human coordination from other uses of the boxes.

The research thesis is not "can a model make a small app." It is whether model/harness combinations keep working as staged dependency pressure increases: preserve old artifacts, integrate new constraints, recover from output-contract pressure, and continue producing executable results as context and state grow.

Current judgment: a new full EB-LC Wave 2 is blocked. The existing `repair-extract` experiment config exists, but the implementation is model-assisted reprompt repair, not deterministic extraction. Library and factory also have known test-design contamination risks that must be resolved before final claims.

## Success Criteria

- No full all-target model wave runs until local no-spend gates and a canary pass.
- After protocol freeze, no full-wave reruns for newly discovered scoring nuance. Rows are quarantined, annotated, or judged as-is.
- Maximum remaining pre-freeze fixes: the known harness/spec blockers plus at most two minor implementation corrections found by the local gate.
- Every workload has aligned `workloads.json`, workload spec, validator, prompt contract, stage artifact assertions, and final scoring.
- Every wave has a written hypothesis, included targets, included workloads, harness mode, stop conditions, and expected evidence paths before execution.
- Every completed wave gets an outcome judgment before the next wave is designed.
- Any `harness`, `prompt_spec_or_validator`, missing Langfuse export, or ambiguous failure-origin row blocks expansion until resolved or explicitly quarantined.
- Claims distinguish model behavior, harness behavior, prompt/spec failure, context-budget failure, and infrastructure failure.
- The final report is good enough to publish or share even if some rows fail, because failures are categorized instead of silently repaired away.

## Architecture Decisions

- Keep Wave 1 plain EB-LC as the baseline, but do not use library-chain or factory from that wave for strong model-ranking claims.
- Split protocol qualification from model evaluation. Local golden checks and small canaries are prerequisites for larger queues.
- Define harness modes by actual mechanics:
  - `plain`: one model response per stage, strict JSON file object, no repair.
  - `model-repair`: model is reprompted after parse/artifact failure. This describes the current `repair-extract` behavior.
  - `deterministic-extract`: harness extracts files from allowed delimiters or structured blocks without asking the model again. This does not currently exist.
  - `file-carry`: existing generated files are carried into later prompts by design.
  - `entropy`: Entropy harness mode under test, with its own explicit mechanics.
- Preserve contaminated runs as evidence, but mark them non-canonical for scoring.
- Require trace export and failure-origin audit for every model run folder.
- Prefer quarantine over rerun after a wave starts. Rerun only for missing artifacts/traces, infrastructure interruption, or a defect that invalidates the whole configured harness mode before enough evidence exists to judge it.
- Score breakpoint position, not just final success. A model that reaches stage 4 and then breaks is a meaningful result if the harness can explain the break.

## Protocol Freeze

Freeze starts after Gate A passes and the Wave 0 canary spec is approved.

Allowed changes after freeze:

- Correct run bookkeeping when required artifacts are missing.
- Quarantine rows with documented reasons.
- Fix infrastructure/serving failures that prevent a target from running at all.
- Add reporting rows or claim language that does not change the test.

Disallowed changes after freeze:

- Changing validators to make a result pass.
- Changing prompt contracts mid-wave.
- Renaming harness modes after data is collected.
- Re-running a full wave because an analysis preference changed.
- Mixing corrected and uncorrected protocol runs in one headline score.

## Research

- `docs/context/research/benchmark-wave-design.md`
- `docs/reports/2026-05-25-eb-lc-wave1-outcome-judgment.md`
- `docs/context/architecture/entropy-workloads.md`
- `docs/operations/langchain-langfuse-eb.md`

## Workstreams

| Workstream | Brainstorm | Manifest | Status | Notes |
|---|---|---|---|---|
| Evidence audit | n/a | n/a | active | Reconcile EB-LC Wave 1, archived direct Wave 1/Wave 2, and failure-origin classifications before claiming right-shift. |
| Harness contract repair | n/a | pending | pending | Fix/adjudicate library artifact mismatch, factory null failure, and harness-mode naming. |
| Golden preflight gate | n/a | pending | pending | Add deterministic local fixtures proving each workload stage, validator, artifact assertion, critique, and audit path. |
| Wave 0 canary | n/a | pending | blocked | Run only after golden gate; three medium-or-better targets that should pass at least one workload. |
| Wave 1 pilot | n/a | pending | blocked | Expand only after Wave 0 judgment; representative targets, not all targets. |
| Final full wave | n/a | pending | blocked | All agreed targets only after pilot passes stop conditions. |
| Reporting and claim audit | n/a | pending | blocked | Produce final tables with quarantines, allowed claims, unsupported claims, and source run folders. |

## Dependency Map

1. Evidence audit must finish before repair priorities are frozen.
2. Harness contract repair must finish before golden preflight.
3. Golden preflight must pass before Wave 0 canary.
4. Wave 0 canary must be judged before Wave 1 pilot is designed.
5. Wave 1 pilot must be judged before final full wave is designed.
6. Final reporting must not begin until every included run folder has trace export and failure-origin audit.

## Wave Gates

### Gate A: No-Spend Local Qualification

Pass requirements:

- `tools/entropy_workload_check.ps1` passes.
- Mock workload matrix passes for webpage-chain, library-chain, and factory.
- `workloads.json` expected artifacts match workload specs and validators.
- Factory null-method failure has a reproducer or fix.
- Harness modes in experiment configs are listed and mechanically accurate.
- Langfuse preflight passes.
- Failure-origin audit can classify known contaminated rows.

Stop conditions:

- Any mismatch between expected artifacts and validators.
- Any uncaught PowerShell harness exception in mock/golden mode.
- Any final validator failure on a known-good fixture.

### Gate B: Wave 0 Canary

Purpose: prove the selected harness mode produces interpretable evidence on a small model set that should be capable enough to pass something. Do not use the smallest targets first; they are weak diagnostics.

Default shape after Gate A:

- 3 targets: medium-or-better models with prior evidence of staged competence.
  - Include at least two prior Wave 1 webpage-chain full-pass targets.
  - Include at least one target with large context.
  - Avoid known tiny/zero-score targets in the canary.
- 3 workloads: webpage-chain, library-chain, factory.
- 1 harness mode only.
- Commit/export/judge before expanding.

Default candidate set, subject to operator approval:

- `entropy-devstral-small2`
- `entropy-gptoss20`
- `entropy-gemma4-e4b` or `entropy-gemma4-e2b`

Stop conditions:

- Missing `results.jsonl`, `critique.json`, `critique.md`, `run.json`, raw prompts/responses, or Langfuse export.
- Any `harness` or `prompt_spec_or_validator` origin not already quarantined.
- Any result that cannot be independently explained from artifacts.
- Zero clean workload passes across all three targets after Gate A. That means the frozen benchmark is not currently producing a usable pass/fail capability signal and must be stopped, narrowed, or redesigned instead of expanded.
- No library/factory progress beyond stage 1 if the selected harness mode is specifically intended to improve output-contract behavior.

### Gate C: Wave 1 Pilot

Purpose: estimate whether the canary behavior generalizes without spending on all 19 targets.

Default shape after Wave 0:

- 5 representative targets across context sizes and prior Wave 1 behavior.
- Same workload/harness mode as Wave 0 unless the Wave 0 judgment explicitly changes it.
- Failure-origin audit required before scoring.

Stop conditions:

- More than one harness/spec failure.
- Trace export failures.
- Outcome judgment cannot distinguish model failure from harness failure.

### Gate D: Final Full Wave

Purpose: produce the final all-target table only after the protocol has proven itself.

Default shape after pilot:

- Agreed target set, likely the 19 single-box EB-LC targets unless the pilot removes a target for infrastructure reasons.
- One harness mode per final claim. Do not mix modes inside a single headline score.
- Archive/quarantine all contaminated rows with reason and replacement policy.

Stop conditions:

- Any systemic harness/spec defect.
- Any target run missing required artifacts.
- Any claim that depends on quarantined data.

## Dark Factory Queue

Empty until Gate A passes. Do not queue full EB-LC Wave 2 or any all-target final wave while the local qualification gate is red.

When the queue opens, it should contain only the next wave, not the whole remaining program.

## Human Checkpoints

- Approve the harness-mode name and mechanics before Wave 0.
- Approve target selection and expected spend before Wave 0.
- Review Wave 0 judgment before Wave 1 pilot.
- Review Wave 1 pilot judgment before final full wave.
- Decide whether the missing exact factory seed/spec matters for final claims.

Default decision rule: when a checkpoint finds a flaw after freeze, choose quarantine/reporting unless the flaw makes the whole wave uninterpretable.

## Parked / Blocked

- `library-chain` expected artifacts in `workloads.json` use lowercase folder names while `library_chain.json` and the validator require exact .NET project paths.
- Four EB-LC Wave 1 factory rows hit a null-method harness failure at `factory-002-stations`.
- `benchmarks/entropy_workloads/workloads.json` does not list `repair-extract`, although Wave 2 experiment files use it.
- Current `repair-extract` behavior is model-assisted repair, not deterministic extraction.
- The exact original factory seed/spec is still missing from this checkout.

## Completion Criteria

- Final wave evidence is complete, trace-backed, and failure-origin audited.
- Final report lists allowed claims, unsupported claims, quarantined rows, and exact run-folder provenance.
- `todo.md`, `docs/context/PROJECT.md`, and relevant operations docs point to the final canonical evidence.
