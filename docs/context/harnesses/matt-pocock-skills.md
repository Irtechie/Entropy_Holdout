# Matt Pocock Skills Invocation Card

Status: draft for external tire-kicking
Checked: 2026-05-27

## Source

- Repo: `https://github.com/mattpocock/skills.git`
- Checked HEAD: `b8be62ffacb0118fa3eaa29a0923c87c8c11985c`
- Local research checkout: `%TEMP%/entropy-harness-repos/mattpocock-skills`
- Primary files inspected: `README.md`, `CLAUDE.md`, `CONTEXT.md`, `docs/adr/0001-explicit-setup-pointer-only-for-hard-dependencies.md`, `.claude-plugin/plugin.json`, `skills/productivity/grill-me/SKILL.md`, `skills/engineering/setup-matt-pocock-skills/SKILL.md`, `skills/engineering/grill-with-docs/SKILL.md`, `skills/engineering/to-prd/SKILL.md`, `skills/engineering/to-issues/SKILL.md`, `skills/engineering/triage/SKILL.md`, `skills/engineering/triage/AGENT-BRIEF.md`, `skills/engineering/tdd/SKILL.md`, `skills/engineering/diagnose/SKILL.md`, `skills/engineering/prototype/SKILL.md`, `skills/engineering/improve-codebase-architecture/SKILL.md`, `skills/engineering/setup-matt-pocock-skills/issue-tracker-local.md`

## Native Intent

Matt Pocock's skills are intentionally small, composable engineering skills. The README explicitly contrasts them with process-owning systems: these skills are meant to preserve user control, reduce common agent failure modes, and be mixed as needed.

For this benchmark, do not treat this repo as a single-command autonomous factory. Its native execution path is issue-tracker and agent-brief driven: align with the user, produce a PRD, break that into ready-for-agent vertical issues, then let an AFK implementation agent execute those issues with the relevant engineering skills.

Relevant native behavior:

- `/setup-matt-pocock-skills` configures the repo for the rest of the engineering skills.
- `/grill-me` relentlessly interviews the user about a plan or design. It is the plain, non-code grilling primitive.
- `/grill-with-docs` aligns on the plan, challenges it against the codebase/domain language, and updates `CONTEXT.md` / ADRs when decisions crystallize.
- `/to-prd` turns known conversation context into a PRD and publishes it to the configured issue tracker.
- `/to-issues` breaks a PRD/spec/plan into vertical tracer-bullet issues.
- `/triage` moves issues through the issue-tracker state machine and writes an agent brief when an issue becomes `ready-for-agent`.
- `/tdd` implements features or bug fixes one behavior at a time using red-green-refactor.
- `/diagnose` is for bugs and regressions, with a reproduce/minimize/hypothesize/instrument/fix/regression-test loop.
- `/prototype` is explicitly throwaway code for answering design questions, not production implementation.
- `/improve-codebase-architecture` surfaces architecture deepening opportunities; it is not the default implementation path.

## Install / Setup

Native installer:

```bash
npx skills@latest add mattpocock/skills
```

During install, select the skills needed for the target agent and make sure `/setup-matt-pocock-skills` is selected.

Then run:

```text
/setup-matt-pocock-skills
```

That setup skill asks for:

- Issue tracker: GitHub, GitLab, local markdown, or another described workflow.
- Triage label vocabulary.
- Domain docs layout: single `CONTEXT.md` or `CONTEXT-MAP.md` multi-context layout.

It writes or updates:

- `AGENTS.md` or `CLAUDE.md` `## Agent skills` block.
- `docs/agents/issue-tracker.md`
- `docs/agents/triage-labels.md`
- `docs/agents/domain.md`

Record the installed source and commit when available:

```bash
git -C <matt-pocock-skills-install-path> rev-parse HEAD
```

## Scoreable Native Path

Use this path for the Community Aid Hub complex app.

1. Prepare a clean benchmark worktree and task packet.
2. Install the Matt Pocock skills for the target agent host and record install method, path, selected skills, and source commit.
3. Run `/setup-matt-pocock-skills` before other engineering skills:
   - Configure an issue tracker. For offline benchmark runs, `local markdown` is the preferred deterministic choice unless GitHub issue creation is intentionally part of the test.
   - Configure triage labels.
   - Configure domain docs.
   - Capture generated `docs/agents/*` files and agent-instruction block.
4. Start with the grilling phase:
   - Use `/grill-with-docs` for code/product work in a repo.
   - Use `/grill-me` only when the run intentionally avoids repo/domain docs.
   - Let the skill explore the codebase if a starter repo exists.
   - Let it ask one question at a time when the task packet is insufficient.
   - If the benchmark is AFK-only, answer only from the task packet and log unanswered questions as HITL blockers.
   - Capture any `CONTEXT.md` or ADR updates.
5. Run `/to-prd` after enough context exists:
   - It must synthesize from the current context, not re-interview.
   - It should describe problem, solution, extensive user stories, implementation decisions, testing decisions, out of scope, and further notes.
   - Publish to the configured issue tracker or local markdown issue path.
6. Run `/to-issues` on the PRD:
   - Break work into vertical tracer-bullet issues.
   - Mark slices `HITL` or `AFK`.
   - Record dependencies and user stories covered.
   - Publish approved slices in dependency order.
   - Use `ready-for-agent` triage labels for AFK-ready issues unless the configured tracker uses different mapped labels.
