---
kb_id: kb-2026-05-25-eb-remaining-singlebox-runs
slice_id: slice-015
title: "Run EB target entropy-minimax-m27"
target_set_id: entropy-minimax-m27
blockers: []
verification: functional-cli
test_level: functional-cli
functional_risk: narrow
hitl: false
expected_files:
  - path: runs/EB/EB-entropy-minimax-m27-<timestamp>/
    op: create
    scope: "One reproducible EB run folder with metadata, critique, raw responses, token usage, and generated files."
  - path: docs/plans/2026-05-25-000-kb-eb-remaining-singlebox-runs-manifest.md
    op: edit
    scope: "Mark this slice status and record run folder/verification proof."
  - path: docs/plans/2026-05-25-015-verification-eb-target-entropy-minimax-m27-plan.md
    op: edit
    scope: "Record status, run folder, and verification proof."
  - path: todo.md
    op: edit
    scope: "Sync live board status for this slice."
status: pending
owner: agent
blocked_reason: ""
resume_when: ""
next_agent_action: "Run EB for entropy-minimax-m27, report, commit, push."
human_action: ""
can_continue_other_slices: true
---

# Run EB Target Entropy MiniMax M27

Run the three-workload EB baseline for `entropy-minimax-m27` in `plain` harness mode. This target is known to be conservative because earlier full-context MiniMax attempts could stress the DGX lane.

## Acceptance Criteria

- EB folder is complete if the target runs.
- If activation indicates wedge risk, mark this slice blocked and do not keep retrying.
- If the model responds but fails generation, commit the failure as valid EB data.

## Commands

```powershell
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$run = ".\runs\EB\EB-entropy-minimax-m27-$stamp"
pwsh .\tools\run_entropy_serial_experiment.ps1 -ExperimentPath .\benchmarks\entropy_workloads\experiment.local-full-singlebox.json -OnlySet entropy-minimax-m27 -ResultRoot $run
pwsh .\tools\report_entropy_results.ps1 -ResultsPath "$run\results.jsonl" -Json
```

## Scope Boundary

Do not repair generated output. LLMCommune/model-serving recovery is allowed, but do not repeatedly retry if this target shows wedge behavior.

