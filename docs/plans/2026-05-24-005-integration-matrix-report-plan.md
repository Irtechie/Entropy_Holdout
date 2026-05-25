---
kb_id: kb-2026-05-24-entropy-workload-harness
slice_id: slice-005
title: "Model/context matrix runner and report"
blockers: [slice-002, slice-003, slice-004]
verification: integration
hitl: false
expected_files:
  - path: tools/run_entropy_matrix.ps1
    op: create
    scope: "Run selected workloads across selected Entropy targets and harness modes."
  - path: tools/report_entropy_results.ps1
    op: create
    scope: "Aggregate JSONL results into break-point summaries."
  - path: benchmarks/entropy_workloads/matrix.default.json
    op: create
    scope: "Default workload/model/context matrix."
status: pending
owner: agent
blocked_reason: ""
resume_when: ""
next_agent_action: "Add matrix orchestration and reporting after individual workloads validate locally."
human_action: ""
can_continue_other_slices: true
---

# Model/Context Matrix Runner And Report

## What To Build

Run the staged workloads across selected model/context/harness combinations and report where each combination breaks.

## Acceptance Criteria

- Matrix config selects models, workloads, harness modes, and max stages.
- Runner emits result JSONL per run.
- Reporter summarizes first failing stage and pass depth by model/context/harness.

## Verification

Run:

```powershell
pwsh .\tools\run_entropy_matrix.ps1 -Matrix .\benchmarks\entropy_workloads\matrix.default.json -Mode mock
pwsh .\tools\report_entropy_results.ps1 -ResultsPath <result.jsonl>
```

## Scope Boundary

This slice should not start broad model runs until mock/local validators pass.
