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

Wave 2 repair-extract EB is being prepared for the same single-box targets. Wave 1 plain baseline is complete under `runs/EB/`.

## Current Truth

- Existing repo artifacts mostly prove LLMCommune activation/readiness for Entropy model targets.
- The next work is not another activation smoke pass.
- The desired benchmark workloads are staged code-generation tasks:
  - Webpage chain: pages progressively link backward and eventually share nested/shared structure.
  - Library/DLL chain: libraries progressively depend on earlier libraries.
  - Factory workload: generate the actual factory/system under increasing dependency pressure.
- The mock benchmark path now reports where runs break by target/model, context size, harness mode, and workload.
- Real model execution pattern is implemented via `tools/run_entropy_serial_experiment.ps1`.
- EB run folders live under `runs/EB/`.
- Each EB run folder keeps `run.json`, `events.jsonl`, `results.jsonl`, `critique.md`, `critique.json`, prompts, raw model responses, raw API response JSON, token usage, and generated files.
- The Wave 1 plain baseline shows the harness is working and most model failures are benchmark-output failures, not LLMCommune wedges.

## Active Work

Run Wave 2 repair-extract EB queue after harness verification:

```powershell
pwsh .\tools\run_eb_target_queue.ps1 -QueuePath .\benchmarks\entropy_workloads\wave2.repair-extract.targets.json -ExperimentPath .\benchmarks\entropy_workloads\experiment.wave2-repair-extract-singlebox.json -CommitEach -PushEach -SkipCompleted
```

## Queued Improvements

- Compare Wave 2 against Wave 1 by target/workload using right-shift deltas.
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
