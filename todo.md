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

Curate the final EB model roster and pilot gate after repairing close Wave 0 canary false negatives. Wave 1 EB-LC has completed as the clean reproducible LangChain/Langfuse baseline. Wave 1 and Wave 2 direct-run data are archived as historical evidence, not canonical paper evidence.

Active epic: `docs/context/epics/final-eb-test-waves.md`
Active manifest: `docs/plans/2026-05-25-000-kb-final-eb-test-waves-manifest.md`

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
- Queue logs under `runs/EB-LC/_queue-logs/` are local process logs and should not be committed.
- Each EB run folder keeps `run.json`, `events.jsonl`, `results.jsonl`, `critique.md`, `critique.json`, prompts, raw model responses, raw API response JSON, token usage, and generated files.
- EB-LC Langfuse exports live under each run folder at `langfuse/` and were exported with zero trace-export errors for the completed Wave 1 folders.
- `entropy-minimax-m27` has two EB-LC Wave 1 folders. Treat `runs/EB-LC/EB-LC-wave1-plain-entropy-minimax-m27-20260525-153529/` as the cleaner rerun after fixing Windows console JSON escaping in `tools/langchain_completion.py`; keep the earlier `20260525-152457` folder as contamination evidence.
- EB-LC Wave 1 outcome judgment is documented at `docs/reports/2026-05-25-eb-lc-wave1-outcome-judgment.md`.
- The archived Wave 1 plain baseline showed the harness working and most model failures were benchmark-output failures, not LLMCommune wedges.

## Active Work

Finalize and gate the completed clean EB-LC rerun harness:

- LangChain/Langfuse pass-through harness is staged in code.
- Canonical clean runs must use `runs/EB-LC/`.
- Preflight command: `pwsh .\tools\check_langchain_langfuse.ps1`.
- Langfuse is configured against the DGX-hosted instance and preflight passes locally.
- Langfuse traces for completed EB-LC runs are exported with `pwsh .\tools\export_eb_langfuse_traces.ps1`.
- Do not launch a full Wave 2/final queue until the protocol-freeze manifest reaches the Wave 0 canary slice.
- Wave 0 model-repair canary completed for `entropy-gptoss20`, `entropy-devstral-small2`, and `entropy-qwen80nextcoder-256k`.
- Wave 0 judgment: `docs/reports/2026-05-25-eb-lc-wave0-model-repair-canary-judgment.md`
- Close-failure audit: `docs/reports/2026-05-25-eb-lc-close-failure-audit.md`
- Corrected Qwen Coder rerun: `runs/EB-LC/EB-LC-wave0-model-repair-rerun2-entropy-qwen80nextcoder-256k-20260525-173146/`
- Under the corrected harness/validators, Qwen Coder passes `library-chain` and `factory`; webpage still fails final validation on shared navigation.
- Next decision: freeze a curated final roster around plausible coding agents plus 1-2 lower-bound small models.
- Previous full queue command is retained for provenance only, not as the next action:

```powershell
pwsh .\tools\run_eb_target_queue.ps1 -QueuePath .\benchmarks\entropy_workloads\wave1.langchain.targets.json -ExperimentPath .\benchmarks\entropy_workloads\experiment.langchain-wave1-plain-singlebox.json -ResultRootBase .\runs\EB-LC -CommitEach -PushEach -SkipCompleted
```

## Queued Improvements

- Resolve the protocol-freeze blockers before any all-target wave:
  - align `library-chain` expected artifacts with exact validator/spec paths,
  - reproduce/fix or quarantine the factory null-method harness failure,
  - adjudicate current `repair-extract` as model-assisted repair or implement deterministic extraction,
  - add/verify local golden gate checks.
- Compare Wave 2 against Wave 1 by target/workload using right-shift deltas only after the protocol is frozen.
- Package each frozen wave harness so a third party can clone the repo, replace the model-serving backend or harness under test, and rerun the same wave.
- Add harness modes beyond `mock`/`plain` only when their mechanics are frozen and named precisely.
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
- 2026-05-25: EB-LC LangChain/Langfuse harness added. DGX Langfuse keys are loaded from ignored `.env`; `pwsh .\tools\check_langchain_langfuse.ps1` passes.
- 2026-05-25: Historical direct-run EB evidence and derived reports were archived at tag `archive/pre-langchain-eb-evidence` and removed from active `main` to keep the canonical branch clean.
- 2026-05-25: Wave 1 EB-LC queue launched with per-target commit/push enabled. Cleanup of old root smoke outputs is ready but should not be staged while the queue is still committing target runs.
- 2026-05-25: Added EB Langfuse export path to the wave runner skill and exported trace payloads for all completed EB-LC run folders available at the time.
- 2026-05-25: Wave 1 EB-LC queue completed and pushed through `entropy-minimax-m27`. `entropy-qwen35-122b` passed webpage-chain 5/5 and failed library/factory on non-JSON output.
- 2026-05-25: Fixed `tools/langchain_completion.py` to ASCII-escape adapter JSON on Windows, reran `entropy-minimax-m27`, and pushed the cleaner rerun. MiniMax passed webpage stages 1-4, then failed stage 5 on 16K context overflow; library/factory failed on malformed JSON.
- 2026-05-25: Exported Langfuse traces for 20 EB-LC run folders with zero export errors and committed the export script plus `langfuse/` payloads.
- 2026-05-25: Judged EB-LC Wave 1 outcomes. Plain EB-LC is usable signal for webpage-chain, but library-chain and factory mostly measure output-contract or harness failure under plain mode.
