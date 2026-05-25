---
type: kb-manifest
kb_id: kb-2026-05-25-final-eb-test-waves
brainstorm_path: docs/context/epics/final-eb-test-waves.md
created: 2026-05-25
status: active
slices:
  - id: slice-001
    title: "Freeze final EB protocol"
    path: docs/plans/2026-05-25-016-verification-final-eb-protocol-freeze-plan.md
    blockers: []
    verification: verification-only
    test_level: none
    functional_risk: narrow
    hitl: true
    status: done
    owner: agent
    blocked_reason: ""
    resume_when: ""
    next_agent_action: "Done. Continue with local no-spend gate."
    human_action: ""
    can_continue_other_slices: false
    notes: ""
  - id: slice-002
    title: "Pass local no-spend gate"
    path: docs/plans/2026-05-25-017-integration-final-eb-local-gate-plan.md
    blockers: [slice-001]
    verification: integration
    test_level: functional-cli
    functional_risk: broad
    hitl: false
    status: done
    owner: agent
    blocked_reason: ""
    resume_when: ""
    next_agent_action: "Done. Continue with Wave 0 canary."
    human_action: ""
    can_continue_other_slices: false
    notes: "Passed entropy_workload_check, Langfuse preflight, and mock matrix. Aligned library/factory expected artifacts and renamed current repair behavior as model-repair."
  - id: slice-003
    title: "Run and judge three-target Wave 0 canary"
    path: docs/plans/2026-05-25-018-functional-final-eb-wave0-canary-plan.md
    blockers: [slice-002]
    verification: functional-cli
    test_level: functional-cli
    functional_risk: broad
    hitl: true
    status: done
    owner: agent
    blocked_reason: ""
    resume_when: ""
    next_agent_action: "Done. Diagnose harness-null blocker before pilot expansion."
    human_action: "Review canary judgment and decide whether to fix/quarantine Qwen Coder harness-null rows before pilot."
    can_continue_other_slices: false
    notes: "Canary completed and pushed for gptoss20, devstral-small2, and qwen80nextcoder-256k. Devstral passed webpage 5/5; expansion blocked by two Qwen Coder harness-null rows."
  - id: slice-004
    title: "Run pilot then final full wave"
    path: docs/plans/2026-05-25-019-functional-final-eb-pilot-full-wave-plan.md
    blockers: [slice-003]
    verification: functional-cli
    test_level: functional-cli
    functional_risk: full
    hitl: true
    status: blocked
    owner: agent
    blocked_reason: "Blocked until Wave 0 canary is judged."
    resume_when: "Wave 0 judgment says expansion is valid."
    next_agent_action: "Design the next wave only after canary evidence is reviewed."
    human_action: "Approve pilot and final target set."
    can_continue_other_slices: false
    notes: ""
---

# KB: Final EB Test Waves

## Origin

Epic: `docs/context/epics/final-eb-test-waves.md`
Research: `docs/context/research/benchmark-wave-design.md`

## Operating Rule

This is a protocol-freeze plan, not an open-ended benchmark-improvement plan. After slice 001 and slice 002 pass, later defects are quarantined or reported unless they make the wave uninterpretable.

## Slice Overview

| # | Slice | Blocked By | Verification | HITL | Status |
|---|---|---|---|---|---|
| 1 | Freeze final EB protocol | - | verification-only | yes | done |
| 2 | Pass local no-spend gate | 1 | integration | no | done |
| 3 | Run and judge three-target Wave 0 canary | 2 | functional-cli | yes | done |
| 4 | Run pilot then final full wave | 3 | functional-cli | yes | blocked |

## Done Means

- The final wave is run under a frozen protocol.
- Every run folder has required artifacts and trace export.
- Every failure has an origin classification.
- The final report can be shared without rerunning the suite to explain avoidable harness/spec mistakes.
