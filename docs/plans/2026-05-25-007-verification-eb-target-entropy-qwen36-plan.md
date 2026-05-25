---
kb_id: kb-2026-05-25-eb-remaining-singlebox-runs
slice_id: slice-007
title: "Run EB target entropy-qwen36"
target_set_id: entropy-qwen36
blockers: []
verification: functional-cli
test_level: functional-cli
functional_risk: narrow
hitl: false
expected_files:
  - path: runs/EB/EB-entropy-qwen36-<timestamp>/
    op: create
    scope: "One reproducible EB run folder with metadata, critique, raw responses, token usage, and generated files."
  - path: docs/plans/2026-05-25-000-kb-eb-remaining-singlebox-runs-manifest.md
    op: edit
    scope: "Mark this slice status and record run folder/verification proof."
  - path: docs/plans/2026-05-25-007-verification-eb-target-entropy-qwen36-plan.md
    op: edit
    scope: "Record status, run folder, and verification proof."
  - path: todo.md
    op: edit
    scope: "Sync live board status for this slice."
status: pending
owner: agent
blocked_reason: ""
resume_when: ""
next_agent_action: "Run EB for entropy-qwen36, report, commit, push."
human_action: ""
can_continue_other_slices: true
---

# Run EB Target Entropy Qwen36

Run the three-workload EB baseline for `entropy-qwen36` in `plain` harness mode.

## Acceptance Criteria

- EB run folder is complete.
- Critique captures first failure and token usage.
- Commit and push complete before next target.

## Commands

```powershell
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$run = ".\runs\EB\EB-entropy-qwen36-$stamp"
pwsh .\tools\run_entropy_serial_experiment.ps1 -ExperimentPath .\benchmarks\entropy_workloads\experiment.local-full-singlebox.json -OnlySet entropy-qwen36 -ResultRoot $run
pwsh .\tools\report_entropy_results.ps1 -ResultsPath "$run\results.jsonl" -Json
```

## Scope Boundary

No generated-output repair behavior in Wave 2. LLMCommune/model-serving recovery is allowed.

