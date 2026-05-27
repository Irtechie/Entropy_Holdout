# Working Skill Repo KB Invocation Card

Status: draft for external tire-kicking
Checked: 2026-05-27

## Source

- Repo: `https://github.com/Irtechie/working-skill-repo.git`
- Checked HEAD: `f1b11a78e7ed2fedbc054d2232deee43eed2a749`
- Local research checkout: `%TEMP%/entropy-harness-repos/working-skill-repo`
- Primary files inspected: `README.md`, `AGENTS.md`, `.github/copilot-instructions.md`, `.github/skills/kb-start/SKILL.md`, `.github/skills/kb-map/SKILL.md`, `.github/skills/kb-brainstorm/SKILL.md`, `.github/skills/kb-plan/SKILL.md`, `.github/skills/kb-work/SKILL.md`, `.github/skills/kb-complete/SKILL.md`, `.github/skills/kb-check/SKILL.md`, `.github/skills/kb-functional-test/SKILL.md`, `.github/skills/kb-qa/SKILL.md`, `.github/skills/kb-gate/SKILL.md`, `.github/skills/kb-epic/SKILL.md`, `.github/skills/klfg/SKILL.md`

## Native Intent

Working Skill Repo is a voice-friendly KB workflow bundle for GitHub Copilot and Codex. The README describes it as an augmentation layer on top of ATV StarterKit and the CE review/learning workflow, not as a standalone app scaffold.

Its native behavior is:

- Start ambiguous or fresh-session work through `kb-start`.
- Resolve the active project root and local memory through `kb-map` before routing.
- Use repo-local durable memory: `todo.md`, `todo-done.md`, `docs/context/PROJECT.md`, `docs/context/**`, and `docs/handoffs/**`.
- Pick the right lane without making the user choose ceremony.
- Convert product intent into requirements through `kb-brainstorm`.
- Convert requirements into vertical-slice manifests through `kb-plan`.
- Execute ready slices continuously through `kb-work`.
- Enforce scope locks, expected files, HITL classification, deterministic checks, functional proof, QA, repair, and regression snapshots during work.
- Finish through `kb-complete`, including `ce-review`, follow-up resolution, proof/demo evidence, learning, memory refresh, cleanup, and reviewed status.

`klfg` is the full-pipeline orchestrator. It chains `kb-brainstorm -> kb-plan -> kb-work -> kb-complete` and is valid when the benchmark wants a single native full-flow command. It is still expected to produce the same phase artifacts and obey the same gates.

`kb-epic` is for work bigger than one brainstorm or one manifest. Use it only if the task has multiple workstreams, app migrations, major architecture rewrites, or a dark-factory queue.

## Install / Setup

Install or copy the repository's workflow bundle into the benchmark worktree:

```bash
git clone https://github.com/Irtechie/working-skill-repo.git /tmp/working-skill-repo
cp -r /tmp/working-skill-repo/.github/skills .github/
cp -r /tmp/working-skill-repo/.github/agents .github/
cp /tmp/working-skill-repo/.github/copilot-instructions.md .github/copilot-instructions.md
cp /tmp/working-skill-repo/AGENTS.md AGENTS.md
```

Record the installed source and commit:

```bash
git -C <working-skill-repo-install-path> rev-parse HEAD
```

For a faithful run, the target host must expose skills and reviewer agents or an equivalent mechanism. If reviewer agents, browser automation, or deterministic command execution are unavailable, mark the lane as degraded and record the missing capability.

Before scoring implementation work, verify that project memory exists or allow `kb-map-bootstrap` to create it:

- `todo.md`
- `todo-done.md`
- `docs/context/PROJECT.md`
- `docs/context/architecture/`
- `docs/context/research/`
- `docs/context/decisions/`
- `docs/context/operations/`
- `docs/handoffs/active/`
- `docs/handoffs/parked/`
- `docs/handoffs/done/`

Do not seed memory from sibling repos, home directories, old chat logs, or prior benchmark runs unless the task packet explicitly makes them part of the input.

