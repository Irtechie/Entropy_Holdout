---
kb_id: kb-2026-05-25-eb-remaining-singlebox-runs
slice_id: slice-002
title: "Run EB target entropy-qwen35-4b"
target_set_id: entropy-qwen35-4b
blockers: []
verification: functional-cli
test_level: functional-cli
functional_risk: narrow
hitl: false
expected_files:
  - path: runs/EB/EB-entropy-qwen35-4b-<timestamp>/
    op: create
    scope: "One reproducible EB run folder with run metadata, critique, raw responses, token usage, and generated files."
  - path: docs/plans/2026-05-25-000-kb-eb-remaining-singlebox-runs-manifest.md
    op: edit
    scope: "Mark this slice status and record run folder/verification proof."
  - path: docs/plans/2026-05-25-002-verification-eb-target-entropy-qwen35-4b-plan.md
    op: edit
    scope: "Record status, run folder, and verification proof."
  - path: todo.md
    op: edit
    scope: "Sync live board status for this slice."
status: done
owner: agent
blocked_reason: ""
resume_when: ""
next_agent_action: "Done. Continue with slice-003."
human_action: ""
can_continue_other_slices: true
run_folder: runs/EB/EB-entropy-qwen35-4b-20260525-015600
verification_proof: "pwsh .\\tools\\report_entropy_results.ps1 -ResultsPath .\\runs\\EB\\EB-entropy-qwen35-4b-20260525-015600\\results.jsonl -Json"
---

# Run EB Target Entropy Qwen35 4B

Run the three-workload EB baseline for `entropy-qwen35-4b` in `plain` harness mode.

## Acceptance Criteria

- Run folder contains `run.json`, `events.jsonl`, `results.jsonl`, `critique.md`, and `critique.json`.
- Prompts, raw responses, token usage, and generated files are retained.
- Non-wedge model failures are treated as valid EB data.
- Results are reported, committed, and pushed before moving on.

## Commands

```powershell
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$run = ".\runs\EB\EB-entropy-qwen35-4b-$stamp"
pwsh .\tools\run_entropy_serial_experiment.ps1 -ExperimentPath .\benchmarks\entropy_workloads\experiment.local-full-singlebox.json -OnlySet entropy-qwen35-4b -ResultRoot $run
pwsh .\tools\report_entropy_results.ps1 -ResultsPath "$run\results.jsonl" -Json
```

## Scope Boundary

Do not repair generated model output in the `plain` baseline. LLMCommune/model-serving recovery is allowed.

## Result

Run folder: `runs/EB/EB-entropy-qwen35-4b-20260525-015600/`

Summary:

- `webpage-chain`: 5/5 generation stages passed, then final validation failed because `index.html` was missing title text.
- `library-chain`: 4/4 generation stages passed, then final validation failed because `CoreLib/CoreLib.csproj` was missing.
- `factory`: reached 1/4, failed at `factory-002-stations` due missing expected artifact path `factory-system/stations`.

This is a valid Wave 1 plain-baseline data point, not an LLMCommune wedge.
