# Superpowers Invocation Card

Status: draft for external tire-kicking
Checked: 2026-05-27

## Source

- Repo: `https://github.com/obra/superpowers.git`
- Checked HEAD: `f2cbfbefebbfef77321e4c9abc9e949826bea9d7`
- Plugin version: `5.1.0` from `.codex-plugin/plugin.json`
- Local research checkout: `%TEMP%/entropy-harness-repos/superpowers`
- Primary files inspected: `README.md`, `CLAUDE.md`, `.codex-plugin/plugin.json`, `hooks/session-start`, `skills/using-superpowers/SKILL.md`, `skills/brainstorming/SKILL.md`, `skills/using-git-worktrees/SKILL.md`, `skills/writing-plans/SKILL.md`, `skills/subagent-driven-development/SKILL.md`, `skills/executing-plans/SKILL.md`, `skills/test-driven-development/SKILL.md`, `skills/requesting-code-review/SKILL.md`, `skills/finishing-a-development-branch/SKILL.md`, `skills/verification-before-completion/SKILL.md`, `skills/using-superpowers/references/codex-tools.md`

## Native Intent

Superpowers is a complete software-development methodology built from composable skills plus a bootstrap instruction that makes the agent check for relevant skills before acting.

Its README describes the basic workflow:

1. `brainstorming`
2. `using-git-worktrees`
3. `writing-plans`
4. `subagent-driven-development` or `executing-plans`
5. `test-driven-development`
6. `requesting-code-review`
7. `finishing-a-development-branch`

Important native constraints:

- `using-superpowers` is the session bootstrap. The benchmark must confirm it is loaded, or the skills are only files on disk.
- `brainstorming` is a hard gate before creative work or behavior changes. It requires design approval before implementation.
- `writing-plans` produces detailed, bite-sized implementation plans with exact files, code, commands, expected outputs, and TDD steps.
- `subagent-driven-development` is preferred when subagents exist. It dispatches a fresh implementer per task and runs two review passes after each task: spec compliance first, then code quality.
- `executing-plans` is the fallback when subagents are not available or the implementation is run in a separate/inline session.
- `test-driven-development` is mandatory for features, bug fixes, refactors, and behavior changes. Production code before a failing test is a native workflow violation.
- `verification-before-completion` requires fresh evidence before any completion claim.

## Install / Setup

Use the native install path for the target harness.

Claude Code official marketplace:

```text
/plugin install superpowers@claude-plugins-official
```

Claude Code Superpowers marketplace:

```text
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
```

Codex CLI:

```text
/plugins
```

Then search for `superpowers` and select `Install Plugin`.

Codex App:

1. Open Plugins in the Codex app sidebar.
2. Find `Superpowers` in the Coding section.
3. Click `+` and follow the prompts.

Factory Droid:

```bash
droid plugin marketplace add https://github.com/obra/superpowers
droid plugin install superpowers@superpowers
```

Gemini CLI:

```bash
gemini extensions install https://github.com/obra/superpowers
```

Record the installed source and commit. If installed from a cloned repository, record:

```bash
git -C <superpowers-install-path> rev-parse HEAD
```

## Bootstrap Readiness Gate

Before scoring a Superpowers run, prove the bootstrap is active.

Minimum evidence:

- The installed plugin exposes the Superpowers skills to the agent.
- `using-superpowers` is loaded at session start or the agent explicitly invokes it before any task response.
- A clean-session smoke test with the user message `Let's make a react todo list` causes `brainstorming` to trigger before code is written.

If `brainstorming` does not auto-trigger or get invoked before implementation, classify the run as `invalid_bootstrap`, not as a harness failure.

For Codex, the repo maps Claude's `Task` tool to Codex `spawn_agent`, `wait_agent`, and `close_agent`, and says multi-agent support requires:

```toml
[features]
multi_agent = true
```

If multi-agent support is not available, use the `executing-plans` fallback and record that variant.

## Scoreable Native Path

Use this path for the Community Aid Hub complex app.

1. Prepare a clean benchmark worktree and task packet.
2. Install Superpowers for the target agent host and record install path, install method, version, and commit/source.
3. Prove bootstrap readiness using the gate above.
4. Start the task with Superpowers active. The agent must check for skills before responding.
5. Invoke `brainstorming` before implementation:
   - Explore project context.
   - Ask clarifying questions one at a time.
   - Propose 2-3 approaches and tradeoffs.
   - Present the design in reviewable sections.
   - Get design approval.
   - Save the design spec to `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md` unless the benchmark overrides the path.
   - Run the spec self-review.
   - Obtain user/reviewer approval of the written spec.
6. Invoke `writing-plans`:
   - Produce `docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md` unless the benchmark overrides the path.
   - Include exact files, code, test commands, expected output, and bite-sized TDD steps.
   - Run its self-review for spec coverage, placeholders, and type consistency.
