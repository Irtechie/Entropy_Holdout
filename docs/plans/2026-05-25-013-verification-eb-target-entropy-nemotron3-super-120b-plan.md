---
kb_id: kb-2026-05-25-eb-remaining-singlebox-runs
slice_id: slice-013
title: "Run EB target entropy-nemotron3-super-120b"
target_set_id: entropy-nemotron3-super-120b
blockers: []
verification: functional-cli
test_level: functional-cli
functional_risk: narrow
hitl: false
expected_files:
  - path: runs/EB/EB-entropy-nemotron3-super-120b-<timestamp>/
    op: create
    scope: "One reproducible EB run folder with metadata, critique, raw responses, token usage, and generated files."
  - path: docs/plans/2026-05-25-000-kb-eb-remaining-singlebox-runs-manifest.md
    op: edit
    scope: "Mark this slice status and record run folder/verification proof."
  - path: docs/plans/2026-05-25-013-verification-eb-target-entropy-nemotron3-super-120b-plan.md
    op: edit
    scope: "Record status, run folder, and verification proof."
  - path: todo.md
    op: edit
    scope: "Sync live board status for this slice."
status: done
owner: agent
blocked_reason: ""
resume_when: ""
next_agent_action: "Run EB for entropy-nemotron3-super-120b, report, commit, push."
human_action: ""
can_continue_other_slices: true
---

# Run EB Target Entropy Nemotron3 Super 120B

Run the three-workload EB baseline for compatibility target `entropy-nemotron3-super-120b` in `plain` harness mode.

## Acceptance Criteria

- Run folder and critique are complete.
- If this aliases another target, the run metadata still records the served model id.
- Non-wedge failures are preserved and pushed.

## Commands

```powershell
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$run = ".\runs\EB\EB-entropy-nemotron3-super-120b-$stamp"
pwsh .\tools\run_entropy_serial_experiment.ps1 -ExperimentPath .\benchmarks\entropy_workloads\experiment.local-full-singlebox.json -OnlySet entropy-nemotron3-super-120b -ResultRoot $run
pwsh .\tools\report_entropy_results.ps1 -ResultsPath "$run\results.jsonl" -Json
```

## Scope Boundary

No generated-output repair in Wave 1. LLMCommune/model-serving recovery is allowed.

