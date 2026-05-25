#!/usr/bin/env python
"""Pass-through LangChain completion adapter for EB.

This script is intentionally narrow: it sends the exact prompt supplied by the
PowerShell harness to the same OpenAI-compatible endpoint and emits one JSON
object for the harness. LangChain/Langfuse are instrumentation here, not repair.
"""

from __future__ import annotations

import argparse
import json
import os
import sys
from pathlib import Path
from typing import Any


def fail(message: str, code: int = 1) -> None:
    print(message, file=sys.stderr)
    raise SystemExit(code)


def require_imports():
    try:
        from langchain_core.messages import HumanMessage, SystemMessage
        from langchain_openai import ChatOpenAI, OpenAI
        from langfuse import get_client
        from langfuse.langchain import CallbackHandler
    except Exception as exc:  # pragma: no cover - exercised by preflight
        fail(
            "missing LangChain/Langfuse dependencies; run "
            "`python -m pip install -r requirements-eb-langchain.txt`: "
            f"{exc}"
        )
    return ChatOpenAI, OpenAI, HumanMessage, SystemMessage, get_client, CallbackHandler


def normalize_base_url(base_url: str) -> str:
    base = base_url.rstrip("/")
    if base.endswith("/v1"):
        return base
    return f"{base}/v1"


def usage_from_message(message: Any) -> dict[str, int] | None:
    usage = getattr(message, "usage_metadata", None)
    if usage:
        return {
            "prompt_tokens": int(usage.get("input_tokens") or usage.get("prompt_tokens") or 0),
            "completion_tokens": int(usage.get("output_tokens") or usage.get("completion_tokens") or 0),
            "total_tokens": int(usage.get("total_tokens") or 0),
        }
    meta = getattr(message, "response_metadata", None) or {}
    token_usage = meta.get("token_usage") or meta.get("usage")
    if token_usage:
        return {
            "prompt_tokens": int(token_usage.get("prompt_tokens") or 0),
            "completion_tokens": int(token_usage.get("completion_tokens") or 0),
            "total_tokens": int(token_usage.get("total_tokens") or 0),
        }
    return None


def make_raw(kind: str, message: Any, trace_id: str | None, request: dict[str, Any]) -> dict[str, Any]:
    content = getattr(message, "content", message)
    return {
        "provider": "langchain",
        "kind": kind,
        "content": content,
        "response_metadata": getattr(message, "response_metadata", None),
        "usage_metadata": getattr(message, "usage_metadata", None),
        "langfuse": {
            "trace_id": trace_id,
            "host": os.environ.get("LANGFUSE_HOST"),
            "tags": request.get("tags") or [],
        },
    }


def env_ready(require_langfuse: bool) -> None:
    missing = [
        name
        for name in ("LANGFUSE_PUBLIC_KEY", "LANGFUSE_SECRET_KEY", "LANGFUSE_HOST")
        if not os.environ.get(name)
    ]
    if missing and require_langfuse:
        fail("missing required Langfuse environment variables: " + ", ".join(missing), 2)


def invoke(request: dict[str, Any]) -> dict[str, Any]:
    (
        ChatOpenAI,
        OpenAI,
        HumanMessage,
        SystemMessage,
        get_client,
        CallbackHandler,
    ) = require_imports()

    env_ready(bool(request.get("require_langfuse", True)))

    api_key = os.environ.get("OPENAI_API_KEY") or "not-needed"
    base_url = normalize_base_url(str(request["base_url"]))
    model = str(request["model"])
    max_tokens = int(request.get("max_tokens", 4096))
    temperature = float(request.get("temperature", 0))
    timeout_s = int(request.get("timeout_s", 600))
    metadata = request.get("metadata") or {}
    tags = request.get("tags") or []

    handler = CallbackHandler()
    config = {
        "callbacks": [handler],
        "metadata": {
            **metadata,
            "langfuse_session_id": request.get("session_id") or request.get("run_id"),
            "langfuse_tags": tags,
        },
        "tags": tags,
        "run_name": request.get("run_name") or "eb-langchain-completion",
    }

    try:
        chat = ChatOpenAI(
            model=model,
            base_url=base_url,
            api_key=api_key,
            temperature=temperature,
            max_tokens=max_tokens,
            timeout=timeout_s,
            max_retries=0,
        )
        message = chat.invoke(
            [
                SystemMessage(content=str(request["system"])),
                HumanMessage(content=str(request["prompt"])),
            ],
            config=config,
        )
        text = str(message.content)
        trace_id = getattr(handler, "last_trace_id", None)
        raw = make_raw("chat", message, trace_id, request)
    except Exception as chat_error:
        completion = OpenAI(
            model=model,
            base_url=base_url,
            api_key=api_key,
            temperature=temperature,
            max_tokens=max_tokens,
            timeout=timeout_s,
            max_retries=0,
        )
        message = completion.invoke(str(request["prompt"]), config=config)
        text = str(message)
        trace_id = getattr(handler, "last_trace_id", None)
        raw = make_raw("completion", message, trace_id, request)
        raw["chat_error"] = str(chat_error)

    usage = usage_from_message(message)
    get_client().flush()
    return {"text": text, "raw": raw, "usage": usage, "langfuse_trace_id": trace_id}


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--request", required=True)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()

    if args.check:
      require_imports()
      env_ready(True)
      print(json.dumps({"ok": True}))
      return 0

    request = json.loads(Path(args.request).read_text(encoding="utf-8"))
    response = invoke(request)
    print(json.dumps(response, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
