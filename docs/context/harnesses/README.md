# Harness Invocation Cards

Status: draft
Created: 2026-05-27

These cards define how each candidate harness must be used before any score is valid.

The rule is simple: a harness can lose only after we have driven it in its native workflow. If a run bypasses the intended setup, planning, review, TDD, QA, or finish loop, the row is a setup failure, not a harness failure.

Cards are written and reviewed one harness at a time. Do not bulk-author all cards from shallow README summaries.

## Cards

- `gstack.md`
- `superpowers.md`

Pending, not yet carded:

- Matt Pocock skills
- ATV skills catalog
- Working Skill Repo / Pt. 2 skills

## Shared Evidence Wrapper

Each run must record:

- Harness repo URL and commit.
- Installation path and command.
- Native workflow steps used.
- Model/backend used.
- Task packet path.
- Generated worktree/branch/output path.
- Test and validation commands with logs.
- Native review/QA artifacts.
- Manual intervention log.
- Final scorecard.

## Wrong-Use Rule

If the card's wrong-use checklist triggers, mark the run `invalid_native_use` and do not score it.
