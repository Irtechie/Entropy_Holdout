# GStack Invocation Card

Status: draft for external tire-kicking
Checked: 2026-05-27

## Source

- Repo: `https://github.com/garrytan/gstack.git`
- Checked HEAD: `a6fb31726cece1d1bba401fde593db7cb96bc738`
- Local research checkout: `%TEMP%/entropy-harness-repos/gstack`
- Primary files inspected: `README.md`, `docs/skills.md`, `office-hours/SKILL.md`, `autoplan/SKILL.md`, `spec/SKILL.md`, `review/SKILL.md`, `qa/SKILL.md`, `ship/SKILL.md`

## Native Intent

GStack is a slash-command engineering workflow, not a prompt pack. It presents a virtual engineering team and its documented lifecycle is:

`Think -> Plan -> Build -> Review -> Test -> Ship -> Reflect`

For this benchmark, the important native behavior is:

- `/office-hours` produces the product/design framing before coding.
- `/autoplan` runs the plan review pipeline in strict order: CEO, design if UI exists, engineering, and DevEx if relevant.
- `/review` performs pre-landing code review and may auto-fix obvious issues.
- `/qa` tests the app, fixes discovered bugs, commits those fixes, and re-verifies.
- `/qa-only` uses the same QA methodology but reports without editing code.
- `/ship` is a release-readiness pipeline: sync base branch, run tests, audit coverage, review, version/changelog, commit/push/PR.
- `/spec` can turn intent into a backlog-ready issue and can optionally spawn execution with `--execute`; that is a separate path and must be declared if used.

## Install / Setup

Primary native Claude Code setup:

```bash
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/.claude/skills/gstack
cd ~/.claude/skills/gstack
./setup
```

Codex host setup from the repo:

```bash
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/gstack
cd ~/gstack
./setup --host codex
```

Team-mode setup is valid only if the benchmark intentionally tests a repo-embedded team workflow:

```bash
cd ~/.claude/skills/gstack
./setup --team
~/.claude/skills/gstack/bin/gstack-team-init required
git add .claude/ CLAUDE.md
git commit -m "require gstack for AI-assisted work"
```

Record the installed commit with:

```bash
git -C ~/.claude/skills/gstack rev-parse HEAD
```

or, for Codex host installs:

```bash
git -C ~/gstack rev-parse HEAD
```

## Scoreable Native Path

Use this path for the Community Aid Hub complex app unless a reviewer explicitly approves the `/spec` variant below.

1. Prepare a clean benchmark worktree and task packet.
2. Install GStack for the target agent host and record the install command, path, and commit.
3. Start with `/office-hours` using the benchmark task packet.
4. Run `/autoplan` against the `/office-hours` output and the task packet.
5. Let `/autoplan` complete its review sequence:
   - CEO review for strategy and scope.
   - Design review because Community Aid Hub has a UI.
   - Engineering review for architecture, data flow, edge cases, and tests.
   - DevEx review if the generated app exposes developer-facing setup, API, scripts, or docs.
6. Implement according to the reviewed plan. The implementer may use GStack context, but must not add non-GStack human fixes.
7. Run `/review` after implementation.
8. Run one QA mode and declare which scoring lane it belongs to:
   - `gstack_native_repair`: run `/qa`, allowing GStack's native bug-fix loop, commits, regression tests, and re-verification.
   - `gstack_report_only`: run `/qa-only`, preserving the implementation exactly as generated and scoring QA as evidence only.
9. Run deterministic benchmark validators outside GStack after `/review` and QA.
10. Run `/ship` only as release-readiness evidence. Do not allow merge, deploy, or production mutation in benchmark runs unless a separate release experiment explicitly asks for it.
11. Capture all plans, review output, QA output, test logs, commits, and manual intervention notes.

## Resource Policy

Do not put artificial token, completion, model-budget, or prompt-size caps inside the scoreable GStack lane.

GStack is a process harness. Its native value is in doing the full plan/review/QA/repair loop. A run stopped by `max_tokens`, `max_completion_tokens`, `max_budget_usd`, a short completion cap, or a deliberately shrunken prompt is not evidence that GStack failed. It is resource-contaminated.

Allowed controls:

- Record token usage, wall-clock time, tool calls, and total cost/proxy cost as evidence.
- Use a wall-clock runaway stop only as an operator safety abort, then classify the row as `operator_abort` or `resource_contaminated`, not as a model/harness failure.
- Use a smaller task only as a separately declared workload, not as a hidden way to make GStack fit a cap.

For GStack scoreable rows, the harness must be allowed enough context and completion room to finish `/office-hours`, `/autoplan`, implementation, `/review`, QA, and evidence capture.

## Optional `/spec` Variant

Use this only if the experiment is explicitly testing GStack's issue/spec workflow.

1. Run `/office-hours`.
2. Run `/spec` to produce the backlog-ready issue/spec.
3. If `--execute` is used, record it as an execution-spawning harness feature, not a plain prompt run.
4. Continue with `/autoplan`, implementation, `/review`, QA, validators, and `/ship` evidence.

Do not mix `/spec --execute` into the baseline GStack lane without marking the run variant. It changes the harness surface being tested.

## Required Evidence

- Harness repo URL, install path, install command, and checked commit.
- Full command sequence, in order.
- Whether the run used baseline path or `/spec` variant.
- `/office-hours` design/framing doc.
- `/autoplan` plan file, decision audit trail, and review scores.
- Generated implementation branch/worktree path.
- `/review` findings and any auto-fixes.
- `/qa` or `/qa-only` report, including browser target, health score, bugs found, fixes made, screenshots if generated, and re-test evidence.
- Deterministic benchmark validator logs.
- `/ship` readiness output, with merge/deploy/PR mutation disabled or clearly sandboxed.
- Commit log generated during the run.
- Manual intervention log, including any human decisions, reruns, environment fixes, or blocked commands.

## Wrong-Use Rejection

Mark the run `invalid_native_use` and do not score it if any of these happen:

- GStack is used as one generic instruction prompt instead of slash-command workflow.
- `/office-hours` is skipped for the complex app.
- `/autoplan` or equivalent explicit review sequence is skipped before implementation.
- Design review is skipped while scoring a UI app.
- Engineering review is skipped before implementation.
- `/review` is skipped after implementation.
- UI/browser claims are made without `/qa`, `/qa-only`, or another rendered-browser evidence path approved before the run.
- `/qa` native fixes are mixed into a report-only lane.
- `/spec --execute` is used but not declared as the `/spec` variant.
- Artificial token, completion, model-budget, or prompt-size caps stop the native workflow before review/QA/evidence completion.
- Human/manual fixes are applied and scored as model or harness output.
- The benchmark wrapper rewrites the intended GStack sequence to match Entropy Bench's internal runner.
- `/ship` is allowed to merge, deploy, or mutate a real production target during a benchmark run.

## Opus Review Checklist

Ask the external reviewer to answer these before this card graduates from draft:

1. Does this sequence match GStack's documented native workflow?
2. Should the headline GStack lane allow `/qa` native repairs, or should `/qa-only` be the default to isolate initial generation quality?
3. Is `/autoplan` sufficient as the planning gate, or should the card require explicit `/plan-ceo-review`, `/plan-design-review`, `/plan-eng-review`, and `/plan-devex-review` command invocations for auditability?
4. Is `/ship` appropriate as evidence-only, or should it be excluded because it is too release/PR-oriented for a benchmark harness?
5. Are there any GStack commands that should be included for a fair complex-app run, such as `/health`, `/design-review`, `/context-save`, or `/learn`?
