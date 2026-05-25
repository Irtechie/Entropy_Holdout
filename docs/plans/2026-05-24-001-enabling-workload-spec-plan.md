---
kb_id: kb-2026-05-24-entropy-workload-harness
slice_id: slice-001
title: "Workload spec and scoring contract"
blockers: []
verification: tdd
hitl: false
expected_files:
  - path: benchmarks/entropy_workloads/README.md
    op: create
    scope: "Document workload families, stages, and scoring contract."
  - path: benchmarks/entropy_workloads/workloads.json
    op: create
    scope: "Machine-readable definitions for web, library, and factory workloads."
  - path: benchmarks/entropy_workloads/schema.json
    op: create
    scope: "Schema for workload and result records."
  - path: tools/entropy_workload_check.ps1
    op: create
    scope: "Fast local validator for workload spec and sample result records."
status: pending
owner: agent
blocked_reason: ""
resume_when: ""
next_agent_action: "Create workload schema/spec files and validator tests before implementing model runs."
human_action: ""
can_continue_other_slices: true
---

# Workload Spec And Scoring Contract

## What To Build

Create the benchmark specification layer: workload definitions, result fields, and a fast local validation command.

## Acceptance Criteria

- Workload families are defined for webpage chain, library chain, and factory.
- Each workload has ordered stages, expected generated artifacts, and validator expectations.
- Result records can capture model, context, harness mode, stage, pass/fail, failure class, and generated files.
- A local command validates the specs without requiring model access.

## Verification

Run:

```powershell
pwsh .\tools\entropy_workload_check.ps1
```

## Scope Boundary

This slice does not call any model endpoint and does not generate workload code.
