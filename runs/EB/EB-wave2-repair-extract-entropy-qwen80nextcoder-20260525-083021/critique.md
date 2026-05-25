# EB Run Critique

- Generated: 2026-05-25T08:34:52.3657468-04:00
- Run root: `E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-qwen80nextcoder-20260525-083021`
- Results: `E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-qwen80nextcoder-20260525-083021\results.jsonl`
- Critique JSON: `E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-qwen80nextcoder-20260525-083021\critique.json`

## Rubric

Score is always 0-5: 0 means output-contract failure before useful code evaluation; 1 means minimal first-stage progress; 2 means partial local continuity; 3 means meaningful cross-stage progress; 4 means all generation stages completed but final validation failed; 5 means full workload validation passed.

Each critique also scores output contract, artifact continuity, dependency retention, validator readiness, and entropy pressure on the same 0-5 scale.

## Summary

| Target | Workload | Harness | Context | EB | Right shift | First fail | Cause | Tokens |
|---|---|---|---:|---:|---:|---|---|---:|
| entropy-qwen80nextcoder | factory | repair-extract | 131072 | 1 | 1/4 | factory-002-stations / generation | The model produced files, but not at the paths required by the stage contract. | 34796 |
| entropy-qwen80nextcoder | library-chain | repair-extract | 131072 | 4 | 4/4 | final-validation / missing_artifact | The generated tree did not preserve or create a required artifact. | 36895 |
| entropy-qwen80nextcoder | webpage-chain | repair-extract | 131072 | 4 | 5/5 | final-validation / missing_artifact | The generated tree did not preserve or create a required artifact. | 29839 |

## Professional Critique

### entropy-qwen80nextcoder / factory

- Model: `Qwen3-Coder-Next-Q4_K_M.gguf`
- Context: 131072
- EB score: 1/5
- Entropy right shift: 1/4 stages (0.25)
- First failure: factory-002-stations / generation
- Failure detail: model did not generate expected artifact path: factory-system/stations
- Likely entropy cause: The model produced files, but not at the paths required by the stage contract.
- Token usage: prompt=32459, completion=2337, total=34796
- Dimension scores: output=1, continuity=1, dependency=1, validator=1, pressure=1

### entropy-qwen80nextcoder / library-chain

- Model: `Qwen3-Coder-Next-Q4_K_M.gguf`
- Context: 131072
- EB score: 4/5
- Entropy right shift: 4/4 stages (1)
- First failure: final-validation / missing_artifact
- Failure detail: library-chain validation failed: missing project: CoreLib/CoreLib.csproj
- Likely entropy cause: The generated tree did not preserve or create a required artifact.
- Token usage: prompt=35400, completion=1495, total=36895
- Dimension scores: output=4, continuity=3, dependency=4, validator=3, pressure=5

### entropy-qwen80nextcoder / webpage-chain

- Model: `Qwen3-Coder-Next-Q4_K_M.gguf`
- Context: 131072
- EB score: 4/5
- Entropy right shift: 5/5 stages (1)
- First failure: final-validation / missing_artifact
- Failure detail: webpage-chain validation failed: page index.html is missing title text
- Likely entropy cause: The generated tree did not preserve or create a required artifact.
- Token usage: prompt=28747, completion=1092, total=29839
- Dimension scores: output=4, continuity=3, dependency=4, validator=3, pressure=5
