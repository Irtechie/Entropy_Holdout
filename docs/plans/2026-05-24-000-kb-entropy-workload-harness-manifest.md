---
type: kb-manifest
kb_id: kb-2026-05-24-entropy-workload-harness
brainstorm_path: docs/brainstorms/2026-05-24-entropy-workload-tests.md
created: 2026-05-24
status: completed
slices:
  - id: slice-001
    title: "Workload spec and scoring contract"
    path: docs/plans/2026-05-24-001-enabling-workload-spec-plan.md
    blockers: []
    verification: tdd
    hitl: false
    status: done
    owner: agent
    blocked_reason: ""
    resume_when: ""
    next_agent_action: "Define benchmark scenario/result schemas and local validation tests."
    human_action: ""
    can_continue_other_slices: true
    notes: "scope-lock: loaded 4 expected files; scope-check: 4/4 expected slice files created, bookkeeping files updated; verification: pwsh .\\tools\\entropy_workload_check.ps1 passed with 3 workloads and 13 stages; memory-impact: durable; areas=benchmark workload specs"
  - id: slice-002
    title: "Webpage chain workload runner"
    path: docs/plans/2026-05-24-002-functional-webpage-chain-plan.md
    blockers: [slice-001]
    verification: functional
    hitl: false
    status: done
    owner: agent
    blocked_reason: ""
    resume_when: ""
    next_agent_action: "Implement staged webpage generation prompts and validators."
    human_action: ""
    can_continue_other_slices: true
    notes: "scope-lock: loaded 3 expected files; scope-check: 3/3 expected slice files created, bookkeeping files updated; verification: pwsh .\\tools\\run_entropy_workload.ps1 -Workload webpage-chain -Mode mock passed and validated 5 pages; generated run output cleaned; memory-impact: durable; areas=webpage workload runner"
  - id: slice-003
    title: "Library chain workload runner"
    path: docs/plans/2026-05-24-003-integration-library-chain-plan.md
    blockers: [slice-001]
    verification: integration
    hitl: false
    status: done
    owner: agent
    blocked_reason: ""
    resume_when: ""
    next_agent_action: "Implement staged library generation prompts and build validators."
    human_action: ""
    can_continue_other_slices: true
    notes: "scope-lock: loaded 3 expected files; scope-check: 3/3 expected slice files changed, bookkeeping files updated; verification: pwsh .\\tools\\run_entropy_workload.ps1 -Workload library-chain -Mode mock passed, dotnet build/run output core->feature->pipeline->contract; generated run output cleaned; memory-impact: durable; areas=library workload runner"
  - id: slice-004
    title: "Factory workload runner"
    path: docs/plans/2026-05-24-004-functional-factory-workload-plan.md
    blockers: [slice-001]
    verification: functional
    hitl: true
    status: done
    owner: agent
    blocked_reason: ""
    resume_when: ""
    next_agent_action: "Implement generic factory workload unless the real dropped-in factory seed is supplied."
    human_action: "Confirm or provide the exact factory seed/spec if generic factory is insufficient."
    can_continue_other_slices: true
    notes: "Factory seed was not found in this checkout during bootstrap; used generic seed. scope-lock: loaded 3 expected files; scope-check: 3/3 expected slice files changed, bookkeeping files updated; verification: pwsh .\\tools\\run_entropy_workload.ps1 -Workload factory -Mode mock passed with route intake->assembly->quality->shipping; generated run output cleaned; memory-impact: durable; areas=factory workload runner"
  - id: slice-005
    title: "Model/context matrix runner and report"
    path: docs/plans/2026-05-24-005-integration-matrix-report-plan.md
    blockers: [slice-002, slice-003, slice-004]
    verification: integration
    hitl: false
    status: done
    owner: agent
    blocked_reason: ""
    resume_when: ""
    next_agent_action: "Run workloads against selected targets and aggregate break-point results."
    human_action: ""
    can_continue_other_slices: true
    notes: "scope-lock: loaded 3 expected files; scope-check: 3/3 expected slice files created, bookkeeping files updated; verification: pwsh .\\tools\\run_entropy_matrix.ps1 and .\\tools\\report_entropy_results.ps1 passed, mock summary webpage 5/5 library 4/4 factory 4/4; generated run output cleaned; memory-impact: durable; areas=matrix runner and reporting"
---

# KB: Entropy Workload Harness

## Origin

Brainstorm: `docs/brainstorms/2026-05-24-entropy-workload-tests.md`

## Slice Overview

| # | Slice | Blocked By | Verification | HITL | Status |
|---|---|---|---|---|---|
| 1 | Workload spec and scoring contract | - | tdd | no | done |
| 2 | Webpage chain workload runner | slice-001 | functional | no | done |
| 3 | Library chain workload runner | slice-001 | integration | no | done |
| 4 | Factory workload runner | slice-001 | functional | yes | done |
| 5 | Model/context matrix runner and report | slice-002, slice-003, slice-004 | integration | no | done |

## Route

Mock/local harness slices are complete. Next work is wiring real model calls and Entropy harness modes into the runner.
