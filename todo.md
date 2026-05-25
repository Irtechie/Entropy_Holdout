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

Mock/local EB harness is complete. Serial real-model experiment pattern is in place. First conservative real small-model baseline has run and is saved under `runs/EB/EB-local-small-20260525-012128/`.

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
- The small baseline shows the harness is working and the smallest models break early under plain JSON/file-output prompting.

## Active Work

### EB Remaining Single-Box Runs (kb-2026-05-25-eb-remaining-singlebox-runs)

Source: `todo.md`
Manifest: `docs/plans/2026-05-25-000-kb-eb-remaining-singlebox-runs-manifest.md`

Wave 1 baseline rule: run `plain` EB per target, one folder per target, commit/push after each. Repair LLMCommune/model-serving issues when safe; do not repair generated model output inside Wave 1.

Overnight runner:

```powershell
pwsh .\tools\run_eb_target_queue.ps1 -QueuePath .\benchmarks\entropy_workloads\wave1.remaining.targets.json -CommitEach -PushEach -SkipCompleted
```

| # | Slice | Blocked By | Verification | Status |
|---|-------|------------|--------------|--------|
| 1 | entropy-gemma4-e4b | - | functional-cli | ✅ done |
| 2 | entropy-qwen35-4b | - | functional-cli | ✅ done |
| 3 | entropy-gptoss20 | - | functional-cli | ⬜ pending |
| 4 | entropy-devstral-small2 | - | functional-cli | ⬜ pending |
| 5 | entropy-nemotron-cascade-30b | - | functional-cli | ⬜ pending |
| 6 | entropy-gemma431 | - | functional-cli | ⬜ pending |
| 7 | entropy-qwen36 | - | functional-cli | ⬜ pending |
| 8 | entropy-qwen80next | - | functional-cli | ⬜ pending |
| 9 | entropy-qwen80nextcoder | - | functional-cli | ⬜ pending |
| 10 | entropy-qwen80nextcoder-256k | - | functional-cli | ⬜ pending |
| 11 | entropy-gptoss120 | - | functional-cli | ⬜ pending |
| 12 | entropy-nemotron120 | - | functional-cli | ⬜ pending |
| 13 | entropy-nemotron3-super-120b | - | functional-cli | ⬜ pending |
| 14 | entropy-qwen35-122b | - | functional-cli | ⬜ pending |
| 15 | entropy-minimax-m27 | - | functional-cli | ⬜ pending |

## Queued Improvements

- Improve or add the next harness mode after plain mode, likely `file-carry` or a stricter repair/extraction mode.
- Run the next tier after prompt/harness adjustment, probably starting at 4B+ instead of 0.5B.
- Add harness modes beyond `mock`: likely `plain`, `file-carry`, and `entropy`.
- Decide whether later large generated artifacts should be retained per real run or compacted after validation. Current EB default is retain.

## Handoff Queue

| Handoff | Status | Route | Created | Stale Check | Link |
|---|---|---|---|---|---|
| Entropy workload harness mock baseline | done | archive | 2026-05-24 | n/a | `docs/handoffs/done/2026-05-24-entropy-workload-harness.md` |

## Human Required

- Exact factory workload seed/spec was not found in this checkout. Generic factory seed was used for the mock baseline unless a later run provides the exact seed.

## Parked / Cold Storage

- Qwen235 128K activation remains experimental until it can pass readiness and a real completion.

## Blocked

- Broad single-box execution should wait until the small baseline failures are inspected and the next harness mode is defined.

## Work Log

- 2026-05-24: Bootstrapped KB memory and created first workload-harness manifest.
- 2026-05-24: Slice 001 done. `pwsh .\tools\entropy_workload_check.ps1` passed with 3 workloads and 13 stages.
- 2026-05-24: Slice 002 done. `pwsh .\tools\run_entropy_workload.ps1 -Workload webpage-chain -Mode mock` generated and validated 5 linked pages.
- 2026-05-24: Slice 003 done. `pwsh .\tools\run_entropy_workload.ps1 -Workload library-chain -Mode mock` built and ran a .NET chain with output `core->feature->pipeline->contract`.
- 2026-05-24: Slice 004 done with generic factory seed. `pwsh .\tools\run_entropy_workload.ps1 -Workload factory -Mode mock` validated route `intake->assembly->quality->shipping`.
- 2026-05-24: Slice 005 done. Default mock matrix passed: webpage 5/5, library 4/4, factory 4/4.
- 2026-05-25: First EB small serial experiment completed at `runs/EB/EB-local-small-20260525-012128/`. All 4 small targets failed under `plain` mode; best depth was Gemma E2B reaching webpage stage 4/5 and library stage 3/4 before strict artifact-path failures.
