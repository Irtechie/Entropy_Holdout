# EB Run Critique

- Generated: 2026-05-25T01:29:10.8981429-04:00
- Run root: `E:\Dev\AI\remote\Entropy\runs\EB\EB-local-small-20260525-012128`
- Results: `E:\Dev\AI\remote\Entropy\runs\EB\EB-local-small-20260525-012128\results.jsonl`
- Critique JSON: `E:\Dev\AI\remote\Entropy\runs\EB\EB-local-small-20260525-012128\critique.json`

## Rubric

Score is always 0-5: 0 means output-contract failure before useful code evaluation; 1 means minimal first-stage progress; 2 means partial local continuity; 3 means meaningful cross-stage progress; 4 means all generation stages completed but final validation failed; 5 means full workload validation passed.

Each critique also scores output contract, artifact continuity, dependency retention, validator readiness, and entropy pressure on the same 0-5 scale.

## Summary

| Target | Workload | Harness | Context | EB | Right shift | First fail | Cause | Tokens |
|---|---|---|---:|---:|---:|---|---|---:|
| entropy-gemma4-e2b | factory | plain | 262144 | 1 | 1/4 | factory-002-stations / generation | The model produced files, but not at the paths required by the stage contract. | 8724 |
| entropy-gemma4-e2b | library-chain | plain | 262144 | 3 | 3/4 | lib-004-shared-interface / generation | The model produced files, but not at the paths required by the stage contract. | 30197 |
| entropy-gemma4-e2b | webpage-chain | plain | 262144 | 3 | 4/5 | web-005-nested-shared-table / generation | The model produced files, but not at the paths required by the stage contract. | 60828 |
| entropy-granite-code-3b | factory | plain | 262144 | 0 | 0/4 | factory-001-layout / generation | The model lost the strict JSON response contract before code could be evaluated. | 2048 |
| entropy-granite-code-3b | library-chain | plain | 262144 | 0 | 0/4 | lib-001-core / generation | The model lost the strict JSON response contract before code could be evaluated. | 2048 |
| entropy-granite-code-3b | webpage-chain | plain | 262144 | 0 | 0/5 | web-001-home / generation | The model lost the strict JSON response contract before code could be evaluated. | 2048 |
| entropy-qwen25-coder-05b-large | factory | plain | 262144 | 0 | 0/4 | factory-001-layout / generation | The model copied the output schema placeholder instead of producing real files. | 267 |
| entropy-qwen25-coder-05b-large | library-chain | plain | 262144 | 0 | 0/4 | lib-001-core / generation | The model produced files, but not at the paths required by the stage contract. | 305 |
| entropy-qwen25-coder-05b-large | webpage-chain | plain | 262144 | 0 | 0/5 | web-001-home / generation | The model copied the output schema placeholder instead of producing real files. | 282 |
| entropy-smollm3-3b | factory | plain | 262144 | 0 | 0/4 | factory-001-layout / generation | The model lost the strict JSON response contract before code could be evaluated. | 2128 |
| entropy-smollm3-3b | library-chain | plain | 262144 | 0 | 0/4 | lib-001-core / generation | The model lost the strict JSON response contract before code could be evaluated. | 391 |
| entropy-smollm3-3b | webpage-chain | plain | 262144 | 1 | 1/5 | web-002-backlink / generation | The model produced files, but not at the paths required by the stage contract. | 1999 |

## Professional Critique

### entropy-gemma4-e2b / factory

- Model: `gemma-4-E2B-it-Q8_0.gguf`
- Context: 262144
- EB score: 1/5
- Entropy right shift: 1/4 stages (0.25)
- First failure: factory-002-stations / generation
- Failure detail: model did not generate expected artifact path: factory-system/stations
- Likely entropy cause: The model produced files, but not at the paths required by the stage contract.
- Token usage: prompt=5159, completion=3565, total=8724
- Dimension scores: output=1, continuity=1, dependency=1, validator=1, pressure=1

### entropy-gemma4-e2b / library-chain

