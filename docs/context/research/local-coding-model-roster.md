# Local Coding Model Roster

Checked: 2026-05-25
Budget mode: standard

## Question

Which local models should be considered for the final Entropy Benchmark roster, given the Wave 0 evidence and newer Unsloth/local coding model availability?

## Findings

1. Do not spend final-wave slots on implausible coding agents. The 0.5B class can remain a curiosity/lower-bound smoke point, but it should not be in headline coding-agent claims.

2. Keep a small-but-real lower bound. Gemma 4 E4B and Qwen 4B-class models are small enough to test the lower edge while still being plausible coding models.

3. Keep `entropy-qwen80nextcoder-256k`. After harness/validator fixes, it passed `library-chain` and `factory` under `model-repair`, leaving only a webpage shared-nav miss.

4. Add or test newer Unsloth-served coding candidates before freezing the final 12:
   - Qwen3-Coder-Next: Unsloth describes it as an 80B MoE with 3B active parameters, 256K context, and a focus on agentic coding / recovery from execution failures.
   - GLM-4.7-Flash: Unsloth describes it as a 30B MoE with about 3.6B active parameters, 200K context, and strong coding/agentic benchmark results.
   - Qwen3.6-27B / Qwen3.6-35B-A3B: Hugging Face pages exist under `unsloth/`, with llama.cpp, vLLM, SGLang, Ollama, and Unsloth Studio usage paths.
   - Gemma 4: useful for lower-bound and mid-size coverage, with E2B/E4B/26B-A4B/31B variants and long context.

5. Treat Unsloth Studio as a separate backend lane, not a silent replacement. Its docs advertise GGUF/safetensors serving, tool-calling, web search, and OpenAI-compatible API support. That may improve agentic coding behavior, but final claims should distinguish `LLMCommune llama.cpp` from `Unsloth Studio`.

## Sources

- Unsloth Qwen3-Coder-Next docs: https://unsloth.ai/docs/models/qwen3-coder-next
- Unsloth GLM-4.7-Flash docs: https://unsloth.ai/docs/models/glm-4.7-flash
- Unsloth Gemma 4 docs: https://unsloth.ai/docs/models/gemma-4
- Unsloth Dynamic 2.0 GGUFs: https://unsloth.ai/docs/basics/unsloth-dynamic-2.0-ggufs
- Unsloth model catalog: https://unsloth.ai/docs/get-started/unsloth-model-catalog
- Hugging Face `unsloth/Qwen3.6-27B-GGUF`: https://huggingface.co/unsloth/Qwen3.6-27B-GGUF
- Hugging Face `unsloth/Qwen3.6-35B-A3B-GGUF`: https://huggingface.co/unsloth/Qwen3.6-35B-A3B-GGUF
- Hugging Face `unsloth/GLM-4.7-Flash-GGUF`: https://huggingface.co/unsloth/GLM-4.7-Flash-GGUF

## Applies When

- Selecting final EB targets.
- Deciding whether to add a new model-serving backend.
- Deciding whether a small model belongs in the headline benchmark or only in lower-bound analysis.

## Stale When

- LLMCommune target manifests are updated with new Unsloth/DeepSeek/GLM/Qwen models.
- Unsloth changes recommended quants or serving settings.
- A final canary shows a proposed model/backend is unstable in this harness.

## Rejected Approaches

- Keeping every currently configured model just because it exists.
- Dropping `entropy-qwen80nextcoder-256k` based on the contaminated first canary result.
- Mixing Unsloth Studio and current LLMCommune llama.cpp runs in one headline score without labeling the backend.

## Impact On Current Project

Recommended final target strategy:

- Keep 1-2 lower-bound models:
  - `entropy-gemma4-e4b`
  - `entropy-qwen35-4b` or `entropy-gemma4-e2b`
- Keep current proven/near-proven medium models:
  - `entropy-devstral-small2`
  - `entropy-gptoss20`
  - `entropy-gemma431`
  - `entropy-qwen36`
  - `entropy-nemotron-cascade-30b`
- Keep strong/large local candidates:
  - `entropy-qwen80nextcoder-256k`
  - `entropy-qwen35-122b`
  - `entropy-gptoss120`
  - `entropy-nemotron3-super-120b` or `entropy-qwen235-2507-128k` if GX10 is available
- Consider adding before final freeze:
  - `unsloth/GLM-4.7-Flash-GGUF`
  - `unsloth/Qwen3.6-27B-GGUF`
  - `unsloth/Qwen3.6-35B-A3B-GGUF`
  - a DeepSeek Dynamic GGUF only if it can be served reliably in the same evidence pipeline