7. Prepare execution handoff:
   - If `/to-issues` creates complete AFK-ready issue bodies, record those as the execution contract.
   - If an issue needs extra durability before AFK execution, run `/triage` and write an agent brief using `skills/engineering/triage/AGENT-BRIEF.md`.
   - The agent brief should describe current behavior, desired behavior, key interfaces, acceptance criteria, and out-of-scope items.
8. Execute approved AFK issues one at a time:
   - Fetch the issue/PRD from the configured issue tracker.
   - Treat the issue body or agent brief as the contract.
   - Use `/tdd` for production behavior changes.
   - Confirm public interface and behavior priorities before coding.
   - Write one behavior test first.
   - Verify it fails for the right reason.
   - Write minimal implementation.
   - Verify it passes.
   - Repeat by vertical behavior, not horizontal layers.
   - Refactor only after green.
9. Use `/diagnose` only when an implementation or validator failure appears:
   - Build a deterministic feedback loop.
   - Reproduce the bug.
   - Generate ranked hypotheses.
   - Instrument one variable at a time.
   - Fix with a regression test where a correct seam exists.
10. Use `/prototype` only if a design or state-model question genuinely needs a throwaway prototype:
   - Declare the question the prototype answers.
   - Keep it clearly marked as throwaway.
   - Delete or absorb it before final scoring.
11. Use `/improve-codebase-architecture` only as a declared architecture-review variant or after a failure reveals module-depth/testability problems. Do not silently add it to the baseline.
12. Run deterministic benchmark validators outside the Matt Pocock skills.
13. Capture all setup docs, domain docs, PRD, issues, agent briefs, implementation logs, red/green TDD evidence, validator output, and manual intervention notes.

## Required Evidence

- Harness repo URL, install method, installed skill list, source path, and checked commit when available.
- `/setup-matt-pocock-skills` output and generated `docs/agents/*` files.
- Issue tracker mode: GitHub, GitLab, local markdown, or other.
- Domain doc layout and any `CONTEXT.md` / ADR changes.
- `/grill-with-docs` questions, answers, unresolved questions, and decisions.
- `/to-prd` PRD artifact and publication location.
- `/to-issues` slice list, HITL/AFK classification, dependencies, and publication locations.
- `/triage` state changes and agent brief comments/files when used.
- Execution source for each AFK issue: issue body, PRD, or agent brief.
- Per-slice `/tdd` evidence: planned public interface, behavior list, red failure, green pass, refactor verification, commits.
- `/diagnose` evidence if used.
- Prototype question, path, result, and deletion/absorption evidence if `/prototype` is used.
- Deterministic benchmark validator logs.
- Manual intervention log, including human answers, approval decisions, environment fixes, skipped skills, or reruns.

## Wrong-Use Rejection

Mark the run `invalid_native_use` and do not score it if any of these happen:

- The skills are treated as an autonomous factory instead of composable skills.
- `/setup-matt-pocock-skills` is skipped before using skills that require repo issue/domain configuration.
- The grilling phase is skipped and the run claims alignment on a complex app.
- `/grill-me` is used for repo-aware code work when `/grill-with-docs` was available and relevant.
- `/to-prd` is produced without current conversation/task context.
- `/to-issues` creates horizontal layer tickets instead of vertical tracer-bullet slices.
- AFK execution starts without an issue body or agent brief that defines behavior and acceptance criteria.
- HITL slices are silently implemented as AFK.
- `/tdd` is skipped for production behavior changes.
- Tests are written in horizontal batches before implementation.
- Tests verify implementation details instead of public behavior.
- Production code is written before a behavior test fails for the right reason.
- `/prototype` code is scored as production implementation without being absorbed into real code through TDD.
- `/diagnose` fixes a bug without first establishing a feedback loop and reproduction.
- Human/manual fixes are applied and scored as model or harness output.
- The benchmark wrapper rewrites the composable skills into a GStack/Superpowers-style lifecycle and scores that as Matt Pocock's native method.

## Variant Notes

- `matt_local_issues` is the preferred deterministic benchmark lane: setup uses local markdown issues instead of mutating GitHub/GitLab.
- `matt_github_issues` is valid if issue tracker mutation is intentionally part of the experiment.
- `matt_grill_me_only` is not the default code benchmark lane; use it only when evaluating non-code planning behavior or when repo/domain docs are intentionally out of scope.
- This harness should be scored on alignment quality, PRD quality, issue/agent-brief quality, TDD discipline, and resulting entropy. Do not penalize it for lacking a single all-in-one orchestrator command; its orchestrator is the issue-tracker workflow.

## Opus Review Checklist

Ask the external reviewer to answer these before this card graduates from draft:

1. Does this card correctly treat Matt Pocock's skills as composable skills rather than an autonomous factory?
2. Is `/grill-with-docs -> /to-prd -> /to-issues -> ready-for-agent issue/agent brief -> /tdd execution` the fairest complex-app sequence?
3. When should `/grill-me` be used instead of `/grill-with-docs` in this benchmark, if ever?
4. Should `/triage` be required after `/to-issues`, or only when the issue body is not durable enough for AFK execution?
5. Should `/prototype` be part of the default Community Aid Hub lane, or only allowed as a declared optional design-discovery variant?
6. Should `/improve-codebase-architecture` be included before implementation, after first validator failure, or excluded from the first benchmark lane?
7. Is local markdown issue tracking the right default for reproducible benchmark runs?
8. What evidence is sufficient to prove TDD was actually followed instead of tests being added after the fact?
