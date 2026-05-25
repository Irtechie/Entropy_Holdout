---
kb_id: kb-2026-05-25-eb-remaining-singlebox-runs
slice_id: slice-006
title: "Run EB target entropy-gemma431"
target_set_id: entropy-gemma431
blockers: []
verification: functional-cli
test_level: functional-cli
functional_risk: narrow
hitl: false
expected_files:
  - path: runs/EB/EB-entropy-gemma431-<timestamp>/
    op: create
    scope: "One reproducible EB run folder with metadata, critique, raw responses, token usage, and generated files."
  - path: docs/plans/2026-05-25-000-kb-eb-remaining-singlebox-runs-manifest.md
    op: edit
    scope: "Mark this slice status and record run folder/verification proof."
  - path: docs/plans/2026-05-25-006-verification-eb-target-entropy-gemma431-plan.md
    op: edit
    scope: "Record status, run folder, and verification proof."
  - path: todo.md
    op: edit
    scope: "Sync live board status for this slice."
status: pending
owner: agent
blocked_reason: ""
resume_when: ""
next_agent_action: "Run EB for entropy-gemma431, report, commit, push."
human_action: ""
can_continue_other_slices: true
---

# Run EB Target Entropy Gemma431

Run the three-workload EB baseline for `entropy-gemma431` in `plain` harness mode.

## Acceptance Criteria

- Run folder preserves EB evidence and critique.
- Report summarizes stage breakpoints.
- Non-wedge failures are committed and pushed as data.

## Commands

```powershell
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$run = ".\runs\EB\EB-entropy-gemma431-$stamp"
pwsh .\tools\run_entropy_serial_experiment.ps1 -ExperimentPath .\benchmarks\entropy_workloads\experiment.local-full-singlebox.json -OnlySet entropy-gemma431 -ResultRoot $run
pwsh .\tools\report_entropy_results.ps1 -ResultsPath "$run\results.jsonl" -Json
```

## Scope Boundary

No generated-output repair in this slice. LLMCommune/model-serving recovery is allowed.