## Scoreable Native Path

Use this path for the Community Aid Hub complex app.

1. Prepare a clean benchmark worktree and task packet.
2. Install the Working Skill Repo bundle and record install method, selected files, host platform, available agents, available browser/test transports, and source commit.
3. Start with:

```text
kb-start <Community Aid Hub task packet>
```

4. Require the startup preflight:
   - `kb-start` must invoke `kb-map lookup <request>` before routing.
   - `kb-map` must resolve the active project root first.
   - `kb-map` must read memory from that repo only.
   - If `todo.md` or `docs/context/PROJECT.md` is missing, `kb-map-bootstrap` creates or refreshes the standard structure.
5. Record the route selected by `kb-start`:
   - Baseline complex-app lane: `kb-brainstorm -> kb-plan -> kb-work -> kb-complete`.
   - Full-pipeline variant: `klfg`, which must still produce requirements, manifest, slice plans, work evidence, and completion artifacts.
   - Epic variant: `kb-epic` only if the app is split into multiple manifests or workstreams.
6. Run `kb-brainstorm` for requirements:
   - Read minimum local context before asking product questions.
   - Use external research only when it can change framing, reduce rework, or resolve material uncertainty.
   - Ask one question at a time when needed.
   - Produce a requirements doc suitable for `kb-plan`.
   - Apply `kb-gate` before moving to planning when unresolved P0/P1 ambiguity exists.
7. Run `kb-plan`:
   - Produce a manifest under `docs/plans/YYYY-MM-DD-000-kb-<name>-manifest.md`.
   - Produce one plan per vertical slice.
   - Each slice must include acceptance criteria, dependencies, expected files, verification strategy, `test_level`, `functional_risk`, HITL classification, and blockers.
   - Update `todo.md` and active handoff when the work may resume in a later session.
8. Run `kb-work` on the manifest:
   - Validate DAG, slice status, contracts, and `todo.md` sync.
   - Execute runnable slices in dependency order without per-slice confirmation.
   - Pause only for HITL decisions, destructive approval, blocked work with no unrelated runnable slice, scope violation, QA/repair exhaustion, dependency deadlock, or explicit user stop.
   - Enforce scope lock against `expected_files`.
   - Run `kb-functional-test` classification before marking a slice done.
   - Run deterministic checks through `kb-check`.
   - For UI-reachable behavior, require rendered UI proof through Playwright, CDP, agent-browser, or the repo's browser transport.
   - Run `kb-qa`; failures invoke `kb-repair` before the next slice.
   - Capture regression snapshots after passing slices when relevant.
   - Update manifest, `todo.md`, and memory-impact notes.
9. Run `kb-complete` after all runnable slices are done or explicitly skipped:
   - Preflight final manifest status and snapshot sweep.
   - Run `kb-check` and functional smoke coverage as needed.
   - Run mandatory `ce-review`.
   - Resolve P0/P1 findings before completion.
   - Resolve or log follow-ups according to the gate policy.
   - Produce executable proof/demo evidence; prose-only proof is not sufficient.
   - Run compound, learn, evolve, memory refresh, maintenance signal update, compact, and cleanup as applicable.
   - Mark the final status `reviewed`.
10. Run deterministic benchmark validators outside the KB workflow.
11. Capture all phase artifacts, logs, tests, review output, memory changes, and manual interventions.

## Required Evidence

