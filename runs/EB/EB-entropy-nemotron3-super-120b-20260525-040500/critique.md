# EB Run Critique

- Generated: 2026-05-25T04:33:09.6222721-04:00
- Run root: `E:\Dev\AI\remote\Entropy\runs\EB\EB-entropy-nemotron3-super-120b-20260525-040500`
- Results: `E:\Dev\AI\remote\Entropy\runs\EB\EB-entropy-nemotron3-super-120b-20260525-040500\results.jsonl`
- Critique JSON: `E:\Dev\AI\remote\Entropy\runs\EB\EB-entropy-nemotron3-super-120b-20260525-040500\critique.json`

## Rubric

Score is always 0-5: 0 means output-contract failure before useful code evaluation; 1 means minimal first-stage progress; 2 means partial local continuity; 3 means meaningful cross-stage progress; 4 means all generation stages completed but final validation failed; 5 means full workload validation passed.

Each critique also scores output contract, artifact continuity, dependency retention, validator readiness, and entropy pressure on the same 0-5 scale.

## Summary

| Target | Workload | Harness | Context | EB | Right shift | First fail | Cause | Tokens |
|---|---|---|---:|---:|---:|---|---|---:|
| entropy-nemotron3-super-120b | factory | plain | 65536 | 1 | 1/4 | factory-002-stations / generation | The model produced files, but not at the paths required by the stage contract. | 8127 |
| entropy-nemotron3-super-120b | library-chain | plain | 65536 | 1 | 1/4 | lib-002-dependent / generation | The model lost the strict JSON response contract before code could be evaluated. | 11838 |
| entropy-nemotron3-super-120b | webpage-chain | plain | 65536 | 3 | 4/5 | web-005-nested-shared-table / harness | The harness or validator surfaced an unexpected failure outside the workload contract. | 26935 |

## Professional Critique

### entropy-nemotron3-super-120b / factory

- Model: `NVIDIA-Nemotron-3-Super-120B-A12B-UD-Q4_K_M-00001-of-00003.gguf`
- Context: 65536
- EB score: 1/5
- Entropy right shift: 1/4 stages (0.25)
- First failure: factory-002-stations / generation
- Failure detail: model did not generate expected artifact path: factory-system/stations
- Likely entropy cause: The model produced files, but not at the paths required by the stage contract.
- Token usage: prompt=3165, completion=4962, total=8127
- Dimension scores: output=1, continuity=1, dependency=1, validator=1, pressure=1

### entropy-nemotron3-super-120b / library-chain

- Model: `NVIDIA-Nemotron-3-Super-120B-A12B-UD-Q4_K_M-00001-of-00003.gguf`
- Context: 65536
- EB score: 1/5
- Entropy right shift: 1/4 stages (0.25)
- First failure: lib-002-dependent / generation
- Failure detail: Conversion from JSON failed with error: Unexpected end when deserializing object. Path 'files[2]', line 14, position 5.
- Likely entropy cause: The model lost the strict JSON response contract before code could be evaluated.
- Token usage: prompt=4996, completion=6842, total=11838
- Dimension scores: output=0, continuity=1, dependency=1, validator=1, pressure=1

### entropy-nemotron3-super-120b / webpage-chain

- Model: `NVIDIA-Nemotron-3-Super-120B-A12B-UD-Q4_K_M-00001-of-00003.gguf`
- Context: 65536
- EB score: 3/5
- Entropy right shift: 4/5 stages (0.8)
- First failure: web-005-nested-shared-table / harness
- Failure detail: model response did not include choices text
- Likely entropy cause: The harness or validator surfaced an unexpected failure outside the workload contract.
- Token usage: prompt=19521, completion=7414, total=26935
- Dimension scores: output=3, continuity=3, dependency=3, validator=2, pressure=4
