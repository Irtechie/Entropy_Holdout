---
kb_id: kb-2026-05-25-eb-remaining-singlebox-runs
slice_id: slice-001
title: "Run EB target entropy-gemma4-e4b"
target_set_id: entropy-gemma4-e4b
blockers: []
verification: functional-cli
test_level: functional-cli
functional_risk: narrow
hitl: false
expected_files:
  - path: runs/EB/EB-entropy-gemma4-e4b-<timestamp>/
    op: create
    scope: "One reproducible EB run folder with run.json, events.jsonl, results.jsonl, critique files, prompts, raw responses, token usage, and generated files."
  - path: docs/plans/2026-05-25-000-kb-eb-remaining-singlebox-runs-manifest.md
    op: edit
    scope: "Mark this slice status and record run folder/verification proof."
  - path: docs/plans/2026-05-25-001-verification-eb-target-entropy-gemma4-e4b-plan.md
    op: edit
    scope: "Record status, run folder, and verification proof."
  - path: todo.md
    op: edit
    scope: "Sync live board status for this slice."
status: done
owner: agent
blocked_reason: ""
resume_when: ""
next_agent_action: "Done. Continue with slice-002."
human_action: ""
can_continue_other_slices: true
run_folder: runs/EB/EB-entropy-gemma4-e4b-20260525-015024
verification_proof: "pwsh .\\tools\\report_entropy_results.ps1 -ResultsPath .\\runs\\EB\\EB-entropy-gemma4-e4b-20260525-015024\\results.jsonl -Json"
---

# Run EB Target Entropy Gemma4 E4B

Run the three-workload EB baseline for `entropy-gemma4-e4b` in `plain` harness mode.

## Acceptance Criteria

- `runs/EB/EB-entropy-gemma4-e4b-<timestamp>/run.json` records the target, controller, git head, command, and output paths.
- `results.jsonl`, `critique.md`, and `critique.json` exist and cover all attempted workloads.
- Prompt text, raw response text, raw API response JSON, token usage, and generated files are preserved under the run folder.
- Non-wedge model failures are committed as valid EB data, not repaired in the same run.
- The run folder and status updates are committed and pushed before the next target starts.

## Commands

```powershell
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$run = ".\runs\EB\EB-entropy-gemma4-e4b-$stamp"
pwsh .\tools\run_entropy_serial_experiment.ps1 -ExperimentPath .\benchmarks\entropy_workloads\experiment.local-full-singlebox.json -OnlySet entropy-gemma4-e4b -ResultRoot $run
pwsh .\tools\report_entropy_results.ps1 -ResultsPath "$run\results.jsonl" -Json
```

## Scope Boundary

Do not repair generated model output in this slice. LLMCommune/model-serving recovery is allowed when the target has not wedged the lane. Output repair belongs to Wave 2.

## Result

Run folder: `runs/EB/EB-entropy-gemma4-e4b-20260525-015024/`

Summary:

- `webpage-chain`: 5/5 generation stages passed, then final validation failed because `index.html` was missing title text.
- `library-chain`: reached 1/4, failed at `lib-002-dependent` due missing expected artifact path `library-chain/feature`.
- `factory`: failed at 0/4 due malformed JSON content.

This is a valid Wave 1 data point, not an LLMCommune wedge.
