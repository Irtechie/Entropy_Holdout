# EB Run Critique

- Generated: 2026-05-25T08:48:49.4911885-04:00
- Run root: `E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-gptoss120-20260525-083923`
- Results: `E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-gptoss120-20260525-083923\results.jsonl`
- Critique JSON: `E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-gptoss120-20260525-083923\critique.json`

## Rubric

Score is always 0-5: 0 means output-contract failure before useful code evaluation; 1 means minimal first-stage progress; 2 means partial local continuity; 3 means meaningful cross-stage progress; 4 means all generation stages completed but final validation failed; 5 means full workload validation passed.

Each critique also scores output contract, artifact continuity, dependency retention, validator readiness, and entropy pressure on the same 0-5 scale.

## Summary

| Target | Workload | Harness | Context | EB | Right shift | First fail | Cause | Tokens |
|---|---|---|---:|---:|---:|---|---|---:|
| entropy-gptoss120 | factory | repair-extract | 65536 | 1 | 1/4 | factory-002-stations / generation | The model produced files, but not at the paths required by the stage contract. | 34122 |
| entropy-gptoss120 | library-chain | repair-extract | 65536 | 4 | 4/4 | final-validation / missing_artifact | The generated tree did not preserve or create a required artifact. | 25639 |
| entropy-gptoss120 | webpage-chain | repair-extract | 65536 | 3 | 4/5 | web-005-nested-shared-table / harness | The harness or validator surfaced an unexpected failure outside the workload contract. | 60317 |

## Professional Critique

### entropy-gptoss120 / factory

- Model: `gpt-oss-120b-Q4_K_M-00001-of-00002.gguf`
- Context: 65536
- EB score: 1/5
- Entropy right shift: 1/4 stages (0.25)
- First failure: factory-002-stations / generation
- Failure detail: model did not generate expected artifact path: factory-system/stations
- Likely entropy cause: The model produced files, but not at the paths required by the stage contract.
- Token usage: prompt=29367, completion=4755, total=34122
- Dimension scores: output=1, continuity=1, dependency=1, validator=1, pressure=1

### entropy-gptoss120 / library-chain

- Model: `gpt-oss-120b-Q4_K_M-00001-of-00002.gguf`
- Context: 65536
- EB score: 4/5
- Entropy right shift: 4/4 stages (1)
- First failure: final-validation / missing_artifact
- Failure detail: library-chain validation failed: missing project: CoreLib/CoreLib.csproj
- Likely entropy cause: The generated tree did not preserve or create a required artifact.
- Token usage: prompt=19489, completion=6150, total=25639
- Dimension scores: output=4, continuity=3, dependency=4, validator=3, pressure=5

### entropy-gptoss120 / webpage-chain

- Model: `gpt-oss-120b-Q4_K_M-00001-of-00002.gguf`
- Context: 65536
- EB score: 3/5
- Entropy right shift: 4/5 stages (0.8)
- First failure: web-005-nested-shared-table / harness
- Failure detail: HTTP 400 posting http://192.168.1.203:8000/v1/completions body={"error":{"code":400,"message":"request (69405 tokens) exceeds the available context size (65536 tokens), try increasing it","type":"exceed_context_size_error","n_prompt_tokens":69405,"n_ctx":65536}}
- Likely entropy cause: The harness or validator surfaced an unexpected failure outside the workload contract.
- Token usage: prompt=50262, completion=10055, total=60317
- Dimension scores: output=3, continuity=3, dependency=3, validator=2, pressure=4
