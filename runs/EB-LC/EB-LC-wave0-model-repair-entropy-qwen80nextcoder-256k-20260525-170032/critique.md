# EB Run Critique

- Generated: 2026-05-25T17:09:51.4429737-04:00
- Run root: `E:\Dev\AI\remote\Entropy\runs\EB-LC\EB-LC-wave0-model-repair-entropy-qwen80nextcoder-256k-20260525-170032`
- Results: `E:\Dev\AI\remote\Entropy\runs\EB-LC\EB-LC-wave0-model-repair-entropy-qwen80nextcoder-256k-20260525-170032\results.jsonl`
- Critique JSON: `.\runs\EB-LC\EB-LC-wave0-model-repair-entropy-qwen80nextcoder-256k-20260525-170032\critique.json`

## Rubric

Score is always 0-5: 0 means output-contract failure before useful code evaluation; 1 means minimal first-stage progress; 2 means partial local continuity; 3 means meaningful cross-stage progress; 4 means all generation stages completed but final validation failed; 5 means full workload validation passed.

Each critique also scores output contract, artifact continuity, dependency retention, validator readiness, and entropy pressure on the same 0-5 scale.

## Summary

| Target | Workload | Harness | Context | EB | Right shift | First fail | Cause | Tokens |
|---|---|---|---:|---:|---:|---|---|---:|
| entropy-qwen80nextcoder-256k | factory | model-repair | 262144 | 2 | 2/4 | factory-003-configuration / harness | The harness or validator surfaced an unexpected failure outside the workload contract. | 97034 |
| entropy-qwen80nextcoder-256k | library-chain | model-repair | 262144 | 2 | 2/4 | lib-003-chain / harness | The harness or validator surfaced an unexpected failure outside the workload contract. | 131291 |
| entropy-qwen80nextcoder-256k | webpage-chain | model-repair | 262144 | 4 | 5/5 | final-validation / missing_artifact | The generated tree did not preserve or create a required artifact. | 35847 |

## Professional Critique

### entropy-qwen80nextcoder-256k / factory

- Model: `Qwen3-Coder-Next-Q4_K_M.gguf`
- Context: 262144
- EB score: 2/5
- Entropy right shift: 2/4 stages (0.5)
- First failure: factory-003-configuration / harness
- Failure detail: You cannot call a method on a null-valued expression.
- Likely entropy cause: The harness or validator surfaced an unexpected failure outside the workload contract.
- Token usage: prompt=96157, completion=877, total=97034
- Dimension scores: output=2, continuity=2, dependency=2, validator=2, pressure=2

### entropy-qwen80nextcoder-256k / library-chain

- Model: `Qwen3-Coder-Next-Q4_K_M.gguf`
- Context: 262144
- EB score: 2/5
- Entropy right shift: 2/4 stages (0.5)
- First failure: lib-003-chain / harness
- Failure detail: You cannot call a method on a null-valued expression.
- Likely entropy cause: The harness or validator surfaced an unexpected failure outside the workload contract.
- Token usage: prompt=130109, completion=1182, total=131291
- Dimension scores: output=2, continuity=2, dependency=2, validator=2, pressure=2

### entropy-qwen80nextcoder-256k / webpage-chain

- Model: `Qwen3-Coder-Next-Q4_K_M.gguf`
- Context: 262144
- EB score: 4/5
- Entropy right shift: 5/5 stages (1)
- First failure: final-validation / missing_artifact
- Failure detail: webpage-chain validation failed: page page-4.html shared nav is missing page-4.html
- Likely entropy cause: The generated tree did not preserve or create a required artifact.
- Token usage: prompt=34778, completion=1069, total=35847
- Dimension scores: output=4, continuity=3, dependency=4, validator=3, pressure=5
