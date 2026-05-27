# Project Map

Bootstrap: 2026-05-24
Bootstrap confidence: mixed

## What This Is

Entropy holdout and planning repo for two related but distinct efforts:

- Existing LLMCommune model activation smoke artifacts for Entropy target sets.
- Staged code-generation benchmark work to measure how far Entropy/harnessing moves the model break point across model size, context, and harness mode.

## How To Run

Activation smoke runner:

```powershell
pwsh .\run-entropy-smoke.ps1
pwsh .\run-entropy-smoke.ps1 -OnlySet entropy-devstral-small2
pwsh .\run-entropy-smoke.ps1 -IncludeDualBox
```

Staged benchmark harness local/mock commands:

```powershell
pwsh .\tools\entropy_workload_check.ps1
pwsh .\tools\run_entropy_workload.ps1 -Workload webpage-chain -Mode mock
pwsh .\tools\run_entropy_workload.ps1 -Workload library-chain -Mode mock
pwsh .\tools\run_entropy_workload.ps1 -Workload factory -Mode mock
pwsh .\tools\run_entropy_matrix.ps1 -Matrix .\benchmarks\entropy_workloads\matrix.default.json
pwsh .\tools\report_entropy_results.ps1 -ResultsPath <results.jsonl>
```

Serial real-model experiment pattern:

```powershell
pwsh .\tools\run_entropy_serial_experiment.ps1 -ExperimentPath .\benchmarks\entropy_workloads\experiment.local-small.json
```

Canonical EB-LC queue pattern:

```powershell
pwsh .\tools\run_eb_target_queue.ps1 -QueuePath .\benchmarks\entropy_workloads\wave1.langchain.targets.json -ExperimentPath .\benchmarks\entropy_workloads\experiment.langchain-wave1-plain-singlebox.json -ResultRootBase .\runs\EB-LC -CommitEach -PushEach -SkipCompleted
pwsh .\tools\export_eb_langfuse_traces.ps1
```

## How To Test

Current deterministic checks are mostly artifact inspection:

```powershell
git status --short --branch
pwsh .\run-entropy-smoke.ps1 -OnlySet <set_id>
```

Current local benchmark verification:

```powershell
pwsh .\tools\entropy_workload_check.ps1
pwsh .\tools\run_entropy_matrix.ps1 -Matrix .\benchmarks\entropy_workloads\matrix.default.json -ResultPath .\runs\entropy_matrix\verification-results.jsonl
pwsh .\tools\report_entropy_results.ps1 -ResultsPath .\runs\entropy_matrix\verification-results.jsonl
```

## Current Architecture

This repo currently has no application source tree. It contains:

- `run-entropy-smoke.ps1`: PowerShell activation/readiness smoke runner.
- `llmcommune-entropy-targets.json`: model target manifest.
- `llmcommune-prd-queue-contexts.json`: PRD queue top-context handoff.
- `llmcommune-entropy-smoke-summary.md`: existing activation summary.
- `entropy-smoke-results-*.jsonl`: proof/result logs.
- `RESUME.md`: local restart summary.
- `ACTUAL_TEST_CODE.md`: notes on the current activation runner.
- `benchmarks/entropy_workloads/`: staged workload specs.
- `tools/run_entropy_workload.ps1`: local/mock workload runner.
- `tools/run_entropy_matrix.ps1`: matrix orchestrator.
- `tools/run_entropy_serial_experiment.ps1`: one-target-at-a-time real experiment runner.
- `tools/report_entropy_results.ps1`: break-point report summarizer.
- `tools/langchain_completion.py`: pass-through LangChain/Langfuse completion adapter for EB-LC.
- `tools/export_eb_langfuse_traces.ps1`: exports Langfuse trace payloads into completed EB-LC run folders.
- `tools/validators/`: workload validators.

## Subsystem Index

