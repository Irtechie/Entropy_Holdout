# EB Run Critique

- Generated: 2026-05-25T03:24:25.0250481-04:00
- Run root: `E:\Dev\AI\remote\Entropy\runs\EB\EB-entropy-qwen80nextcoder-256k-20260525-032159`
- Results: `E:\Dev\AI\remote\Entropy\runs\EB\EB-entropy-qwen80nextcoder-256k-20260525-032159\results.jsonl`
- Critique JSON: `E:\Dev\AI\remote\Entropy\runs\EB\EB-entropy-qwen80nextcoder-256k-20260525-032159\critique.json`

## Rubric

Score is always 0-5: 0 means output-contract failure before useful code evaluation; 1 means minimal first-stage progress; 2 means partial local continuity; 3 means meaningful cross-stage progress; 4 means all generation stages completed but final validation failed; 5 means full workload validation passed.

Each critique also scores output contract, artifact continuity, dependency retention, validator readiness, and entropy pressure on the same 0-5 scale.

## Summary

| Target | Workload | Harness | Context | EB | Right shift | First fail | Cause | Tokens |
|---|---|---|---:|---:|---:|---|---|---:|
| entropy-qwen80nextcoder-256k | factory | plain | 262144 | 1 | 1/4 | factory-002-stations / generation | The model produced files, but not at the paths required by the stage contract. | 5201 |
| entropy-qwen80nextcoder-256k | library-chain | plain | 262144 | 2 | 2/4 | lib-003-chain / generation | The model lost the strict JSON response contract before code could be evaluated. | 6464 |
| entropy-qwen80nextcoder-256k | webpage-chain | plain | 262144 | 4 | 5/5 | final-validation / missing_artifact | The generated tree did not preserve or create a required artifact. | 29549 |

## Professional Critique

### entropy-qwen80nextcoder-256k / factory

- Model: `Qwen3-Coder-Next-Q4_K_M.gguf`
- Context: 262144
- EB score: 1/5
- Entropy right shift: 1/4 stages (0.25)
- First failure: factory-002-stations / generation
- Failure detail: model did not generate expected artifact path: factory-system/stations
- Likely entropy cause: The model produced files, but not at the paths required by the stage contract.
- Token usage: prompt=3574, completion=1627, total=5201
- Dimension scores: output=1, continuity=1, dependency=1, validator=1, pressure=1

### entropy-qwen80nextcoder-256k / library-chain

- Model: `Qwen3-Coder-Next-Q4_K_M.gguf`
- Context: 262144
- EB score: 2/5
- Entropy right shift: 2/4 stages (0.5)
- First failure: lib-003-chain / generation
- Failure detail: Conversion from JSON failed with error: After parsing a value an unexpected character was encountered: l. Path 'files[0].content', line 5, position 37.
- Likely entropy cause: The model lost the strict JSON response contract before code could be evaluated.
- Token usage: prompt=5743, completion=721, total=6464
- Dimension scores: output=0, continuity=2, dependency=2, validator=2, pressure=2

### entropy-qwen80nextcoder-256k / webpage-chain

- Model: `Qwen3-Coder-Next-Q4_K_M.gguf`
- Context: 262144
- EB score: 4/5
- Entropy right shift: 5/5 stages (1)
- First failure: final-validation / missing_artifact
- Failure detail: webpage-chain validation failed: page index.html is missing title text
- Likely entropy cause: The generated tree did not preserve or create a required artifact.
- Token usage: prompt=28459, completion=1090, total=29549
- Dimension scores: output=4, continuity=3, dependency=4, validator=3, pressure=5
