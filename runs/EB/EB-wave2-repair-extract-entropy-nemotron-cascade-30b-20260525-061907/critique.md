# EB Run Critique

- Generated: 2026-05-25T06:23:36.5784291-04:00
- Run root: `E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-nemotron-cascade-30b-20260525-061907`
- Results: `E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-nemotron-cascade-30b-20260525-061907\results.jsonl`
- Critique JSON: `E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-nemotron-cascade-30b-20260525-061907\critique.json`

## Rubric

Score is always 0-5: 0 means output-contract failure before useful code evaluation; 1 means minimal first-stage progress; 2 means partial local continuity; 3 means meaningful cross-stage progress; 4 means all generation stages completed but final validation failed; 5 means full workload validation passed.

Each critique also scores output contract, artifact continuity, dependency retention, validator readiness, and entropy pressure on the same 0-5 scale.

## Summary

| Target | Workload | Harness | Context | EB | Right shift | First fail | Cause | Tokens |
|---|---|---|---:|---:|---:|---|---|---:|
| entropy-nemotron-cascade-30b | factory | repair-extract | 131072 | 1 | 1/4 | factory-002-stations / harness | The harness or validator surfaced an unexpected failure outside the workload contract. | 3131 |
| entropy-nemotron-cascade-30b | library-chain | repair-extract | 131072 | 0 | 0/4 | lib-001-core / harness | The harness or validator surfaced an unexpected failure outside the workload contract. |  |
| entropy-nemotron-cascade-30b | webpage-chain | repair-extract | 131072 | 0 | 0/5 | web-001-home / harness | The harness or validator surfaced an unexpected failure outside the workload contract. |  |

## Professional Critique

### entropy-nemotron-cascade-30b / factory

- Model: `nvidia_Nemotron-Cascade-2-30B-A3B-Q4_K_M.gguf`
- Context: 131072
- EB score: 1/5
- Entropy right shift: 1/4 stages (0.25)
- First failure: factory-002-stations / harness
- Failure detail: model response did not include choices text
- Likely entropy cause: The harness or validator surfaced an unexpected failure outside the workload contract.
- Token usage: prompt=230, completion=2901, total=3131
- Dimension scores: output=1, continuity=1, dependency=1, validator=1, pressure=1

### entropy-nemotron-cascade-30b / library-chain

- Model: `nvidia_Nemotron-Cascade-2-30B-A3B-Q4_K_M.gguf`
- Context: 131072
- EB score: 0/5
- Entropy right shift: 0/4 stages (0)
- First failure: lib-001-core / harness
- Failure detail: model response did not include choices text
- Likely entropy cause: The harness or validator surfaced an unexpected failure outside the workload contract.
- Token usage: prompt=, completion=, total=
- Dimension scores: output=0, continuity=0, dependency=0, validator=0, pressure=0

### entropy-nemotron-cascade-30b / webpage-chain

- Model: `nvidia_Nemotron-Cascade-2-30B-A3B-Q4_K_M.gguf`
- Context: 131072
- EB score: 0/5
- Entropy right shift: 0/5 stages (0)
- First failure: web-001-home / harness
- Failure detail: model response did not include choices text
- Likely entropy cause: The harness or validator surfaced an unexpected failure outside the workload contract.
- Token usage: prompt=, completion=, total=
- Dimension scores: output=0, continuity=0, dependency=0, validator=0, pressure=0
