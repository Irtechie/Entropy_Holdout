# LangChain/Langfuse EB Harness

This is the canonical public harness path for clean EB reruns.

## Install

```powershell
python -m pip install -r requirements-eb-langchain.txt
```

## Configure

Copy `.env.example` values into your shell or secret manager. Do not commit real keys.

Required:

```powershell
$env:LANGFUSE_PUBLIC_KEY = "<public-key>"
$env:LANGFUSE_SECRET_KEY = "<secret-key>"
$env:LANGFUSE_HOST = "http://<langfuse-host>:<port>"
$env:OPENAI_API_KEY = "not-needed-for-local-openai-compatible-backends"
```

On the DGX-hosted shared Langfuse instance, the host is currently `http://192.168.1.203:3100`.

The EB PowerShell scripts load a repo-local `.env` automatically if it exists. Keep real keys in `.env`; it is ignored by Git.

## Preflight

```powershell
pwsh .\tools\check_langchain_langfuse.ps1
```

Do not run canonical `EB-LC` waves until this passes. A LangChain wave without Langfuse traces is not a complete canonical datapoint.

## Behavior Contract

LangChain is pass-through workflow structure only:

- same generated prompt text
- same OpenAI-compatible endpoint
- same model/options
- same chat-then-completion fallback shape as the direct runner
- no hidden prompt template
- no memory
- no tools
- no output parser/fixer
- no retry/fallback policy beyond the explicit chat-to-completion fallback

Langfuse captures traces, timing, token usage, prompt/response evidence, and trace IDs. It does not decide pass/fail.

## Canonical Run Roots

Use `runs/EB-LC/` for clean LangChain/Langfuse evidence. Historical `runs/EB/` data is diagnostic background, not canonical paper evidence.
