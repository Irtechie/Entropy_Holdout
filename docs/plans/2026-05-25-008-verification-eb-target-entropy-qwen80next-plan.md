---
kb_id: kb-2026-05-25-eb-remaining-singlebox-runs
slice_id: slice-008
title: "Run EB target entropy-qwen80next"
target_set_id: entropy-qwen80next
blockers: []
verification: functional-cli
test_level: functional-cli
functional_risk: narrow
hitl: false
expected_files:
  - path: runs/EB/EB-entropy-qwen80next-<timestamp>/
    op: create
    scope: "One reproducible EB run folder with metadata, critique, raw responses, token usage, and generated files."
  - path: docs/plans/2026-05-25-000-kb-eb-remaining-singlebox-runs-manifest.md
    op: edit
    scope: "Mark this slice status and record run folder/verification proof."
  - path: docs/plans/2026-05-25-008-verification-eb-target-entropy-qwen80next-plan.md
    op: edit
    scope: "Record status, run folder, and verification proof."
  - path: todo.md
    op: edit
    scope: "Sync live board status for this slice."
status: done
owner: agent
blocked_reason: ""
resume_when: ""
next_agent_action: "Run EB for entropy-qwen80next, report, commit, push."
human_action: ""
can_continue_other_slices: true
---

# Run EB Target Entropy Qwen80next

Run the three-workload EB baseline for `entropy-qwen80next` in `plain` harness mode.

## Acceptance Criteria

- EB run folder and critique are present.
- Generated-output failures are captured without repair; LLMCommune/model-serving recovery is allowed.
- Run is committed and pushed.

## Commands

```powershell
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$run = ".\runs\EB\EB-entropy-qwen80next-$stamp"
pwsh .\tools\run_entropy_serial_experiment.ps1 -ExperimentPath .\benchmarks\entropy_workloads\experiment.local-full-singlebox.json -OnlySet entropy-qwen80next -ResultRoot $run
pwsh .\tools\report_entropy_results.ps1 -ResultsPath "$run\results.jsonl" -Json
```

## Scope Boundary

No generated-output repair/extraction harness here. LLMCommune/model-serving recovery is allowed.

