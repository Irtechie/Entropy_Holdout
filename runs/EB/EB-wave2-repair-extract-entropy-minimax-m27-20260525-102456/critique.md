# EB Run Critique

- Generated: 2026-05-25T10:41:48.1537011-04:00
- Run root: `E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-minimax-m27-20260525-102456`
- Results: `E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-minimax-m27-20260525-102456\results.jsonl`
- Critique JSON: `E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-minimax-m27-20260525-102456\critique.json`

## Rubric

Score is always 0-5: 0 means output-contract failure before useful code evaluation; 1 means minimal first-stage progress; 2 means partial local continuity; 3 means meaningful cross-stage progress; 4 means all generation stages completed but final validation failed; 5 means full workload validation passed.

Each critique also scores output contract, artifact continuity, dependency retention, validator readiness, and entropy pressure on the same 0-5 scale.

## Summary

| Target | Workload | Harness | Context | EB | Right shift | First fail | Cause | Tokens |
|---|---|---|---:|---:|---:|---|---|---:|
| entropy-minimax-m27 | factory | repair-extract | 16384 | 1 | 1/4 | factory-002-stations / harness | The harness or validator surfaced an unexpected failure outside the workload contract. | 19528 |
| entropy-minimax-m27 | library-chain | repair-extract | 16384 | 3 | 3/4 | lib-004-shared-interface / harness | The harness or validator surfaced an unexpected failure outside the workload contract. | 27038 |
| entropy-minimax-m27 | webpage-chain | repair-extract | 16384 | 3 | 4/5 | web-005-nested-shared-table / harness | The harness or validator surfaced an unexpected failure outside the workload contract. | 20813 |

## Professional Critique

### entropy-minimax-m27 / factory

- Model: `MiniMax-M2.7-UD-IQ4_XS-00001-of-00004.gguf`
- Context: 16384
- EB score: 1/5
- Entropy right shift: 1/4 stages (0.25)
- First failure: factory-002-stations / harness
- Failure detail: HTTP 400 posting http://192.168.1.203:8000/v1/completions body={"error":{"code":400,"message":"request (31108 tokens) exceeds the available context size (16384 tokens), try increasing it","type":"exceed_context_size_error","n_prompt_tokens":31108,"n_ctx":16384}}
- Likely entropy cause: The harness or validator surfaced an unexpected failure outside the workload contract.
- Token usage: prompt=12490, completion=7038, total=19528
- Dimension scores: output=1, continuity=1, dependency=1, validator=1, pressure=1

### entropy-minimax-m27 / library-chain

- Model: `MiniMax-M2.7-UD-IQ4_XS-00001-of-00004.gguf`
- Context: 16384
- EB score: 3/5
- Entropy right shift: 3/4 stages (0.75)
- First failure: lib-004-shared-interface / harness
- Failure detail: HTTP 400 posting http://192.168.1.203:8000/v1/completions body={"error":{"code":400,"message":"request (35367 tokens) exceeds the available context size (16384 tokens), try increasing it","type":"exceed_context_size_error","n_prompt_tokens":35367,"n_ctx":16384}}
- Likely entropy cause: The harness or validator surfaced an unexpected failure outside the workload contract.
- Token usage: prompt=23572, completion=3466, total=27038
- Dimension scores: output=3, continuity=3, dependency=3, validator=2, pressure=4

### entropy-minimax-m27 / webpage-chain

- Model: `MiniMax-M2.7-UD-IQ4_XS-00001-of-00004.gguf`
- Context: 16384
- EB score: 3/5
- Entropy right shift: 4/5 stages (0.8)
- First failure: web-005-nested-shared-table / harness
- Failure detail: HTTP 400 posting http://192.168.1.203:8000/v1/completions body={"error":{"code":400,"message":"request (26450 tokens) exceeds the available context size (16384 tokens), try increasing it","type":"exceed_context_size_error","n_prompt_tokens":26450,"n_ctx":16384}}
- Likely entropy cause: The harness or validator surfaced an unexpected failure outside the workload contract.
- Token usage: prompt=18010, completion=2803, total=20813
- Dimension scores: output=3, continuity=3, dependency=3, validator=2, pressure=4
