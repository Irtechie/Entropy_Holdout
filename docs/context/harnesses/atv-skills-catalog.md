# ATV Skills Catalog Invocation Card

Status: draft for external tire-kicking
Checked: 2026-05-27

## Source

- Repo: `https://github.com/All-The-Vibes/skills-catalog.git`
- Checked HEAD: `5a5f82456e872342b29bdad9f1b118f47d6ce125`
- Local research checkout: `%TEMP%/entropy-harness-repos/atv-skills-catalog`
- Primary files inspected: `README.md`, `AGENT_START.md`, `AGENTS.md`, `SKILL_SELECTOR.md`, `INSTALLATION_GUIDE.md`, `VERIFICATION_CHECKLIST.md`, `.claude/skills/core/technical-lead-role/SKILL.md`, `.claude/skills/core/task-delegation/SKILL.md`, `.claude/skills/core/subagent/SKILL.md`, `.claude/skills/core/bd/SKILL.md`, `.claude/skills/core/code-review/SKILL.md`, `.claude/skills/core/testing-strategy/SKILL.md`, `.claude/skills/engineering/tdd/SKILL.md`, `.claude/skills/engineering/refactoring/SKILL.md`

## Native Intent

The ATV Skills Catalog is a standardized agent workspace and skills catalog. Its native shape is not a single slash command. It is:

- Agent-led installation from `AGENT_START.md`.
- Beads (`bd`) or backlog workflow as the source of truth.
- `AGENTS.md` as the operating manual.
- Main conversational thread as tech lead/orchestrator.
- Subagents as execution workers.
- Skills activated by role and task type.
- Frequent git sync, verification, commits, and pushes.

Important native constraints:

- The main thread plans, decomposes, delegates, reviews, commits, and updates backlog.
- The main thread should not directly implement non-trivial code.
- Every non-trivial task must exist in `bd` or the configured backlog.
- Subagents must pull first, execute narrowly, verify, commit, sync backlog, push, and report.
- TDD and testing-strategy skills guide implementation and validation.
- Code review is a first-class quality gate.

## Install / Setup

Recommended agent installation prompt:

```text
Read and execute: https://raw.githubusercontent.com/All-The-Vibes/skills-catalog/main/AGENT_START.md
```

Manual install path:

```bash
curl -fsSL https://raw.githubusercontent.com/ezrasingh/beads/main/install.sh | sh
cd /path/to/project
bd init
git clone https://github.com/All-The-Vibes/skills-catalog.git /tmp/skills-catalog
cp -r /tmp/skills-catalog/.claude/skills .claude/
cp /tmp/skills-catalog/AGENTS.md AGENTS.md
rm -rf /tmp/skills-catalog
```

Verification commands from the repo:

```bash
bd --version
ls -la .claude/skills/
ls -la AGENTS.md
bd create "Verification test task"
bd list
```

For the Community Aid Hub benchmark, install these skills unless a reviewer approves a narrower set:

- Core: `bd`, `git`, `subagent`, `technical-lead-role`, `task-delegation`, `session-continuation`, `code-review`, `testing-strategy`.
- Engineering: `tdd`, `refactoring`.
- Documentation: `technical-writing` if docs are part of the deliverable.
- Research: `technical-research` only if the task packet requires external technical research.

Record the installed source and commit when available:

```bash
git -C <skills-catalog-install-path> rev-parse HEAD
```

## Scoreable Native Path

Use this path for the Community Aid Hub complex app.

1. Prepare a clean benchmark worktree and task packet.
2. Run the `AGENT_START.md` setup or equivalent manual setup:
   - Check prerequisites.
   - Detect platform.
   - Initialize git if needed.
   - Install and initialize `bd`.
   - Install selected skills.
   - Copy or create `AGENTS.md`.
   - Run the verification checklist.
3. Record setup answers:
   - Platform.
   - Skills directory.
   - Beads/backlog mode.
   - Selected skill set.
   - Whether remote push is allowed, sandboxed to a test remote, or disabled.
4. Start the benchmark under `AGENTS.md` rules with the main thread as tech lead:
   - Search backlog before creating tasks.
   - Create a parent `bd` issue for Community Aid Hub.
   - Decompose into child issues with clear acceptance criteria and dependencies.
   - Mark which tasks are AFK and which require HITL.
5. Design the approach in the main thread:
   - Architecture and data flow.
   - Task decomposition.
   - Risk and dependency assessment.
   - Testing strategy.
   - Model assignment for subagents if the host supports multiple models.
