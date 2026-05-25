# EB Run Critique

- Generated: 2026-05-25T08:23:47.5338794-04:00
- Run root: `E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-qwen36-20260525-080340`
- Results: `E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-qwen36-20260525-080340\results.jsonl`
- Critique JSON: `E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-qwen36-20260525-080340\critique.json`

## Rubric

Score is always 0-5: 0 means output-contract failure before useful code evaluation; 1 means minimal first-stage progress; 2 means partial local continuity; 3 means meaningful cross-stage progress; 4 means all generation stages completed but final validation failed; 5 means full workload validation passed.

Each critique also scores output contract, artifact continuity, dependency retention, validator readiness, and entropy pressure on the same 0-5 scale.

## Summary

| Target | Workload | Harness | Context | EB | Right shift | First fail | Cause | Tokens |
|---|---|---|---:|---:|---:|---|---|---:|
| entropy-qwen36 | factory | repair-extract | 262144 | 3 | 3/4 | factory-004-dashboard / harness | The harness or validator surfaced an unexpected failure outside the workload contract. | 332317 |
| entropy-qwen36 | library-chain | repair-extract | 262144 | 4 | 4/4 | final-validation / missing_artifact | The generated tree did not preserve or create a required artifact. | 61576 |
| entropy-qwen36 | webpage-chain | repair-extract | 262144 | 4 | 5/5 | final-validation / missing_artifact | The generated tree did not preserve or create a required artifact. | 75926 |

## Professional Critique

### entropy-qwen36 / factory

- Model: `Qwen3.6-35B-A3B-UD-Q4_K_M.gguf`
- Context: 262144
- EB score: 3/5
- Entropy right shift: 3/4 stages (0.75)
- First failure: factory-004-dashboard / harness
- Failure detail: HTTP 400 posting http://192.168.1.203:8000/v1/completions body={"error":{"code":400,"message":"request (340872 tokens) exceeds the available context size (262144 tokens), try increasing it","type":"exceed_context_size_error","n_prompt_tokens":340872,"n_ctx":262144}}
- Likely entropy cause: The harness or validator surfaced an unexpected failure outside the workload contract.
- Token usage: prompt=313465, completion=18852, total=332317
- Dimension scores: output=3, continuity=3, dependency=3, validator=2, pressure=4

### entropy-qwen36 / library-chain

- Model: `Qwen3.6-35B-A3B-UD-Q4_K_M.gguf`
- Context: 262144
- EB score: 4/5
- Entropy right shift: 4/4 stages (1)
- First failure: final-validation / missing_artifact
- Failure detail: library-chain validation failed: missing project: CoreLib/CoreLib.csproj
- Likely entropy cause: The generated tree did not preserve or create a required artifact.
- Token usage: prompt=49618, completion=11958, total=61576
- Dimension scores: output=4, continuity=3, dependency=4, validator=3, pressure=5

### entropy-qwen36 / webpage-chain

- Model: `Qwen3.6-35B-A3B-UD-Q4_K_M.gguf`
- Context: 262144
- EB score: 4/5
- Entropy right shift: 5/5 stages (1)
- First failure: final-validation / missing_artifact
- Failure detail: webpage-chain validation failed: page index.html is missing title text
- Likely entropy cause: The generated tree did not preserve or create a required artifact.
- Token usage: prompt=64053, completion=11873, total=75926
- Dimension scores: output=4, continuity=3, dependency=4, validator=3, pressure=5
