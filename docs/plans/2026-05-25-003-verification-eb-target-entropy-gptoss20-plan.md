---
kb_id: kb-2026-05-25-eb-remaining-singlebox-runs
slice_id: slice-003
title: "Run EB target entropy-gptoss20"
target_set_id: entropy-gptoss20
blockers: []
verification: functional-cli
test_level: functional-cli
functional_risk: narrow
hitl: false
expected_files:
  - path: runs/EB/EB-entropy-gptoss20-<timestamp>/
    op: create
    scope: "One reproducible EB run folder with metadata, critique, raw responses, token usage, and generated files."
  - path: docs/plans/2026-05-25-000-kb-eb-remaining-singlebox-runs-manifest.md
    op: edit
    scope: "Mark this slice status and record run folder/verification proof."
  - path: docs/plans/2026-05-25-003-verification-eb-target-entropy-gptoss20-plan.md
    op: edit
    scope: "Record status, run folder, and verification proof."
  - path: todo.md
    op: edit
    scope: "Sync live board status for this slice."
status: pending
owner: agent
blocked_reason: ""
resume_when: ""
next_agent_action: "Run EB for entropy-gptoss20, report, commit, push."
human_action: ""
can_continue_other_slices: true
---

# Run EB Target Entropy GPT OSS 20B

Run the three-workload EB baseline for `entropy-gptoss20` in `plain` harness mode.

## Acceptance Criteria

- EB run folder is complete and reproducible.
- Critique records EB score, right shift, likely entropy cause, and token usage.
- Non-wedge model failures are retained as data.
- Commit and push complete before the next slice.

## Commands

```powershell
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$run = ".\runs\EB\EB-entropy-gptoss20-$stamp"
pwsh .\tools\run_entropy_serial_experiment.ps1 -ExperimentPath .\benchmarks\entropy_workloads\experiment.local-full-singlebox.json -OnlySet entropy-gptoss20 -ResultRoot $run
pwsh .\tools\report_entropy_results.ps1 -ResultsPath "$run\results.jsonl" -Json
```

## Scope Boundary

No generated-output repair in Wave 1. LLMCommune/model-serving recovery is allowed.

