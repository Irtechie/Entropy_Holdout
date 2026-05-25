# EB Run Critique

- Generated: 2026-05-25T05:13:53.3065395-04:00
- Run root: `E:\Dev\AI\remote\Entropy\runs\EB\EB-entropy-qwen25-coder-05b-large-20260525-051323`
- Results: `E:\Dev\AI\remote\Entropy\runs\EB\EB-entropy-qwen25-coder-05b-large-20260525-051323\results.jsonl`
- Critique JSON: `E:\Dev\AI\remote\Entropy\runs\EB\EB-entropy-qwen25-coder-05b-large-20260525-051323\critique.json`

## Rubric

Score is always 0-5: 0 means output-contract failure before useful code evaluation; 1 means minimal first-stage progress; 2 means partial local continuity; 3 means meaningful cross-stage progress; 4 means all generation stages completed but final validation failed; 5 means full workload validation passed.

Each critique also scores output contract, artifact continuity, dependency retention, validator readiness, and entropy pressure on the same 0-5 scale.

## Summary

| Target | Workload | Harness | Context | EB | Right shift | First fail | Cause | Tokens |
|---|---|---|---:|---:|---:|---|---|---:|
| entropy-qwen25-coder-05b-large | factory | plain | 262144 | 0 | 0/4 | factory-001-layout / generation | The model copied the output schema placeholder instead of producing real files. | 267 |
| entropy-qwen25-coder-05b-large | library-chain | plain | 262144 | 0 | 0/4 | lib-001-core / generation | The model produced files, but not at the paths required by the stage contract. | 305 |
| entropy-qwen25-coder-05b-large | webpage-chain | plain | 262144 | 0 | 0/5 | web-001-home / generation | The model copied the output schema placeholder instead of producing real files. | 282 |

## Professional Critique

### entropy-qwen25-coder-05b-large / factory

- Model: `qwen2.5-coder-0.5b-instruct-q4_k_m.gguf`
- Context: 262144
- EB score: 0/5
- Entropy right shift: 0/4 stages (0)
- First failure: factory-001-layout / generation
- Failure detail: model copied placeholder content instead of generating real file content
- Likely entropy cause: The model copied the output schema placeholder instead of producing real files.
- Token usage: prompt=222, completion=45, total=267
- Dimension scores: output=0, continuity=0, dependency=0, validator=0, pressure=0

### entropy-qwen25-coder-05b-large / library-chain

- Model: `qwen2.5-coder-0.5b-instruct-q4_k_m.gguf`
- Context: 262144
- EB score: 0/5
- Entropy right shift: 0/4 stages (0)
- First failure: lib-001-core / generation
- Failure detail: model did not generate expected artifact path: library-chain/core
- Likely entropy cause: The model produced files, but not at the paths required by the stage contract.
- Token usage: prompt=219, completion=86, total=305
- Dimension scores: output=1, continuity=0, dependency=0, validator=0, pressure=0

### entropy-qwen25-coder-05b-large / webpage-chain

- Model: `qwen2.5-coder-0.5b-instruct-q4_k_m.gguf`
- Context: 262144
- EB score: 0/5
- Entropy right shift: 0/5 stages (0)
- First failure: web-001-home / generation
- Failure detail: model copied placeholder content instead of generating real file content
- Likely entropy cause: The model copied the output schema placeholder instead of producing real files.
- Token usage: prompt=228, completion=54, total=282
- Dimension scores: output=0, continuity=0, dependency=0, validator=0, pressure=0
