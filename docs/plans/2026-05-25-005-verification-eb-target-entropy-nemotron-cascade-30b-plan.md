---
kb_id: kb-2026-05-25-eb-remaining-singlebox-runs
slice_id: slice-005
title: "Run EB target entropy-nemotron-cascade-30b"
target_set_id: entropy-nemotron-cascade-30b
blockers: []
verification: functional-cli
test_level: functional-cli
functional_risk: narrow
hitl: false
expected_files:
  - path: runs/EB/EB-entropy-nemotron-cascade-30b-<timestamp>/
    op: create
    scope: "One reproducible EB run folder with metadata, critique, raw responses, token usage, and generated files."
  - path: docs/plans/2026-05-25-000-kb-eb-remaining-singlebox-runs-manifest.md
    op: edit
    scope: "Mark this slice status and record run folder/verification proof."
  - path: docs/plans/2026-05-25-005-verification-eb-target-entropy-nemotron-cascade-30b-plan.md
    op: edit
    scope: "Record status, run folder, and verification proof."
  - path: todo.md
    op: edit
    scope: "Sync live board status for this slice."
status: pending
owner: agent
blocked_reason: ""
resume_when: ""
next_agent_action: "Run EB for entropy-nemotron-cascade-30b, report, commit, push."
human_action: ""
can_continue_other_slices: true
---

# Run EB Target Entropy Nemotron Cascade 30B

Run the three-workload EB baseline for `entropy-nemotron-cascade-30b` in `plain` harness mode.

## Acceptance Criteria

- EB artifacts are present and reproducible.
- Critique and JSON report identify first failure class or full pass.
- Non-wedge failures are committed as data.
- Commit and push finish before continuing.

## Commands

```powershell
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$run = ".\runs\EB\EB-entropy-nemotron-cascade-30b-$stamp"
pwsh .\tools\run_entropy_serial_experiment.ps1 -ExperimentPath .\benchmarks\entropy_workloads\experiment.local-full-singlebox.json -OnlySet entropy-nemotron-cascade-30b -ResultRoot $run
pwsh .\tools\report_entropy_results.ps1 -ResultsPath "$run\results.jsonl" -Json
```

## Scope Boundary

No generated-output repair/extraction pass in Wave 2. LLMCommune/model-serving recovery is allowed.

