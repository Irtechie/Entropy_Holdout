# Coder80Next GStack / ATV Harness Canary

Date: 2026-05-27

## Scope

This was a native-harness canary using Coder80Next through the Claude Code Anthropic-compatible endpoint:

- Endpoint: `http://192.168.1.203:8000`
- Model: `Qwen3-Coder-Next-Q4_K_M.gguf`
- Target identity: `entropy-qwen80nextcoder-256k`
- Workloads: `webpage-chain`, `library-chain`, `factory`
- External validators: `tools/validators/webpage_chain.ps1`, `tools/validators/library_chain.ps1`, `tools/validators/factory.ps1`

These runs are canaries, not final paper rows. The task shape used the existing EB final-artifact validators, while the native harnesses were driven through Claude Code skills.

## GStack

Run root:

`runs/harness-bakeoff/gstack-coder80next-wave1-report-only-20260527-112155`

Harness setup:

- GStack source commit: `a6fb31726cece1d1bba401fde593db7cb96bc738`
- Claude Code could use the local Coder80Next endpoint with `ANTHROPIC_BASE_URL=http://192.168.1.203:8000`.
- GStack had to be registered manually into `~/.claude/skills` because `./setup` requires `bun`, which was not installed.

### Wave 1 Report-Only

Classification: `invalid_incomplete`

Reason:

- The run reached Claude Code and generated artifacts.
- Claude Code stopped on the budget guard before completing the required evidence/review/QA loop.
- No `HARNESS_EVIDENCE.md` was produced in wave 1.

Independent validator state after wave 1:

| Workload | Result | Note |
|---|---|---|
| `webpage-chain` | pass | 5 pages checked |
| `library-chain` | fail | Projects were placed at workspace root instead of under `library-chain/` |
| `factory` | pass | Route `intake->assembly->quality->shipping` |

Wave 1 is useful diagnostic evidence but should not be scored as a completed GStack report-only run.

### Wave 2 Native Repair

Classification: `scoreable_gstack_repair_canary`

Commit in run workspace:

`975ebc7 gstack wave2 native repair canary`

Independent validator state after wave 2:

| Workload | Result | Evidence |
|---|---|---|
| `webpage-chain` | pass | `{"ok":true,"workload":"webpage-chain","pages_checked":5,...}` |
| `library-chain` | pass | `{"ok":true,"workload":"library-chain","sample_output":"core->feature->pipeline->contract",...}` |
| `factory` | pass | `{"ok":true,"workload":"factory","route":"intake->assembly->quality->shipping",...}` |

Judgment:

- GStack plus Coder80Next successfully repaired the concrete validator failure.
- The repair was minimal: move C# projects under `library-chain/`.
- The run committed generated build outputs (`bin/` and `obj/`) inside the isolated workspace; this does not affect the main repo but should be excluded from future benchmark commits.

## ATV

Run root:

`runs/harness-bakeoff/atv-coder80next-wave1-report-only-20260527-113726`

Harness setup:

- ATV source commit: `5a5f82456e872342b29bdad9f1b118f47d6ce125`
- ATV project-local `.claude/skills` did not load in this Claude Code invocation.
- ATV skills were registered manually into `~/.claude/skills` for the canary.
- `bd` was not installed.
- Subagent capability was unavailable in the non-interactive host.

### Wave 1 Report-Only

Classification: `scoreable_degraded_atv_canary`

Not full ATV because:

- `bd` was unavailable, so the run used `BACKLOG.md`.
- Subagents were unavailable, so the run continued as a single-agent degraded canary.

Commit in run workspace:

`3551839 atv wave1 report-only canary`

Independent validator state after wave 1:

| Workload | Result | Evidence |
|---|---|---|
| `webpage-chain` | pass | `{"ok":true,"workload":"webpage-chain","pages_checked":5,...}` |
| `library-chain` | pass | `{"ok":true,"workload":"library-chain","sample_output":"core->feature->pipeline->contract",...}` |
| `factory` | pass | `{"ok":true,"workload":"factory","route":"intake->assembly->quality->shipping",...}` |

Judgment:

- ATV degraded mode produced a clean implementation across all three validators on wave 1.
- The model self-reported "Scoreable full ATV"; that is incorrect. The valid classification is degraded ATV because native `bd` and subagent execution were absent.
- Unlike the GStack run, this workspace did not commit generated `bin/` / `obj/` outputs in the filtered stat view.

## Next Gate

Do not start broad model or harness expansion yet.

Recommended next step:

1. Install or make available `bd` for a full ATV run.
2. Decide whether native-harness canaries should use:
   - existing EB final-artifact workloads, as done here, or
   - the Community Aid Hub complex app from the harness bakeoff plan.
3. Rerun only the missing cells:
   - GStack wave 1 with a higher guard or smaller prompt, to get a completed report-only row.
   - ATV full mode with `bd` and subagents if the host can provide them.
   - ATV wave 2 only if wave 1 has a failure to repair, or as an explicit no-op repair verification lane.
