# EB Run Critique

- Generated: 2026-05-25T02:13:57.4472679-04:00
- Run root: `E:\Dev\AI\remote\Entropy\runs\EB\EB-entropy-gptoss20-20260525-020858`
- Results: `E:\Dev\AI\remote\Entropy\runs\EB\EB-entropy-gptoss20-20260525-020858\results.jsonl`
- Critique JSON: `E:\Dev\AI\remote\Entropy\runs\EB\EB-entropy-gptoss20-20260525-020858\critique.json`

## Rubric

Score is always 0-5: 0 means output-contract failure before useful code evaluation; 1 means minimal first-stage progress; 2 means partial local continuity; 3 means meaningful cross-stage progress; 4 means all generation stages completed but final validation failed; 5 means full workload validation passed.

Each critique also scores output contract, artifact continuity, dependency retention, validator readiness, and entropy pressure on the same 0-5 scale.

## Summary

| Target | Workload | Harness | Context | EB | Right shift | First fail | Cause | Tokens |
|---|---|---|---:|---:|---:|---|---|---:|
| entropy-gptoss20 | factory | plain | 131072 | 2 | 2/4 | factory-003-configuration / generation | The model produced files, but not at the paths required by the stage contract. | 13224 |
| entropy-gptoss20 | library-chain | plain | 131072 | 1 | 1/4 | lib-002-dependent / generation | The model produced files, but not at the paths required by the stage contract. | 11751 |
| entropy-gptoss20 | webpage-chain | plain | 131072 | 4 | 5/5 | final-validation / missing_artifact | The generated tree did not preserve or create a required artifact. | 54078 |

## Professional Critique

### entropy-gptoss20 / factory

- Model: `gpt-oss-20b-Q4_K_M.gguf`
- Context: 131072
- EB score: 2/5
- Entropy right shift: 2/4 stages (0.5)
- First failure: factory-003-configuration / generation
- Failure detail: model did not generate expected artifact path: factory-system/config
- Likely entropy cause: The model produced files, but not at the paths required by the stage contract.
- Token usage: prompt=10184, completion=3040, total=13224
- Dimension scores: output=1, continuity=2, dependency=2, validator=2, pressure=2

### entropy-gptoss20 / library-chain

- Model: `gpt-oss-20b-Q4_K_M.gguf`
- Context: 131072
- EB score: 1/5
- Entropy right shift: 1/4 stages (0.25)
- First failure: lib-002-dependent / generation
- Failure detail: model did not generate expected artifact path: library-chain/feature
- Likely entropy cause: The model produced files, but not at the paths required by the stage contract.
- Token usage: prompt=5608, completion=6143, total=11751
- Dimension scores: output=1, continuity=1, dependency=1, validator=1, pressure=1

### entropy-gptoss20 / webpage-chain

- Model: `gpt-oss-20b-Q4_K_M.gguf`
- Context: 131072
- EB score: 4/5
- Entropy right shift: 5/5 stages (1)
- First failure: final-validation / missing_artifact
- Failure detail: webpage-chain validation failed: page index.html is missing title text
- Likely entropy cause: The generated tree did not preserve or create a required artifact.
- Token usage: prompt=44950, completion=9128, total=54078
- Dimension scores: output=4, continuity=3, dependency=4, validator=3, pressure=5
