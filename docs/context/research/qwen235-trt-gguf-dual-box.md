# Qwen235 TRT/GGUF Dual-Box Findings

Checked: 2026-05-26

## Question

Can Qwen235 be trusted for the final EB waves through TRT again, or should it move to a dual-box GGUF Q3 path?

## Findings

- Do not run EB wave tests on the current Qwen235 TRT or Ray/vLLM paths.
- Historical evidence supports the old TRT lane better than Ray/vLLM: `trt_dual_qwen235_large` reached runtime-ready repeatedly from 2026-04-26 through 2026-05-08. That was the old `nvidia/Qwen3-235B-A22B-NVFP4` checkpoint with `nvcr.io/nvidia/tensorrt-llm/release:1.0.0rc3`.
- The old checkpoint path is no longer installed on either box. Current local storage only has `nvidia/Qwen3-235B-A22B-Instruct-2507-NVFP4`.
- NVIDIA's current DGX Spark TRT playbook lists Qwen3-235B-A22B as a two-Spark NVFP4 target, but the table names `nvidia/Qwen3-235B-A22B-FP4`, not the installed 2507 Instruct NVFP4 checkpoint.
- Live test: installed 2507 NVFP4 + TRT `1.3.0rc5` + 32K + RoCE/IB loaded weights but never exposed `/v1/models` before readiness timeout.
- Live test: installed 2507 NVFP4 + TRT `1.3.0rc13` + 32K + Socket transport also failed readiness. The log shows NCCL allocation failures: `Cuda failure 2 'out of memory'` before API readiness.
- Live test: Ray/vLLM 64K eager on 2026-05-26 reached API readiness after about 1559s and passed a short 10-token chat completion (`qwen235-ray-smoke-ok`).
- Live test: the same Ray/vLLM 64K eager run failed a 4096-token output-budget probe after 417.5s. The probe row recorded `request_failed`; the serve log shows `CUBLAS_STATUS_EXECUTION_FAILED`, then `EngineDeadError`, and the lane went down.
- Therefore Qwen235 is not eligible for Wave 1/Wave 2 unless a fresh serving path proves API readiness, a real short completion, and at least the agreed EB output-budget floor without killing the engine.
- Current llama.cpp build is single-host only for GGUF. `GGML_RPC=OFF` and no `rpc-server` binary exists. Dual-box GGUF requires a new llama.cpp build with RPC support on both boxes.
- llama.cpp RPC design: build with `-DGGML_RPC=ON`, run `rpc-server` on remote hosts, then run `llama-server`/`llama-cli` on the main host with `--rpc host:port`. Ordinary `--split-mode`/`--tensor-split` only covers devices visible to one host.
- Qwen235 GGUF Q3 is plausible as a dual-box experiment, not a ready EB target. It requires building RPC, downloading the GGUF shard set, adding LLMCommune launch scripts, and smoke-proving API plus real completion/output budget.

## Current Operational State

- `entropy-glm47-flash` was restored on `:8000` after the failed TRT and Ray experiments.
- Worker SSH recovered after the rc13 TRT stop issue. Still require fresh worker drain proof before any future dual-box experiment.

## Sources

- NVIDIA DGX Spark TRT-LLM playbook: https://build.nvidia.com/spark/trt-llm
- NVIDIA 2507 NVFP4 model card: https://huggingface.co/nvidia/Qwen3-235B-A22B-Instruct-2507-NVFP4
- NVIDIA forum report noting the two-Spark Qwen235 playbook/version mismatch and `1.0.0rc3` evidence: https://forums.developer.nvidia.com/t/failed-to-run-qwen3-235b-a22b-fp4-model-on-a-two-sparks-cluster/348963
- llama.cpp RPC README: https://github.com/ggml-org/llama.cpp/blob/master/tools/rpc/README.md

## Applies When

- Selecting final EB model targets.
- Deciding whether to reintroduce Qwen235.
- Designing a dual-box GGUF path for LLMCommune.

## Stale When

- Worker SSH/drain proof is restored and a fresh TRT or GGUF smoke passes real completion.
- The exact old Qwen235 NVFP4 checkpoint is restored and tested with `1.0.0rc3`.
- llama.cpp RPC is built and wired into LLMCommune.