7. Invoke `using-git-worktrees` before execution:
   - Detect existing isolation first.
   - Prefer native harness worktree tools.
   - Fall back to git worktrees only when native tools are unavailable.
   - Run project setup and verify clean baseline tests.
8. Choose one execution lane and declare it:
   - `superpowers_subagent`: use `subagent-driven-development` when subagents are available.
   - `superpowers_inline`: use `executing-plans` when subagents are unavailable or the run intentionally uses inline execution.
9. During implementation, enforce `test-driven-development`:
   - Write failing test first.
   - Verify the red failure.
   - Implement minimal code.
   - Verify green.
   - Refactor only after green.
   - Commit at the task boundaries specified by the plan.
10. During `superpowers_subagent` execution:
   - Dispatch one implementer subagent per task.
   - Run spec-compliance review after each task.
   - Run code-quality review only after spec compliance passes.
   - Fix and re-review until approved.
   - Dispatch final code reviewer after all tasks.
11. During `superpowers_inline` execution:
   - Load and critically review the plan before coding.
   - Execute each plan step exactly.
   - Run verification steps as specified.
   - Stop and ask if blocked instead of guessing.
12. Run `requesting-code-review` at the required checkpoints:
   - After each subagent-driven task.
   - After the major feature.
   - Before merge/completion.
13. Run deterministic benchmark validators outside Superpowers.
14. Invoke `finishing-a-development-branch` only after all tests pass:
   - Verify tests freshly.
   - Detect environment.
   - Present completion options.
   - Do not merge, push, PR, discard, or clean up unless the benchmark lane explicitly allows that mutation.
15. Capture all design docs, plans, execution logs, test red/green evidence, review outputs, commits, final validator logs, and manual intervention notes.

## Required Evidence

- Harness repo URL, install method, installed version, source path, and checked commit when available.
- Bootstrap proof, including whether `using-superpowers` loaded at session start.
- Clean-session trigger smoke result for `Let's make a react todo list`.
- Full skill sequence, in order.
- Execution lane: `superpowers_subagent` or `superpowers_inline`.
- Design spec from `brainstorming`.
- Implementation plan from `writing-plans`.
- Worktree/isolation evidence and clean baseline test result.
- TDD evidence for each implemented behavior: red failure, green pass, and relevant commits.
- Subagent task logs and two-stage review outputs for the subagent lane.
- Inline execution checkpoints for the inline lane.
- Code-review findings and resolution notes.
- Deterministic benchmark validator logs.
- Fresh completion verification output.
- Manual intervention log, including human approvals, blocked points, environment fixes, skipped skills, or reruns.

## Wrong-Use Rejection

Mark the run `invalid_native_use` and do not score it if any of these happen:

- Superpowers is used as a generic prompt pack without the `using-superpowers` bootstrap.
- The clean-session smoke test does not trigger `brainstorming` before code is written.
- The agent starts implementation before `brainstorming` produces an approved design.
- The written design spec is skipped.
- `writing-plans` is skipped before multi-step implementation.
- The plan contains placeholders, vague steps, missing exact file paths, or no verification commands.
- Worktree/isolation setup is skipped before executing the plan unless the harness already provides an isolated workspace and that is recorded.
- Production code is written before a failing test for behavior changes.
- Red/green TDD evidence is missing.
- Subagent execution skips either spec-compliance review or code-quality review.
- Inline execution proceeds through blockers or failed verification without stopping.
- Required code review is skipped.
- Completion is claimed without fresh verification evidence.
- Human/manual fixes are applied and scored as model or harness output.
- The benchmark wrapper rewrites Superpowers into an Entropy Bench runner shape instead of following its native skill sequence.

## Variant Notes

- `superpowers_subagent` is the preferred native lane when the target harness supports subagents.
- `superpowers_inline` is a valid fallback, but should not be compared directly against subagent runs without labeling the lane.
- If the benchmark uses Codex without multi-agent support, record the missing `multi_agent` capability as an environment limitation.
- If the host environment owns worktrees, Superpowers should detect that and avoid fighting the harness.

## Opus Review Checklist

Ask the external reviewer to answer these before this card graduates from draft:

1. Does this sequence match Superpowers' documented native workflow?
2. Is the bootstrap smoke test sufficient, or should the benchmark require a transcript proving `using-superpowers` was loaded before any response?
3. Should the headline lane be `superpowers_subagent`, with `superpowers_inline` treated as a fallback, or should both be scored separately?
4. Is requiring full red/green TDD evidence for every implemented behavior practical for the benchmark workload?
5. Should `finishing-a-development-branch` be evidence-only, or should it be excluded to avoid merge/PR-oriented behavior?
6. Are any additional Superpowers skills required for a fair complex-app run, such as `verification-before-completion`, `systematic-debugging`, or `receiving-code-review`?
