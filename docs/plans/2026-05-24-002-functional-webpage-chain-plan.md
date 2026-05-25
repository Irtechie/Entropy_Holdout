---
kb_id: kb-2026-05-24-entropy-workload-harness
slice_id: slice-002
title: "Webpage chain workload runner"
blockers: [slice-001]
verification: functional
hitl: false
expected_files:
  - path: tools/run_entropy_workload.ps1
    op: create
    scope: "Add runner entry point for staged workloads."
  - path: benchmarks/entropy_workloads/webpage_chain.json
    op: create
    scope: "Detailed staged prompts and validators for the webpage workload."
  - path: tools/validators/webpage_chain.ps1
    op: create
    scope: "Validate generated page links, shared structure, and file existence."
status: pending
owner: agent
blocked_reason: ""
resume_when: ""
next_agent_action: "Implement the webpage chain as the first end-to-end workload."
human_action: ""
can_continue_other_slices: true
---

# Webpage Chain Workload Runner

## What To Build

Implement the staged webpage workload where each page depends on previous generated pages and a later shared structure must be used consistently.

## Acceptance Criteria

- Runner can execute the webpage workload in a dry-run/mock mode.
- Generated artifact validator checks page count, backlink integrity, and shared table/navigation consistency.
- Result JSONL records the first failing stage.

## Verification

Run a mock workload and validator locally:

```powershell
pwsh .\tools\run_entropy_workload.ps1 -Workload webpage-chain -Mode mock
```

## Scope Boundary

This slice does not implement the library or factory workload.
