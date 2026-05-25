# EB Run Critique

- Generated: 2026-05-25T14:43:41.1241985-04:00
- Run root: `E:\Dev\AI\remote\Entropy\runs\EB-LC\EB-LC-wave1-plain-entropy-nemotron120-20260525-142758`
- Results: `E:\Dev\AI\remote\Entropy\runs\EB-LC\EB-LC-wave1-plain-entropy-nemotron120-20260525-142758\results.jsonl`
- Critique JSON: `E:\Dev\AI\remote\Entropy\runs\EB-LC\EB-LC-wave1-plain-entropy-nemotron120-20260525-142758\critique.json`

## Rubric

Score is always 0-5: 0 means output-contract failure before useful code evaluation; 1 means minimal first-stage progress; 2 means partial local continuity; 3 means meaningful cross-stage progress; 4 means all generation stages completed but final validation failed; 5 means full workload validation passed.

Each critique also scores output contract, artifact continuity, dependency retention, validator readiness, and entropy pressure on the same 0-5 scale.

## Summary

| Target | Workload | Harness | Context | EB | Right shift | First fail | Cause | Tokens |
|---|---|---|---:|---:|---:|---|---|---:|
| entropy-nemotron120 | factory | plain | 65536 | 1 | 1/4 | factory-002-stations / harness | The harness or validator surfaced an unexpected failure outside the workload contract. | 6608 |
| entropy-nemotron120 | library-chain | plain | 65536 | 0 | 0/4 | lib-001-core / generation | The model lost the strict JSON response contract before code could be evaluated. | 4478 |
| entropy-nemotron120 | webpage-chain | plain | 65536 | 1 | 2/5 | web-003-chain-link / generation | The model lost the strict JSON response contract before code could be evaluated. | 11995 |

## Professional Critique

### entropy-nemotron120 / factory

- Model: `NVIDIA-Nemotron-3-Super-120B-A12B-UD-Q4_K_M-00001-of-00003.gguf`
- Context: 65536
- EB score: 1/5
- Entropy right shift: 1/4 stages (0.25)
- First failure: factory-002-stations / harness
- Failure detail: You cannot call a method on a null-valued expression.
- Likely entropy cause: The harness or validator surfaced an unexpected failure outside the workload contract.
- Token usage: prompt=3774, completion=2834, total=6608
- Dimension scores: output=1, continuity=1, dependency=1, validator=1, pressure=1

### entropy-nemotron120 / library-chain

- Model: `NVIDIA-Nemotron-3-Super-120B-A12B-UD-Q4_K_M-00001-of-00003.gguf`
- Context: 65536
- EB score: 0/5
- Entropy right shift: 0/4 stages (0)
- First failure: lib-001-core / generation
- Failure detail: model did not return a JSON object
- Likely entropy cause: The model lost the strict JSON response contract before code could be evaluated.
- Token usage: prompt=382, completion=4096, total=4478
- Dimension scores: output=0, continuity=0, dependency=0, validator=0, pressure=0

### entropy-nemotron120 / webpage-chain

- Model: `NVIDIA-Nemotron-3-Super-120B-A12B-UD-Q4_K_M-00001-of-00003.gguf`
- Context: 65536
- EB score: 1/5
- Entropy right shift: 2/5 stages (0.4)
- First failure: web-003-chain-link / generation
- Failure detail: model did not return a JSON object
- Likely entropy cause: The model lost the strict JSON response contract before code could be evaluated.
- Token usage: prompt=6390, completion=5605, total=11995
- Dimension scores: output=0, continuity=1, dependency=1, validator=1, pressure=2
