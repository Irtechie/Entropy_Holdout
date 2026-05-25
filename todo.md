# Todo

## Rules
- Keep this file current and small.
- Active, blocked, parked, and human-required work belongs here.
- Completed work does not stay here. Move compact completion summaries to `todo-done.md`.
- Handoffs live under `docs/handoffs/`; link them here instead of pasting full content.
- Refresh cold or parked work older than 72 hours before execution.
- These rules live at the top of `todo.md`; do not rely on a separate rules file.

## Objective

Build and run Entropy staged code-generation benchmark workloads to measure how far model/harness combinations move the break point to the right across model size, context length, and harness behavior.

## Current Focus

Wave 1 and Wave 2 direct-run data are archived as historical evidence. The next focus is a clean reproducible rerun with versioned EB skills and pass-through LangChain/Langfuse instrumentation.

## Current Truth

- Existing repo artifacts mostly prove LLMCommune activation/readiness for Entropy model targets.
- The next work is not another activation smoke pass.
- The desired benchmark workloads are staged code-generation tasks:
  - Webpage chain: pages progressively link backward and eventually share nested/shared structure.
  - Library/DLL chain: libraries progressively depend on earlier libraries.
  - Factory workload: generate the actual factory/system under increasing dependency pressure.
- The mock benchmark path now reports where runs break by target/model, context size, harness mode, and workload.
- Real model execution pattern is implemented via `tools/run_entropy_serial_experiment.ps1`.
- Historical direct-run EB folders were removed from active `main` and preserved at git tag `archive/pre-langchain-eb-evidence`.
- Canonical EB-LC run folders live under `runs/EB-LC/`.
- Each EB run folder keeps `run.json`, `events.jsonl`, `results.jsonl`, `critique.md`, `critique.json`, prompts, raw model responses, raw API response JSON, token usage, and generated files.
- The archived Wave 1 plain baseline showed the harness working and most model failures were benchmark-output failures, not LLMCommune wedges.

## Active Work

Prepare and run the clean EB-LC rerun harness:

- LangChain/Langfuse pass-through harness is staged in code.
- Canonical clean runs must use `runs/EB-LC/`.
- Preflight command: `pwsh .\tools\check_langchain_langfuse.ps1`.
- Current blocker: set `LANGFUSE_PUBLIC_KEY`, `LANGFUSE_SECRET_KEY`, and `LANGFUSE_HOST` in the shell before launching Wave 1.
- Wave 1 launch command after preflight passes:

```powershell
pwsh .\tools\run_eb_target_queue.ps1 -QueuePath .\benchmarks\entropy_workloads\wave1.langchain.targets.json -ExperimentPath .\benchmarks\entropy_workloads\experiment.langchain-wave1-plain-singlebox.json -ResultRootBase .\runs\EB-LC -CommitEach -PushEach -SkipCompleted
```

## Queued Improvements

- Compare Wave 2 against Wave 1 by target/workload using right-shift deltas.
- Add pass-through LangChain/Langfuse instrumentation without changing benchmark behavior.
- Package each wave harness so a third party can clone the repo, replace the model-serving backend or harness under test, and rerun the same wave.
- Add harness modes beyond `mock`/`plain`: likely `repair-extract`, `file-carry`, and `entropy`.
- Decide whether later large generated artifacts should be retained per real run or compacted after validation. Current EB default is retain.

## Handoff Queue

| Handoff | Status | Route | Created | Stale Check | Link |
|---|---|---|---|---|---|
| Entropy workload harness mock baseline | done | archive | 2026-05-24 | n/a | `docs/handoffs/done/2026-05-24-entropy-workload-harness.md` |

## Human Required

- Exact factory workload seed/spec was not found in this checkout. Generic factory seed was used for the mock baseline unless a later run provides the exact seed.

## Parked / Cold Storage

- Qwen235 128K activation remains experimental until it can pass readiness and a real completion.

## Work Log

- 2026-05-24: Bootstrapped KB memory and created first workload-harness manifest.
- 2026-05-24: Slice 001 done. `pwsh .\tools\entropy_workload_check.ps1` passed with 3 workloads and 13 stages.
- 2026-05-24: Slice 002 done. `pwsh .\tools\run_entropy_workload.ps1 -Workload webpage-chain -Mode mock` generated and validated 5 linked pages.
- 2026-05-24: Slice 003 done. `pwsh .\tools\run_entropy_workload.ps1 -Workload library-chain -Mode mock` built and ran a .NET chain with output `core->feature->pipeline->contract`.
- 2026-05-24: Slice 004 done with generic factory seed. `pwsh .\tools\run_entropy_workload.ps1 -Workload factory -Mode mock` validated route `intake->assembly->quality->shipping`.
- 2026-05-24: Slice 005 done. Default mock matrix passed: webpage 5/5, library 4/4, factory 4/4.
- 2026-05-25: First EB small serial experiment completed at `runs/EB/EB-local-small-20260525-012128/`. All 4 small targets failed under `plain` mode; best depth was Gemma E2B reaching webpage stage 4/5 and library stage 3/4 before strict artifact-path failures.
- 2026-05-25: Wave 2 repair-extract EB completed for all 19 single-box targets. Run folders use prefix `runs/EB/EB-wave2-repair-extract-*`.
- 2026-05-25: EB-LC LangChain/Langfuse harness added. Preflight is blocked until Langfuse env vars are set.
- 2026-05-25: Historical direct-run EB evidence and derived reports were archived at tag `archive/pre-langchain-eb-evidence` and removed from active `main` to keep the canonical branch clean.
