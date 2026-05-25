# EB Run Critique

- Generated: 2026-05-25T12:56:05.6004089-04:00
- Run root: `E:\Dev\AI\remote\Entropy\runs\EB-LC\EB-LC-wave1-plain-entropy-granite-code-3b-20260525-125357`
- Results: `E:\Dev\AI\remote\Entropy\runs\EB-LC\EB-LC-wave1-plain-entropy-granite-code-3b-20260525-125357\results.jsonl`
- Critique JSON: `E:\Dev\AI\remote\Entropy\runs\EB-LC\EB-LC-wave1-plain-entropy-granite-code-3b-20260525-125357\critique.json`

## Rubric

Score is always 0-5: 0 means output-contract failure before useful code evaluation; 1 means minimal first-stage progress; 2 means partial local continuity; 3 means meaningful cross-stage progress; 4 means all generation stages completed but final validation failed; 5 means full workload validation passed.

Each critique also scores output contract, artifact continuity, dependency retention, validator readiness, and entropy pressure on the same 0-5 scale.

## Summary

| Target | Workload | Harness | Context | EB | Right shift | First fail | Cause | Tokens |
|---|---|---|---:|---:|---:|---|---|---:|
| entropy-granite-code-3b | factory | plain | 262144 | 0 | 0/4 | factory-001-layout / generation | The model lost the strict JSON response contract before code could be evaluated. | 2048 |
| entropy-granite-code-3b | library-chain | plain | 262144 | 0 | 0/4 | lib-001-core / generation | The model lost the strict JSON response contract before code could be evaluated. | 437 |
| entropy-granite-code-3b | webpage-chain | plain | 262144 | 0 | 0/5 | web-001-home / generation | The model lost the strict JSON response contract before code could be evaluated. | 2048 |

## Professional Critique

### entropy-granite-code-3b / factory

- Model: `granite-3b-code-instruct.Q8_0.gguf`
- Context: 262144
- EB score: 0/5
- Entropy right shift: 0/4 stages (0)
- First failure: factory-001-layout / generation
- Failure detail: model did not return a JSON object
- Likely entropy cause: The model lost the strict JSON response contract before code could be evaluated.
- Token usage: prompt=443, completion=1605, total=2048
- Dimension scores: output=0, continuity=0, dependency=0, validator=0, pressure=0

### entropy-granite-code-3b / library-chain

- Model: `granite-3b-code-instruct.Q8_0.gguf`
- Context: 262144
- EB score: 0/5
- Entropy right shift: 0/4 stages (0)
- First failure: lib-001-core / generation
- Failure detail: model did not return a JSON object
- Likely entropy cause: The model lost the strict JSON response contract before code could be evaluated.
- Token usage: prompt=421, completion=16, total=437
- Dimension scores: output=0, continuity=0, dependency=0, validator=0, pressure=0

### entropy-granite-code-3b / webpage-chain

- Model: `granite-3b-code-instruct.Q8_0.gguf`
- Context: 262144
- EB score: 0/5
- Entropy right shift: 0/5 stages (0)
- First failure: web-001-home / generation
- Failure detail: model did not return a JSON object
- Likely entropy cause: The model lost the strict JSON response contract before code could be evaluated.
- Token usage: prompt=496, completion=1552, total=2048
- Dimension scores: output=0, continuity=0, dependency=0, validator=0, pressure=0
