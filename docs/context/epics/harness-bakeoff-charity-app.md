# Harness Bakeoff Charity App

Status: draft
Created: 2026-05-26
Last refreshed: 2026-05-26

## Intent

Compare agent workflow harnesses on useful software tasks, not just benchmark prompts. The outcome should show which harnesses preserve requirements, verify work, recover from failure, and produce a usable app as task complexity increases.

The public-facing outcome can include the best generated implementation of a charity/community-support app, plus a clear scorecard of which harness produced which quality level.

## Harnesses

Candidate harnesses:

- Plain EB: local Entropy runner in this repo.
- EB repair/prevalidation: local Entropy runner in this repo.
- GStack native: `https://github.com/garrytan/gstack.git`
- Superpowers native: `https://github.com/obra/superpowers.git`
- Matt Pocock skills native: `https://github.com/mattpocock/skills.git`
- ATV-startup / upstream ATV native: candidate source `https://github.com/All-The-Vibes/skills-catalog.git`
- Your Pt. 2 skills native: candidate source `https://github.com/Irtechie/working-skill-repo.git`

Native means each harness is used the way its authors intend: its planning/review/QA/memory flow is allowed, but evidence capture and scoring must be standardized.

Current repo HEADs checked on 2026-05-26:

| Harness | Repository | HEAD checked |
|---|---|---|
| GStack | `https://github.com/garrytan/gstack.git` | `22f8c7f4e1eda65680d4b87a2548429f44020277` |
| Superpowers | `https://github.com/obra/superpowers.git` | `f2cbfbefebbfef77321e4c9abc9e949826bea9d7` |
| Matt Pocock skills | `https://github.com/mattpocock/skills.git` | `b8be62ffacb0118fa3eaa29a0923c87c8c11985c` |
| ATV candidate | `https://github.com/All-The-Vibes/skills-catalog.git` | `5a5f82456e872342b29bdad9f1b118f47d6ce125` |
| Your KB / Pt. 2 candidate | `https://github.com/Irtechie/working-skill-repo.git` | `45393cba1ebad9d7043f55a37b40129461715664` |

The ATV row is not frozen until we confirm this is the exact upstream `ATV-startup` baseline. The `Irtechie/working-skill-repo` row is not frozen until we confirm whether the Pt. 2 DF skills live in this repo, another repo, or an unpublished local path.

## Native-Use Validation

Before a harness run is scoreable, create a one-page invocation card for that harness with:

- Exact repo URL, commit, install command, and runtime prerequisites.
- The author's intended entry command or workflow path.
- The commands/skills used in order for this benchmark.
- Any model/runtime assumptions required by the harness.
- What evidence the harness natively emits.
- What extra wrapper evidence the benchmark captures.
- A short "wrong-use rejection" checklist.

Wrong-use rejection examples:

- GStack is driven as a generic prompt instead of through its intended role/command workflow.
- Superpowers is used without its spec/plan/TDD/review methodology when that is the intended native flow.
- Matt Pocock skills are treated as an autonomous factory if the selected skills are meant to stay small and composable.
- ATV-startup is scored as a complete harness if only startup/context bootstrap was used.
- Your Pt. 2 skills are mixed with upstream ATV in a way that hides which layer produced the outcome.

If any native-use card is missing, that harness can be setup-tested but not scored.

## Task Families

| Family | Purpose |
|---|---|
| Website A | Existing webpage-chain continuity baseline. |
| Website B | Nonprofit service-directory website with shared data, search, filtering, and cross-page consistency. |
| Library | Existing library-chain dependency/build baseline. |
| Complex App | Community Aid Hub mega-app: food pantry, food rescue, volunteer coordination, and service directory. |
| Holdout App | Same scoring shape in a different charity domain, held back until harness prompts are frozen. |

## Complex App: Community Aid Hub

Build an app that helps a small nonprofit or mutual-aid group coordinate food pantry inventory, rescued food donations, volunteer assignments, and public service discovery.

Required user roles:

- Admin/staff
- Donor organization
- Volunteer
- Recipient/community visitor

Required modules:

- Pantry inventory and item availability.
- Food rescue offers, pickup windows, expiration urgency, and delivery status.
- Volunteer availability, assignments, check-in/check-out, and hours.
- Service directory with search and filters.
- Admin dashboard and basic report/export.

## Scored Slices

| Slice | Requirement | Pass Evidence |
|---|---|---|
| 1 | Data model and seed data for organizations, donors, inventory, volunteers, pickups, deliveries, recipients, and services. | Tests or scripted checks verify relationships and seed data. |
| 2 | Pantry inventory workflow: receive items, adjust stock, flag expiring items, and show availability. | UI/API or CLI workflow demonstrates stock changes and expiration flags. |
| 3 | Food rescue workflow: donor offer -> staff accept -> volunteer assigned -> pickup/delivery tracked. | End-to-end workflow with status transitions and conflict checks. |
| 4 | Volunteer workflow: availability, assignment conflict prevention, check-in/check-out, hours summary. | Tests prove double-booking is blocked and hours are calculated. |
| 5 | Service directory: searchable list with filters by location, service type, hours, and eligibility notes. | Functional search/filter proof. |
| 6 | Admin reporting: overdue pickups, low stock, expiring items, volunteer hours, and export. | Dashboard/report output verified against seeded data. |

## Standard Scorecard

Score each slice independently:

- `0`: no usable artifact
- `1`: artifact exists but cannot run
- `2`: runs but major requirement missing
- `3`: core workflow works with obvious gaps
- `4`: workflow works and is tested, minor gaps only
- `5`: workflow works, tested, coherent UX/API, and evidence is complete

Cross-cutting deductions:

- Missing runnable setup.
- Missing tests or deterministic proof.
- Broken final validation.
- Hidden manual intervention.
- Missing evidence logs.
- Claims not supported by artifacts.

## Evidence Requirements

Every harness run must preserve:

- Harness name and version/commit.
- Native-use invocation card.
- Model and serving config.
- Exact prompt/task packet.
- Generated files or branch/worktree.
- Test commands and logs.
- Review/QA output if native harness provides it.
- Manual intervention log.
- Final scorecard and failure classification.

## Holdout Policy

Freeze the harness invocation recipes before running holdouts.

Holdout candidate domains:

- Volunteer ride coordination for seniors or medical appointments.
- Shelter supply intake and distribution.
- Community cooling/warming center operations.

Holdouts must reuse the same scoring structure but change enough domain details that harness-specific prompt overfitting is visible.

## Open Questions

- Confirm exact upstream ATV repo/path for the `ATV-startup` baseline. Candidate is `https://github.com/All-The-Vibes/skills-catalog.git`.
- Confirm exact repo/path for your Pt. 2 DF skills. Candidate is `https://github.com/Irtechie/working-skill-repo.git`.
- Whether Matt Pocock skills should be tested as individual composable skills or as a prescribed multi-skill workflow.
- Whether GStack and Superpowers can run locally under Codex, or need Claude Code native sessions for fair use.
- How to normalize time/attempt/token budgets across native harnesses.