| Area | Read This | Use When | Confidence |
|---|---|---|---|
| Activation smoke runner | `docs/context/operations/testing.md` | Checking existing model readiness proof | verified |
| Workload benchmark plan | `docs/context/architecture/entropy-workloads.md` | Building the staged generation harness | mixed |
| EB-LC LangChain/Langfuse harness | `docs/operations/langchain-langfuse-eb.md` | Running/exporting canonical EB-LC evidence | verified |
| Final EB test waves | `docs/context/epics/final-eb-test-waves.md` | Freezing the final benchmark protocol and wave gates | active |
| Harness bakeoff charity app | `docs/context/epics/harness-bakeoff-charity-app.md` | Comparing native agent workflow harnesses on useful app tasks | draft |
| Benchmark wave design research | `docs/context/research/benchmark-wave-design.md` | Explaining why gates/quarantine beat repeated full reruns | active |
| Existing target state | `llmcommune-entropy-smoke-summary.md` | Choosing model/context targets | verified |

## Current Work Pointers

- Board: `todo.md`
- Completed mock harness manifest: `docs/plans/2026-05-24-000-kb-entropy-workload-harness-manifest.md`
- Completed handoff archive: `docs/handoffs/done/2026-05-24-entropy-workload-harness.md`
- Current canonical data: completed EB-LC Wave 1 run folders under `runs/EB-LC/`, with Langfuse exports under each run's `langfuse/` folder.
- Active epic: `docs/context/epics/final-eb-test-waves.md`
- Harness bakeoff plan: `docs/context/epics/harness-bakeoff-charity-app.md`
- Active manifest: `docs/plans/2026-05-25-000-kb-final-eb-test-waves-manifest.md`
- Wave 0 model-repair canary judgment: `docs/reports/2026-05-25-eb-lc-wave0-model-repair-canary-judgment.md`
- Close-failure audit: `docs/reports/2026-05-25-eb-lc-close-failure-audit.md`
- Local coding model roster research: `docs/context/research/local-coding-model-roster.md`
- Corrected Qwen Coder rerun: `runs/EB-LC/EB-LC-wave0-model-repair-rerun2-entropy-qwen80nextcoder-256k-20260525-173146/`
- Next work: freeze a curated final roster and decide whether to add an Unsloth Studio / GLM/Qwen3.6 backend lane before pilot expansion.

## Known Sharp Edges

- Do not confuse activation smoke tests with the staged code-generation benchmark.
- Qwen235 is not currently eligible for final EB waves. Ray/vLLM 64K eager passed a short chat smoke on 2026-05-26 but failed a 4096-token output-budget probe with CUBLAS/EngineDead and dropped the lane; TRT 2507 NVFP4 failed API readiness under rc5 and rc13. See `docs/context/research/qwen235-trt-gguf-dual-box.md`.
- Qwen235 128K is not smoke-proven.
- The factory workload seed/spec may be missing from this checkout.
- `run_entropy_serial_experiment.ps1` can activate Entropy targets and run workloads in `api` mode one by one.
- `run_eb_target_queue.ps1` can run target queues one at a time, commit each completed target folder, and push after each commit.
- MiniMax EB-LC has two Wave 1 folders. Prefer `runs/EB-LC/EB-LC-wave1-plain-entropy-minimax-m27-20260525-153529/` for analysis because it was rerun after fixing Windows console JSON escaping in `tools/langchain_completion.py`.
- A full Wave 2/final queue is blocked until `docs/context/epics/final-eb-test-waves.md` Gate A passes and the Wave 0 canary spec is approved.
- `library-chain` currently has a known contract mismatch: `workloads.json` expected artifacts use lowercase folders while `library_chain.json` and the validator require exact .NET project paths such as `CoreLib/CoreLib.csproj`.
- Current `repair-extract` is model-assisted repair in `tools/run_entropy_workload.ps1`, not deterministic extraction.
- Four EB-LC Wave 1 factory rows hit a null-method harness failure at `factory-002-stations`; do not score those rows as model failures until diagnosed or quarantined.

## Research Index

- `docs/context/research/README.md`
- `docs/context/research/benchmark-wave-design.md`

## Do Not Repeat

- Do not document only the activation smoke harness when the user is asking about generated workload code.
- Do not route from global memories when this repo has local KB memory.

## Maintenance Notes

Keep `todo.md` pointed at active work only. Move completed work summaries to `todo-done.md`.
