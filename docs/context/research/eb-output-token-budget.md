# EB Output Token Budget

Checked: 2026-05-25
Budget mode: standard

## Question

What completion-token budget should canonical EB waves use so model failures are not contaminated by an artificially tiny output cap?

## Findings

- `4096` is too small to use as a fair final-wave cap for staged code-generation. It is only useful as a low sanity floor: anything below that, or any 32-token-style failed completion, is serving/config contamination.
- GPT-OSS is explicit: OpenAI's model docs list `gpt-oss-20b` with a 131,072-token context window and 131,072 max output tokens. The same public family guidance applies to GPT-OSS 120B, but hosted providers may impose lower limits.
- Qwen3-Coder-Next and Qwen3-Next public Unsloth docs emphasize 262,144-token native context. They do not establish a separate safe max-output value for the local GGUF serving path. For LLMCommune, the fair cap must therefore be proven by the backend.
- Devstral Small 2 public GGUF/model-card surfaces indicate very long context, including reports of 393,216-token context via YaRN. They do not prove a separate local max-output cap.
- In local LLMCommune profiles, most Entropy targets expose `CTX_SIZE` / `entropy_context_tokens`, not a separate `n_predict` or output cap. For llama.cpp lanes, the benchmark should use a large request cap and let prompt-adjusted served context determine the per-call effective cap.
- vLLM Qwen235 profiles expose `MAX_NUM_BATCHED_TOKENS=4096`; that is a batching/prefill throughput setting, not the same thing as max generated tokens. Do not confuse it with a fair output cap.
- Live LLMCommune probe on `entropy-qwen80nextcoder-256k` with `max_tokens=8192` succeeded: 117 prompt tokens, 8192 completion tokens, finish_reason `length`, 175.0 seconds. This proves the active Qwen Coder 256K path is not silently pinned to 4096.

## Current Policy

- Canonical EB configs must declare:
  - `max_completion_tokens`
  - `min_completion_tokens`
  - `min_completion_chars`
  - `context_reserve_tokens`
  - `min_context_tokens`
- Default final-wave cap is `32768` until live probes justify a higher per-target cap.
- The runner must use the smaller of configured `max_completion_tokens` and the prompt-adjusted remaining context. This prevents a high cap from turning late-stage prompts into artificial context-budget failures.
- Failed responses with length finish reasons, missing canonical token usage, or tiny completions are `serving_token_budget` / `infra_or_serving`, not model failures.

## Sources

- OpenAI model docs for `gpt-oss-20b`: https://platform.openai.com/docs/models/gpt-oss-20b
- OpenAI GPT-OSS model card: https://cdn.openai.com/pdf/419b6906-9da6-406c-a19d-1bb078ac7637/oai_gpt-oss_model_card.pdf
- Unsloth Qwen3-Coder-Next docs: https://unsloth.ai/docs/models/qwen3-coder-next
- Unsloth Qwen3-Next docs: https://docs.unsloth.ai/models/qwen3-next
- Hugging Face Devstral Small 2 FP8 search/card surface: https://huggingface.co/gdubicki/Devstral-Small-2-24B-Instruct-2512-FP8
- Local LLMCommune profile evidence: `E:/Dev/AI/remote/llmcommune/_remote_patch/models.json`.
- Live probe evidence: `runs/llmcommune_output_budget/qwen80nextcoder-256k-8k-probe.jsonl`.

## Applies When

- Freezing EB-LC canary, pilot, or final wave configs.
- Judging failures where a response is obviously truncated or has very low completion usage.
- Selecting model targets where context is high but output behavior has not been live-probed.

## Stale When

- LLMCommune launch scripts start declaring explicit output caps per profile.
- The final roster changes to a different backend, such as Unsloth Studio, Ollama, or vLLM for most targets.
- Live output-budget probes show that `32768` is either too high for reliability or too low for fair code-generation.

## Rejected Approaches

- Fixed `4096` cap for all models: too likely to truncate valid code-generation outputs.
- Full context as output cap for every model: can waste time and create prompt+max-token context errors on later stages.
- Model-card-only policy: insufficient for GGUF/llama.cpp because served backend limits and local launch settings determine what actually works.

## Impact On Current Project

- The Wave 0 canary now uses `max_completion_tokens=32768`.
- Output-budget failures are quarantined as serving contamination.
- `tools/probe_llm_output_budget.ps1` should be run on selected targets before expanding to a broad final wave.
