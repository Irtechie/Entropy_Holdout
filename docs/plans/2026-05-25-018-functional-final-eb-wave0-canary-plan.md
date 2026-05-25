# Slice 003: Run And Judge Three-Target Wave 0 Canary

## Goal

Spend the smallest useful model-fleet time on targets that should be able to pass something. A canary made of tiny or already-hopeless targets does not diagnose the benchmark.

## Default Shape

- One harness mode only.
- Three medium-or-better targets:
  - at least two prior Wave 1 webpage-chain full-pass targets,
  - at least one large-context target,
  - no known tiny/zero-score target.
- Three workloads: webpage-chain, library-chain, factory.

Default candidates:

- `entropy-devstral-small2`
- `entropy-gptoss20`
- `entropy-gemma4-e4b` or `entropy-gemma4-e2b`

## Verification

For each run folder:

- `run.json`
- `results.jsonl`
- `critique.md`
- `critique.json`
- raw prompts and responses
- Langfuse export under `langfuse/`
- failure-origin audit row for every failure

Then write an outcome judgment before expanding.

## Stop Conditions

- Missing required run artifacts.
- Missing Langfuse traces.
- Any unquarantined `harness` or `prompt_spec_or_validator` failure.
- Any failure that cannot be explained from stored artifacts.
- Zero clean workload passes across the three targets after the local gate. If that happens, stop; do not expand to a larger wave.
- No library/factory progress beyond stage 1 when the chosen harness mode is supposed to improve strict output-contract behavior.

## HITL

User approves whether Wave 0 justifies the pilot, should quarantine a workload/mode, or should call the experiment done with a narrower result.
