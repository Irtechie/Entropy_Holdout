# EB Run Critique

- Generated: 2026-05-25T09:22:24.6868941-04:00
- Run root: `E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-nemotron120-20260525-084852`
- Results: `E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-nemotron120-20260525-084852\results.jsonl`
- Critique JSON: `E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-nemotron120-20260525-084852\critique.json`

## Rubric

Score is always 0-5: 0 means output-contract failure before useful code evaluation; 1 means minimal first-stage progress; 2 means partial local continuity; 3 means meaningful cross-stage progress; 4 means all generation stages completed but final validation failed; 5 means full workload validation passed.

Each critique also scores output contract, artifact continuity, dependency retention, validator readiness, and entropy pressure on the same 0-5 scale.

## Summary

| Target | Workload | Harness | Context | EB | Right shift | First fail | Cause | Tokens |
|---|---|---|---:|---:|---:|---|---|---:|
| entropy-nemotron120 | factory | repair-extract | 65536 | 4 | 4/4 | final-validation / missing_artifact | The generated tree did not preserve or create a required artifact. | 92518 |
| entropy-nemotron120 | library-chain | repair-extract | 65536 | 3 | 3/4 | lib-004-shared-interface / harness | The harness or validator surfaced an unexpected failure outside the workload contract. | 25846 |
| entropy-nemotron120 | webpage-chain | repair-extract | 65536 | 1 | 2/5 | web-003-chain-link / harness | The harness or validator surfaced an unexpected failure outside the workload contract. | 3470 |

## Professional Critique

### entropy-nemotron120 / factory

- Model: `NVIDIA-Nemotron-3-Super-120B-A12B-UD-Q4_K_M-00001-of-00003.gguf`
- Context: 65536
- EB score: 4/5
- Entropy right shift: 4/4 stages (1)
- First failure: final-validation / missing_artifact
- Failure detail: factory validation failed: missing json file: E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-nemotron120-20260525-084852\workloads\entropy-nemotron120\factory\factory-system\config\stations.json
- Likely entropy cause: The generated tree did not preserve or create a required artifact.
- Token usage: prompt=82581, completion=9937, total=92518
- Dimension scores: output=4, continuity=3, dependency=4, validator=3, pressure=5

### entropy-nemotron120 / library-chain

- Model: `NVIDIA-Nemotron-3-Super-120B-A12B-UD-Q4_K_M-00001-of-00003.gguf`
- Context: 65536
- EB score: 3/5
- Entropy right shift: 3/4 stages (0.75)
- First failure: lib-004-shared-interface / harness
- Failure detail: model response did not include choices text
- Likely entropy cause: The harness or validator surfaced an unexpected failure outside the workload contract.
- Token usage: prompt=18776, completion=7070, total=25846
- Dimension scores: output=3, continuity=3, dependency=3, validator=2, pressure=4

### entropy-nemotron120 / webpage-chain

- Model: `NVIDIA-Nemotron-3-Super-120B-A12B-UD-Q4_K_M-00001-of-00003.gguf`
- Context: 65536
- EB score: 1/5
- Entropy right shift: 2/5 stages (0.4)
- First failure: web-003-chain-link / harness
- Failure detail: model response did not include choices text
- Likely entropy cause: The harness or validator surfaced an unexpected failure outside the workload contract.
- Token usage: prompt=1898, completion=1572, total=3470
- Dimension scores: output=1, continuity=1, dependency=1, validator=1, pressure=2
