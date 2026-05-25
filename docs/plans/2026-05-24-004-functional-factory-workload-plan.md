---
kb_id: kb-2026-05-24-entropy-workload-harness
slice_id: slice-004
title: "Factory workload runner"
blockers: [slice-001]
verification: functional
hitl: true
expected_files:
  - path: benchmarks/entropy_workloads/factory.json
    op: create
    scope: "Factory workload stages and architecture constraints."
  - path: tools/validators/factory.ps1
    op: create
    scope: "Validate generated factory components, dependency graph, and end-to-end behavior."
  - path: tools/run_entropy_workload.ps1
    op: edit
    scope: "Add factory workload dispatch."
status: pending
owner: agent
blocked_reason: ""
resume_when: ""
next_agent_action: "Implement generic factory workload if no exact seed is supplied."
human_action: "Provide exact factory seed/spec if it exists outside this checkout."
can_continue_other_slices: true
test_inputs:
  - name: factory_seed
    source: user
    required_for: "Exact reproduction of last night's third workload."
    value: "TODO-human or use generic seed"
---

# Factory Workload Runner

## What To Build

Implement the factory/system workload that creates a growing connected system, not just a linear file chain.

## Acceptance Criteria

- Generic factory workload has staged component creation and dependency pressure.
- Validator checks component presence, dependency graph, configuration, and one end-to-end behavior.
- If the exact factory seed is supplied, use it as the source of truth.

## Verification

Run:

```powershell
pwsh .\tools\run_entropy_workload.ps1 -Workload factory -Mode mock
```

## Scope Boundary

Do not block webpage/library work on the missing exact factory seed.
