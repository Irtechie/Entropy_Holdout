# EB Run Critique

- Generated: 2026-05-25T14:20:37.5408576-04:00
- Run root: `E:\Dev\AI\remote\Entropy\runs\EB-LC\EB-LC-wave1-plain-entropy-qwen80nextcoder-256k-20260525-141714`
- Results: `E:\Dev\AI\remote\Entropy\runs\EB-LC\EB-LC-wave1-plain-entropy-qwen80nextcoder-256k-20260525-141714\results.jsonl`
- Critique JSON: `E:\Dev\AI\remote\Entropy\runs\EB-LC\EB-LC-wave1-plain-entropy-qwen80nextcoder-256k-20260525-141714\critique.json`

## Rubric

Score is always 0-5: 0 means output-contract failure before useful code evaluation; 1 means minimal first-stage progress; 2 means partial local continuity; 3 means meaningful cross-stage progress; 4 means all generation stages completed but final validation failed; 5 means full workload validation passed.

Each critique also scores output contract, artifact continuity, dependency retention, validator readiness, and entropy pressure on the same 0-5 scale.

## Summary

| Target | Workload | Harness | Context | EB | Right shift | First fail | Cause | Tokens |
|---|---|---|---:|---:|---:|---|---|---:|
| entropy-qwen80nextcoder-256k | factory | plain | 262144 | 1 | 1/4 | factory-002-stations / harness | The harness or validator surfaced an unexpected failure outside the workload contract. | 3386 |
| entropy-qwen80nextcoder-256k | library-chain | plain | 262144 | 0 | 0/4 | lib-001-core / generation | The model produced files, but not at the paths required by the stage contract. | 1229 |
| entropy-qwen80nextcoder-256k | webpage-chain | plain | 262144 | 4 | 5/5 | final-validation / missing_artifact | The generated tree did not preserve or create a required artifact. | 35299 |

## Professional Critique

### entropy-qwen80nextcoder-256k / factory

- Model: `Qwen3-Coder-Next-Q4_K_M.gguf`
- Context: 262144
- EB score: 1/5
- Entropy right shift: 1/4 stages (0.25)
- First failure: factory-002-stations / harness
- Failure detail: You cannot call a method on a null-valued expression.
- Likely entropy cause: The harness or validator surfaced an unexpected failure outside the workload contract.
- Token usage: prompt=2894, completion=492, total=3386
- Dimension scores: output=1, continuity=1, dependency=1, validator=1, pressure=1

### entropy-qwen80nextcoder-256k / library-chain

- Model: `Qwen3-Coder-Next-Q4_K_M.gguf`
- Context: 262144
- EB score: 0/5
- Entropy right shift: 0/4 stages (0)
- First failure: lib-001-core / generation
- Failure detail: model did not generate expected artifact path: library-chain/core
- Likely entropy cause: The model produced files, but not at the paths required by the stage contract.
- Token usage: prompt=370, completion=859, total=1229
- Dimension scores: output=1, continuity=0, dependency=0, validator=0, pressure=0

### entropy-qwen80nextcoder-256k / webpage-chain

- Model: `Qwen3-Coder-Next-Q4_K_M.gguf`
- Context: 262144
- EB score: 4/5
- Entropy right shift: 5/5 stages (1)
- First failure: final-validation / missing_artifact
- Failure detail: webpage-chain validation failed: page page-4.html shared nav is missing page-4.html
- Likely entropy cause: The generated tree did not preserve or create a required artifact.
- Token usage: prompt=34223, completion=1076, total=35299
- Dimension scores: output=4, continuity=3, dependency=4, validator=3, pressure=5