6. Delegate execution tasks to subagents:
   - Use `task-delegation` guidance.
   - Use one subagent per well-scoped task.
   - Delegate independent tasks in parallel only when they do not touch overlapping files or dependencies.
   - Include the issue ID, acceptance criteria, relevant files, expected output, and required skills in each subagent prompt.
7. Require subagents to follow the `subagent` protocol:
   - Pull/rebase first unless the benchmark environment forbids remote access.
   - Parse task and acceptance criteria.
   - Gather context.
   - Plan changes.
   - Execute narrowly.
   - Verify acceptance criteria.
   - Commit with issue reference.
   - Run `bd sync`.
   - Push to the benchmark remote if the lane allows push; otherwise record that push is disabled and preserve the commit locally.
   - Report changes and evidence back to tech lead.
8. Use `tdd` for production behavior changes:
   - Write a failing test first.
   - Make it pass with minimal code.
   - Refactor only after green.
   - Repeat by behavior.
9. Use `testing-strategy` to choose layered tests:
   - Unit tests for focused logic.
   - Integration tests for service/API/data interactions.
   - E2E tests only for critical user journeys.
10. Use `code-review` after subagent completion and before marking issues done:
   - Review correctness, maintainability, security, performance, and testing.
   - Classify findings by severity.
   - Fix blocking issues before closure.
11. The tech lead reviews subagent outputs against acceptance criteria:
   - Verify skill compliance.
   - Verify tests/validators.
   - Commit or preserve commits according to the lane.
   - Update and close `bd` issues.
12. Run deterministic benchmark validators outside ATV.
13. Capture setup logs, backlog state, delegation prompts, subagent reports, commits, test logs, review findings, validator output, and manual intervention notes.

## Required Evidence

- Harness repo URL, install method, selected skills, source path, and checked commit when available.
- `AGENT_START.md` or manual setup transcript.
- `bd --version`, `bd init` evidence, and verification checklist output.
- Installed `.claude/skills/` tree and `AGENTS.md`.
- Initial and final `bd list` / `bd show` outputs.
- Parent issue and child issue definitions with acceptance criteria and dependencies.
- Tech-lead planning notes.
- Delegation prompts and subagent reports.
- TDD red/green/refactor evidence for production behavior.
- Testing-strategy rationale and test command logs.
- Code-review findings and resolution notes.
- Commit log with issue references.
- Push/sync evidence, or explicit benchmark reason push was disabled/sandboxed.
- Deterministic benchmark validator logs.
- Manual intervention log, including HITL decisions, environment fixes, skipped skills, failed subagents, or reruns.

## Wrong-Use Rejection

Mark the run `invalid_native_use` and do not score it if any of these happen:

- ATV is used as a generic prompt rather than installed/startup workflow plus selected skills.
- `AGENT_START.md` or equivalent setup is skipped.
- `bd` or another declared backlog source of truth is not initialized.
- Work starts without a tracked issue for non-trivial implementation.
- The main thread directly implements non-trivial code instead of delegating execution.
- Subagent prompts lack issue ID, acceptance criteria, expected output, or relevant skill requirements.
- Subagents make broad unrelated changes outside their task scope.
- Subagents skip verification before reporting done.
- Production behavior changes skip TDD.
- Code review is skipped before marking issues done.
- Backlog status is not updated to match actual work.
- Push/sync requirements are silently ignored instead of being declared disabled/sandboxed for the benchmark.
- Human/manual fixes are applied and scored as model or harness output.
- The benchmark wrapper rewrites ATV into a single-agent implementation flow and scores that as native ATV.

## Variant Notes

- `atv_bd_local` is the preferred reproducible benchmark lane: `bd` is initialized locally and remote pushes are disabled or pointed at a sandbox remote.
- `atv_full_remote` is valid only when the experiment intentionally tests git push/backlog sync against a real or sandbox remote.
- `atv_single_agent` is not a faithful native lane for complex work unless the target host lacks subagents and the run is explicitly marked as degraded.
- If subagents are unavailable, record the missing capability as an environment limitation rather than pretending the tech-lead model ran.

## Opus Review Checklist

Ask the external reviewer to answer these before this card graduates from draft:

1. Does this card correctly identify ATV as an install/startup plus role-based workflow, not a single slash-command harness?
2. Is `AGENT_START.md -> bd setup -> AGENTS.md tech-lead flow -> delegated subagents -> TDD/testing/code-review` the fair native sequence?
3. Should the benchmark require real `bd` initialization, or is a captured local markdown equivalent acceptable?
4. Should remote push be disabled, pointed at a sandbox remote, or treated as required native behavior?
5. Which ATV skills are truly required for Community Aid Hub, and which should remain optional?
6. How should ATV be scored if the target host cannot provide subagents?
