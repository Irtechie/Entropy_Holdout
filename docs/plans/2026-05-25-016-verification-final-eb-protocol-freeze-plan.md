# Slice 001: Freeze Final EB Protocol

## Goal

Turn the epic into a run protocol that can survive imperfect results without restarting the whole experiment.

## Expected Files

| Path | Op | Scope |
|---|---|---|
| `docs/context/epics/final-eb-test-waves.md` | edit | Freeze rules, claims, gates, and quarantine policy. |
| `docs/context/research/benchmark-wave-design.md` | edit | Keep benchmark-design rationale linked to the protocol. |
| `todo.md` | edit | Point current work at this protocol. |
| `docs/context/PROJECT.md` | edit | Add epic/manifest pointers. |

## Verification

- Human-readable protocol lists harness modes and non-rerun policy.
- Claims are scoped to breakpoint behavior under staged dependency pressure.
- Quarantine beats rerun unless the whole wave becomes uninterpretable.

## Stop Conditions

- The protocol still allows validator/prompt changes after a wave starts.
- It does not say what to do with harness/spec failures.
- It cannot explain what the experiment is measuring.
