# EB Run Critique

- Generated: 2026-05-25T09:57:37.8582468-04:00
- Run root: `E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-nemotron3-super-120b-20260525-092227`
- Results: `E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-nemotron3-super-120b-20260525-092227\results.jsonl`
- Critique JSON: `E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-nemotron3-super-120b-20260525-092227\critique.json`

## Rubric

Score is always 0-5: 0 means output-contract failure before useful code evaluation; 1 means minimal first-stage progress; 2 means partial local continuity; 3 means meaningful cross-stage progress; 4 means all generation stages completed but final validation failed; 5 means full workload validation passed.

Each critique also scores output contract, artifact continuity, dependency retention, validator readiness, and entropy pressure on the same 0-5 scale.

## Summary

| Target | Workload | Harness | Context | EB | Right shift | First fail | Cause | Tokens |
|---|---|---|---:|---:|---:|---|---|---:|
| entropy-nemotron3-super-120b | factory | repair-extract | 65536 | 4 | 4/4 | final-validation / harness | The harness or validator surfaced an unexpected failure outside the workload contract. | 40019 |
| entropy-nemotron3-super-120b | library-chain | repair-extract | 65536 | 3 | 3/4 | lib-004-shared-interface / harness | The harness or validator surfaced an unexpected failure outside the workload contract. | 64684 |
| entropy-nemotron3-super-120b | webpage-chain | repair-extract | 65536 | 3 | 4/5 | web-005-nested-shared-table / harness | The harness or validator surfaced an unexpected failure outside the workload contract. | 61293 |

## Professional Critique

### entropy-nemotron3-super-120b / factory

- Model: `NVIDIA-Nemotron-3-Super-120B-A12B-UD-Q4_K_M-00001-of-00003.gguf`
- Context: 65536
- EB score: 4/5
- Entropy right shift: 4/4 stages (1)
- First failure: final-validation / harness
- Failure detail: factory validation failed: station count mismatch
- Likely entropy cause: The harness or validator surfaced an unexpected failure outside the workload contract.
- Token usage: prompt=33131, completion=6888, total=40019
- Dimension scores: output=4, continuity=4, dependency=4, validator=3, pressure=5

### entropy-nemotron3-super-120b / library-chain

- Model: `NVIDIA-Nemotron-3-Super-120B-A12B-UD-Q4_K_M-00001-of-00003.gguf`
- Context: 65536
- EB score: 3/5
- Entropy right shift: 3/4 stages (0.75)
- First failure: lib-004-shared-interface / harness
- Failure detail: HTTP 400 posting http://192.168.1.203:8000/v1/completions body={"error":{"code":400,"message":"request (72018 tokens) exceeds the available context size (65536 tokens), try increasing it","type":"exceed_context_size_error","n_prompt_tokens":72018,"n_ctx":65536}}
- Likely entropy cause: The harness or validator surfaced an unexpected failure outside the workload contract.
- Token usage: prompt=54058, completion=10626, total=64684
- Dimension scores: output=3, continuity=3, dependency=3, validator=2, pressure=4

### entropy-nemotron3-super-120b / webpage-chain

- Model: `NVIDIA-Nemotron-3-Super-120B-A12B-UD-Q4_K_M-00001-of-00003.gguf`
- Context: 65536
- EB score: 3/5
- Entropy right shift: 4/5 stages (0.8)
- First failure: web-005-nested-shared-table / harness
- Failure detail: HTTP 400 posting http://192.168.1.203:8000/v1/completions body={"error":{"code":400,"message":"request (68034 tokens) exceeds the available context size (65536 tokens), try increasing it","type":"exceed_context_size_error","n_prompt_tokens":68034,"n_ctx":65536}}
- Likely entropy cause: The harness or validator surfaced an unexpected failure outside the workload contract.
- Token usage: prompt=51106, completion=10187, total=61293
- Dimension scores: output=3, continuity=3, dependency=3, validator=2, pressure=4
