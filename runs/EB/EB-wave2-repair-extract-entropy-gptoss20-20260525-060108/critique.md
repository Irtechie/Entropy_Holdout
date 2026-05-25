# EB Run Critique

- Generated: 2026-05-25T06:05:49.9360156-04:00
- Run root: `E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-gptoss20-20260525-060108`
- Results: `E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-gptoss20-20260525-060108\results.jsonl`
- Critique JSON: `E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-gptoss20-20260525-060108\critique.json`

## Rubric

Score is always 0-5: 0 means output-contract failure before useful code evaluation; 1 means minimal first-stage progress; 2 means partial local continuity; 3 means meaningful cross-stage progress; 4 means all generation stages completed but final validation failed; 5 means full workload validation passed.

Each critique also scores output contract, artifact continuity, dependency retention, validator readiness, and entropy pressure on the same 0-5 scale.

## Summary

| Target | Workload | Harness | Context | EB | Right shift | First fail | Cause | Tokens |
|---|---|---|---:|---:|---:|---|---|---:|
| entropy-gptoss20 | factory | repair-extract | 131072 | 1 | 1/4 | factory-002-stations / generation | The model produced files, but not at the paths required by the stage contract. | 30899 |
| entropy-gptoss20 | library-chain | repair-extract | 131072 | 1 | 1/4 | lib-002-dependent / harness | The harness or validator surfaced an unexpected failure outside the workload contract. | 11817 |
| entropy-gptoss20 | webpage-chain | repair-extract | 131072 | 1 | 1/5 | web-002-backlink / harness | The harness or validator surfaced an unexpected failure outside the workload contract. | 784 |

## Professional Critique

### entropy-gptoss20 / factory

- Model: `gpt-oss-20b-Q4_K_M.gguf`
- Context: 131072
- EB score: 1/5
- Entropy right shift: 1/4 stages (0.25)
- First failure: factory-002-stations / generation
- Failure detail: model did not generate expected artifact path: factory-system/stations
- Likely entropy cause: The model produced files, but not at the paths required by the stage contract.
- Token usage: prompt=27547, completion=3352, total=30899
- Dimension scores: output=1, continuity=1, dependency=1, validator=1, pressure=1

### entropy-gptoss20 / library-chain

- Model: `gpt-oss-20b-Q4_K_M.gguf`
- Context: 131072
- EB score: 1/5
- Entropy right shift: 1/4 stages (0.25)
- First failure: lib-002-dependent / harness
- Failure detail: model response did not include choices text
- Likely entropy cause: The harness or validator surfaced an unexpected failure outside the workload contract.
- Token usage: prompt=5618, completion=6199, total=11817
- Dimension scores: output=1, continuity=1, dependency=1, validator=1, pressure=1

### entropy-gptoss20 / webpage-chain

- Model: `gpt-oss-20b-Q4_K_M.gguf`
- Context: 131072
- EB score: 1/5
- Entropy right shift: 1/5 stages (0.2)
- First failure: web-002-backlink / harness
- Failure detail: model response did not include choices text
- Likely entropy cause: The harness or validator surfaced an unexpected failure outside the workload contract.
- Token usage: prompt=288, completion=496, total=784
- Dimension scores: output=1, continuity=1, dependency=1, validator=1, pressure=1
