---
kb_id: kb-2026-05-24-entropy-workload-harness
slice_id: slice-003
title: "Library chain workload runner"
blockers: [slice-001]
verification: integration
hitl: false
expected_files:
  - path: benchmarks/entropy_workloads/library_chain.json
    op: create
    scope: "Detailed staged prompts and validators for the library/DLL workload."
  - path: tools/validators/library_chain.ps1
    op: create
    scope: "Validate project references, build output, and sample execution."
  - path: tools/run_entropy_workload.ps1
    op: edit
    scope: "Add library-chain workload dispatch."
status: pending
owner: agent
blocked_reason: ""
resume_when: ""
next_agent_action: "Implement the dependency-chain workload and build validator."
human_action: ""
can_continue_other_slices: true
---

# Library Chain Workload Runner

## What To Build

Implement staged library generation where each later library depends on prior generated APIs.

## Acceptance Criteria

- Workload stages define dependency and API expectations.
- Validator can compile or otherwise verify the generated chain.
- Sample invocation proves the chain composes end to end.

## Verification

Run:

```powershell
pwsh .\tools\run_entropy_workload.ps1 -Workload library-chain -Mode mock
```

## Scope Boundary

This slice does not require real model calls; mock mode must pass first.