- Model: `gemma-4-E2B-it-Q8_0.gguf`
- Context: 262144
- EB score: 3/5
- Entropy right shift: 3/4 stages (0.75)
- First failure: lib-004-shared-interface / generation
- Failure detail: model did not generate expected artifact path: library-chain/contracts
- Likely entropy cause: The model produced files, but not at the paths required by the stage contract.
- Token usage: prompt=26614, completion=3583, total=30197
- Dimension scores: output=1, continuity=3, dependency=3, validator=2, pressure=4

### entropy-gemma4-e2b / webpage-chain

- Model: `gemma-4-E2B-it-Q8_0.gguf`
- Context: 262144
- EB score: 3/5
- Entropy right shift: 4/5 stages (0.8)
- First failure: web-005-nested-shared-table / generation
- Failure detail: model did not generate expected artifact path: site/page-5.html
- Likely entropy cause: The model produced files, but not at the paths required by the stage contract.
- Token usage: prompt=54943, completion=5885, total=60828
- Dimension scores: output=1, continuity=3, dependency=3, validator=2, pressure=4

### entropy-granite-code-3b / factory

- Model: `granite-3b-code-instruct.Q8_0.gguf`
- Context: 262144
- EB score: 0/5
- Entropy right shift: 0/4 stages (0)
- First failure: factory-001-layout / generation
- Failure detail: model did not return a JSON object
- Likely entropy cause: The model lost the strict JSON response contract before code could be evaluated.
- Token usage: prompt=263, completion=1785, total=2048
- Dimension scores: output=0, continuity=0, dependency=0, validator=0, pressure=0

### entropy-granite-code-3b / library-chain

- Model: `granite-3b-code-instruct.Q8_0.gguf`
- Context: 262144
- EB score: 0/5
- Entropy right shift: 0/4 stages (0)
- First failure: lib-001-core / generation
- Failure detail: model did not return a JSON object
- Likely entropy cause: The model lost the strict JSON response contract before code could be evaluated.
- Token usage: prompt=259, completion=1789, total=2048
- Dimension scores: output=0, continuity=0, dependency=0, validator=0, pressure=0

### entropy-granite-code-3b / webpage-chain

- Model: `granite-3b-code-instruct.Q8_0.gguf`
- Context: 262144
- EB score: 0/5
- Entropy right shift: 0/5 stages (0)
- First failure: web-001-home / generation
- Failure detail: model did not return a JSON object
- Likely entropy cause: The model lost the strict JSON response contract before code could be evaluated.
- Token usage: prompt=268, completion=1780, total=2048
- Dimension scores: output=0, continuity=0, dependency=0, validator=0, pressure=0

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

### entropy-smollm3-3b / factory

- Model: `SmolLM3-Q4_K_M.gguf`
- Context: 262144
- EB score: 0/5
- Entropy right shift: 0/4 stages (0)
- First failure: factory-001-layout / generation
- Failure detail: Conversion from JSON failed with error: After parsing a value an unexpected character was encountered: l. Path 'files[14].content', line 61, position 83.
- Likely entropy cause: The model lost the strict JSON response contract before code could be evaluated.
- Token usage: prompt=252, completion=1876, total=2128
- Dimension scores: output=0, continuity=0, dependency=0, validator=0, pressure=0

### entropy-smollm3-3b / library-chain

- Model: `SmolLM3-Q4_K_M.gguf`
- Context: 262144
- EB score: 0/5
- Entropy right shift: 0/4 stages (0)
- First failure: lib-001-core / generation
- Failure detail: Conversion from JSON failed with error: After parsing a value an unexpected character was encountered: H. Path 'files[0].content', line 5, position 244.
- Likely entropy cause: The model lost the strict JSON response contract before code could be evaluated.
- Token usage: prompt=249, completion=142, total=391
- Dimension scores: output=0, continuity=0, dependency=0, validator=0, pressure=0

### entropy-smollm3-3b / webpage-chain

- Model: `SmolLM3-Q4_K_M.gguf`
- Context: 262144
- EB score: 1/5
- Entropy right shift: 1/5 stages (0.2)
- First failure: web-002-backlink / generation
- Failure detail: model did not generate expected artifact path: site/page-2.html
- Likely entropy cause: The model produced files, but not at the paths required by the stage contract.
- Token usage: prompt=1613, completion=386, total=1999
- Dimension scores: output=1, continuity=1, dependency=1, validator=1, pressure=1
