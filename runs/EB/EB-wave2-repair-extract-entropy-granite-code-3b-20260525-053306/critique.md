# EB Run Critique

- Generated: 2026-05-25T05:35:24.9552483-04:00
- Run root: `E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-granite-code-3b-20260525-053306`
- Results: `E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-granite-code-3b-20260525-053306\results.jsonl`
- Critique JSON: `E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-granite-code-3b-20260525-053306\critique.json`

## Rubric

Score is always 0-5: 0 means output-contract failure before useful code evaluation; 1 means minimal first-stage progress; 2 means partial local continuity; 3 means meaningful cross-stage progress; 4 means all generation stages completed but final validation failed; 5 means full workload validation passed.

Each critique also scores output contract, artifact continuity, dependency retention, validator readiness, and entropy pressure on the same 0-5 scale.

## Summary

| Target | Workload | Harness | Context | EB | Right shift | First fail | Cause | Tokens |
|---|---|---|---:|---:|---:|---|---|---:|
| entropy-granite-code-3b | factory | repair-extract | 262144 | 0 | 0/4 | factory-001-layout / harness | The harness or validator surfaced an unexpected failure outside the workload contract. | 2048 |
| entropy-granite-code-3b | library-chain | repair-extract | 262144 | 0 | 0/4 | lib-001-core / harness | The harness or validator surfaced an unexpected failure outside the workload contract. | 2048 |
| entropy-granite-code-3b | webpage-chain | repair-extract | 262144 | 0 | 0/5 | web-001-home / harness | The harness or validator surfaced an unexpected failure outside the workload contract. | 2048 |

## Professional Critique

### entropy-granite-code-3b / factory

- Model: `granite-3b-code-instruct.Q8_0.gguf`
- Context: 262144
- EB score: 0/5
- Entropy right shift: 0/4 stages (0)
- First failure: factory-001-layout / harness
- Failure detail: HTTP 400 posting http://192.168.1.203:8000/v1/completions body={"error":{"code":400,"message":"request (7155 tokens) exceeds the available context size (2048 tokens), try increasing it","type":"exceed_context_size_error","n_prompt_tokens":7155,"n_ctx":2048}}
- Likely entropy cause: The harness or validator surfaced an unexpected failure outside the workload contract.
- Token usage: prompt=263, completion=1785, total=2048
- Dimension scores: output=0, continuity=0, dependency=0, validator=0, pressure=0

### entropy-granite-code-3b / library-chain

- Model: `granite-3b-code-instruct.Q8_0.gguf`
- Context: 262144
- EB score: 0/5
- Entropy right shift: 0/4 stages (0)
- First failure: lib-001-core / harness
- Failure detail: HTTP 400 posting http://192.168.1.203:8000/v1/completions body={"error":{"code":400,"message":"request (5882 tokens) exceeds the available context size (2048 tokens), try increasing it","type":"exceed_context_size_error","n_prompt_tokens":5882,"n_ctx":2048}}
- Likely entropy cause: The harness or validator surfaced an unexpected failure outside the workload contract.
- Token usage: prompt=259, completion=1789, total=2048
- Dimension scores: output=0, continuity=0, dependency=0, validator=0, pressure=0

### entropy-granite-code-3b / webpage-chain

- Model: `granite-3b-code-instruct.Q8_0.gguf`
- Context: 262144
- EB score: 0/5
- Entropy right shift: 0/5 stages (0)
- First failure: web-001-home / harness
- Failure detail: HTTP 400 posting http://192.168.1.203:8000/v1/completions body={"error":{"code":400,"message":"request (6037 tokens) exceeds the available context size (2048 tokens), try increasing it","type":"exceed_context_size_error","n_prompt_tokens":6037,"n_ctx":2048}}
- Likely entropy cause: The harness or validator surfaced an unexpected failure outside the workload contract.
- Token usage: prompt=268, completion=1780, total=2048
- Dimension scores: output=0, continuity=0, dependency=0, validator=0, pressure=0