- Harness repo URL, install method, installed files, source path, and checked commit.
- Target host capabilities: skills, agents, shell, git, browser transport, Playwright/CDP/agent-browser availability.
- `kb-start` route decision and proof that `kb-map lookup` ran first.
- Resolved project root and proof that memory was read only from that root.
- Created or existing memory files: `todo.md`, `docs/context/PROJECT.md`, and handoff directories.
- Requirements document from `kb-brainstorm`, including questions asked, answers, unresolved HITL, and research notes if used.
- `kb-gate` decisions for phase transitions when findings or ambiguity exist.
- `kb-plan` manifest and slice plans.
- Per-slice acceptance criteria, expected files, dependencies, verification strategy, `test_level`, `functional_risk`, HITL status, and blockers.
- `kb-work` slice execution logs, scope-lock/diff-scope evidence, and manifest status updates.
- `kb-functional-test` classification evidence and any test-quality audit notes.
- `kb-check` command logs with command, exit code, timestamp, and artifact path.
- UI functional proof for UI-reachable behavior: browser assertion file or test path, exit code, screenshots, and trace/log paths.
- `kb-qa` reports, `kb-repair` attempts if any, and final pass/fail state.
- Regression snapshot evidence when used.
- `kb-complete` output: `ce-review` findings, resolution notes, proof/demo evidence, learning/compound/evolve notes, memory refresh, maintenance signals, cleanup.
- Deterministic benchmark validator logs.
- Manual intervention log, including user answers, approvals, environment fixes, skipped gates, reruns, or human-written code.

## Wrong-Use Rejection

Mark the run `invalid_native_use` and do not score it if any of these happen:

- Work starts directly in planning or coding without `kb-start` or an explicitly declared `klfg` full-pipeline run.
- `kb-map lookup` is skipped on fresh or ambiguous startup.
- The run reads project memory from the wrong repo, sibling folders, home directories, or stale prior runs.
- Missing `todo.md` or `docs/context/PROJECT.md` is ignored instead of bootstrapped or recorded as blocked.
- A complex app proceeds to implementation without a requirements doc.
- `kb-plan` is skipped and no manifest/slice plans are created.
- Slice plans lack expected files, verification strategy, functional classification, or HITL status.
- `kb-work` asks for confirmation before every normal runnable slice instead of continuing through the DAG.
- Implementation edits files outside `expected_files` without scope-gate handling.
- UI-reachable behavior is verified only with unit/API checks, screenshots, source inspection, or model judgment.
- `kb-check` command logs are missing or replaced by prose.
- `kb-qa` or `kb-repair` is skipped after a failing lint/browser/functional check.
- `kb-complete` is skipped but the run claims final reviewed status.
- `ce-review` is skipped during completion.
- P0/P1 findings are carried forward unresolved without a recorded gate decision.
- Prose-only "looks good" evidence is used instead of executable proof/demo evidence.
- Reviewer agents or browser transports are unavailable but the run is scored as a full native KB run without degradation notes.
- Manual fixes are applied and scored as model or harness output.

## Variant Notes

- `kb_standard` is the preferred baseline: `kb-start -> kb-brainstorm -> kb-plan -> kb-work -> kb-complete`.
- `kb_klfg` is the native full-pipeline variant: invoke `klfg` and verify it produces the same artifacts and gates.
- `kb_epic` is valid only when Community Aid Hub is intentionally split into multiple workstreams/manifests or a dark-factory queue.
- `kb_fix` is not valid for the initial Community Aid Hub build; it is for narrow bug-fix follow-up runs.
- `kb_degraded_no_agents` may be recorded when reviewer/subagent capabilities are missing, but it should not be compared as a full harness run.

## Opus Review Checklist

Ask the external reviewer to answer these before this card graduates from draft:

1. Is `kb_standard` the fairest baseline for Community Aid Hub, or should the headline lane be `kb_klfg`?
2. Does Community Aid Hub require `kb-epic`, or is it one complex manifest?
3. Are reviewer agents mandatory for a valid native KB run, or can a documented degraded run still be scored separately?
4. Are the required memory artifacts sufficient to prevent stale-session contamination?
5. Does the wrong-use checklist catch the common false passes: skipped map, skipped manifest, weak UI proof, skipped review, and prose-only completion?
6. Should `kb-complete` learning steps be required in benchmark runs, or recorded but excluded from entropy scoring?
7. What is the minimum evidence needed to prove `kb-work` actually enforced `expected_files` and did not drift?
8. How should this card distinguish KB's ATV-derived pieces from the upstream ATV Skills Catalog lane without double-counting the same harness behavior?
