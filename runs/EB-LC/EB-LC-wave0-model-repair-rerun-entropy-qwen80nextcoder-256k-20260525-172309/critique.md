# EB Run Critique

- Generated: 2026-05-25T17:28:14.0766378-04:00
- Run root: `E:\Dev\AI\remote\Entropy\runs\EB-LC\EB-LC-wave0-model-repair-rerun-entropy-qwen80nextcoder-256k-20260525-172309`
- Results: `E:\Dev\AI\remote\Entropy\runs\EB-LC\EB-LC-wave0-model-repair-rerun-entropy-qwen80nextcoder-256k-20260525-172309\results.jsonl`
- Critique JSON: `.\runs\EB-LC\EB-LC-wave0-model-repair-rerun-entropy-qwen80nextcoder-256k-20260525-172309\critique.json`

## Rubric

Score is always 0-5: 0 means output-contract failure before useful code evaluation; 1 means minimal first-stage progress; 2 means partial local continuity; 3 means meaningful cross-stage progress; 4 means all generation stages completed but final validation failed; 5 means full workload validation passed.

Each critique also scores output contract, artifact continuity, dependency retention, validator readiness, and entropy pressure on the same 0-5 scale.

## Summary

| Target | Workload | Harness | Context | EB | Right shift | First fail | Cause | Tokens |
|---|---|---|---:|---:|---:|---|---|---:|
| entropy-qwen80nextcoder-256k | factory | model-repair | 262144 | 4 | 4/4 | final-validation / missing_artifact | The generated tree did not preserve or create a required artifact. | 25378 |
| entropy-qwen80nextcoder-256k | library-chain | model-repair | 262144 | 4 | 4/4 | final-validation / missing_artifact | The generated tree did not preserve or create a required artifact. | 29441 |
| entropy-qwen80nextcoder-256k | webpage-chain | model-repair | 262144 | 4 | 5/5 | final-validation / missing_artifact | The generated tree did not preserve or create a required artifact. | 35869 |

## Professional Critique

### entropy-qwen80nextcoder-256k / factory

- Model: `Qwen3-Coder-Next-Q4_K_M.gguf`
- Context: 262144
- EB score: 4/5
- Entropy right shift: 4/4 stages (1)
- First failure: final-validation / missing_artifact
- Failure detail: factory validation failed: missing station id intake
- Likely entropy cause: The generated tree did not preserve or create a required artifact.
- Token usage: prompt=23964, completion=1414, total=25378
- Dimension scores: output=4, continuity=3, dependency=4, validator=3, pressure=5

### entropy-qwen80nextcoder-256k / library-chain

- Model: `Qwen3-Coder-Next-Q4_K_M.gguf`
- Context: 262144
- EB score: 4/5
- Entropy right shift: 4/4 stages (1)
- First failure: final-validation / missing_artifact
- Failure detail: library-chain validation failed: project FeatureLib missing reference CoreLib/CoreLib.csproj
- Likely entropy cause: The generated tree did not preserve or create a required artifact.
- Token usage: prompt=28364, completion=1077, total=29441
- Dimension scores: output=4, continuity=3, dependency=4, validator=3, pressure=5

### entropy-qwen80nextcoder-256k / webpage-chain

- Model: `Qwen3-Coder-Next-Q4_K_M.gguf`
- Context: 262144
- EB score: 4/5
- Entropy right shift: 5/5 stages (1)
- First failure: final-validation / missing_artifact
- Failure detail: webpage-chain validation failed: page page-4.html shared nav is missing page-4.html
- Likely entropy cause: The generated tree did not preserve or create a required artifact.
- Token usage: prompt=34810, completion=1059, total=35869
- Dimension scores: output=4, continuity=3, dependency=4, validator=3, pressure=5
