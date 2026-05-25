# EB-LC Wave 0 Model-Repair Canary Judgment

Date: 2026-05-25

## Scope

This judges the three-target Wave 0 canary for the frozen final EB protocol.

Run folders:

- `runs/EB-LC/EB-LC-wave0-model-repair-entropy-gptoss20-20260525-163307/`
- `runs/EB-LC/EB-LC-wave0-model-repair-entropy-devstral-small2-20260525-164945/`
- `runs/EB-LC/EB-LC-wave0-model-repair-entropy-qwen80nextcoder-256k-20260525-170032/`

Harness:

- `model-repair`
- LangChain/Langfuse enabled
- Local no-spend gate passed before launch:
  - `pwsh .\tools\entropy_workload_check.ps1`
  - `pwsh .\tools\check_langchain_langfuse.ps1`
  - `pwsh .\tools\run_entropy_matrix.ps1 -Matrix .\benchmarks\entropy_workloads\matrix.default.json -ResultPath .\runs\entropy_matrix\final-gate-results.jsonl`

## Bottom Line

The benchmark is not dead. The canary produced real progress and at least one clean workload pass:

- `entropy-devstral-small2` fully passed `webpage-chain` 5/5 under `model-repair`.
- `entropy-devstral-small2` generated all library and factory stages, then failed final validation on semantic contract issues.
- `entropy-qwen80nextcoder-256k` reached `library-chain` stage 2 and `factory` stage 2 before harness-class null failures.
- `entropy-gptoss20` reached webpage stage 4 and factory stage 2, then failed on context budget / generation issues.

This proves there is a success path for medium-or-better models. It does not yet justify expanding to a full wave because the canary still has two harness-origin failures.

## Result Table

| Target | Context | Webpage | Library | Factory | Judgment |
|---|---:|---:|---:|---:|---|
| `entropy-devstral-small2` | 131072 | 5/5 pass | 4/4 stages, final validation fail | 4/4 stages, final validation fail | Strongest canary result. Proves the protocol can produce a clean workload pass. |
| `entropy-qwen80nextcoder-256k` | 262144 | 5/5 stages, final validation fail | 2/4, harness fail | 2/4, harness fail | Useful but contaminated by harness null failures. |
| `entropy-gptoss20` | 131072 | 4/5, context budget fail | 0/4, JSON failure | 2/4, JSON failure | Useful negative/control result; not a harness green light. |

## Failure Origin Audit

Audit: `docs/reports/EB-LC-wave0-model-repair-canary-failure-origin-audit.md`

| Origin | Count |
|---|---:|
| model_or_entropy | 5 |
| harness | 2 |
| context_budget | 1 |

Expansion is blocked by the two `harness` rows:

- `entropy-qwen80nextcoder-256k` / `library-chain` / `lib-003-chain`
- `entropy-qwen80nextcoder-256k` / `factory` / `factory-003-configuration`

Both failed with:

```text
You cannot call a method on a null-valued expression.
```

## Interpretation

Supported:

- Medium-or-better models can pass at least one frozen EB workload.
- `model-repair` improves enough over plain mode to expose deeper library/factory behavior for some targets.
- The canary is useful: it separated a strong pass path, model/contract failures, context-budget failure, and harness failures.

Not supported yet:

- Expanding directly to a full final wave.
- Treating Qwen Coder's library/factory failures as model failures.
- Claiming library-chain or factory are fully solved under `model-repair`.

## Next Gate

Before the pilot:

1. Diagnose and fix or explicitly quarantine the null-valued harness path.
2. Re-run only the contaminated Qwen Coder canary rows if the fix changes harness behavior.
3. Keep `entropy-devstral-small2` as the current proof that the benchmark can pass.
4. Prefer a curated target set over every available model. Drop models that are too small to be plausible coding agents unless the claim explicitly needs the lower bound.
