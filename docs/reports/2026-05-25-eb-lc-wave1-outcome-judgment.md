# EB-LC Wave 1 Outcome Judgment

Date: 2026-05-25

## Scope

This judges the canonical LangChain/Langfuse pass-through Wave 1 baseline under `runs/EB-LC/`.

Canonical scoring excludes the contaminated first MiniMax folder:

- Excluded: `runs/EB-LC/EB-LC-wave1-plain-entropy-minimax-m27-20260525-152457/`
- Included replacement: `runs/EB-LC/EB-LC-wave1-plain-entropy-minimax-m27-20260525-153529/`

Reason: the excluded MiniMax run had a Windows console encoding failure in `tools/langchain_completion.py` that was fixed before the replacement run. The excluded folder remains useful as contamination evidence, not model evidence.

Evidence sources:

- `results.jsonl`, `critique.json`, and `report.json` in each canonical run folder.
- `langfuse/` exports committed under each EB-LC run folder.
- `pwsh .\tools\export_eb_langfuse_traces.ps1 -Force` completed with zero export errors.

## Bottom Line

Plain EB-LC is a credible baseline for the webpage-chain workload. It is not yet a strong baseline for library-chain or factory claims because those workloads mostly fail at the output-contract boundary before deep dependency behavior can be evaluated.

The strongest result is narrow: five targets fully validate webpage-chain 5/5 under the pass-through LangChain/Langfuse harness.

The broad result is negative: no target fully validates library-chain or factory under plain EB-LC. Library-chain is especially brittle, with 18 of 19 targets failing at stage 1 and only `entropy-smollm3-3b` reaching stage 2.

## Workload Judgment

| Workload | Targets | Fully Validated | Best Pass Depth | Best Score | Average Score | Judgment |
|---|---:|---:|---:|---:|---:|---|
| webpage-chain | 19 | 5 | 5/5 | 5/5 | 2.89/5 | Usable signal. Shows real multi-stage continuity for a subset of targets. |
| library-chain | 19 | 0 | 1/4 | 1/5 | 0.05/5 | Mostly output-contract failure. Not enough signal for model ranking beyond "plain mode fails here." |
| factory | 19 | 0 | 1/4 | 1/5 | 0.58/5 | Weak signal. Some targets create the first artifact, but none sustain the system build. |

## Target Scores

Scores are summed from per-workload EB scores. Each workload is scored 0-5 by `critique.json`, so total possible score is 15.

| Target | Ctx | Web | Lib | Factory | Total | Validated Workloads |
|---|---:|---:|---:|---:|---:|---:|
| entropy-devstral-small2 | 131072 | 5/5 | 0/5 | 1/5 | 6/15 | 1 |
| entropy-gemma4-e2b | 262144 | 5/5 | 0/5 | 1/5 | 6/15 | 1 |
| entropy-gemma4-e4b | 262144 | 5/5 | 0/5 | 1/5 | 6/15 | 1 |
| entropy-gptoss20 | 131072 | 5/5 | 0/5 | 1/5 | 6/15 | 1 |
| entropy-qwen35-122b | 65536 | 5/5 | 0/5 | 0/5 | 5/15 | 1 |
| entropy-qwen80next | 131072 | 4/5 | 0/5 | 1/5 | 5/15 | 0 |
| entropy-qwen80nextcoder | 131072 | 4/5 | 0/5 | 1/5 | 5/15 | 0 |
| entropy-qwen80nextcoder-256k | 262144 | 4/5 | 0/5 | 1/5 | 5/15 | 0 |
| entropy-gptoss120 | 65536 | 3/5 | 0/5 | 1/5 | 4/15 | 0 |
| entropy-nemotron3-super-120b | 65536 | 3/5 | 0/5 | 1/5 | 4/15 | 0 |
| entropy-gemma431 | 262144 | 3/5 | 0/5 | 0/5 | 3/15 | 0 |
| entropy-minimax-m27 | 16384 | 3/5 | 0/5 | 0/5 | 3/15 | 0 |
| entropy-nemotron-cascade-30b | 131072 | 2/5 | 0/5 | 0/5 | 2/15 | 0 |
| entropy-nemotron120 | 65536 | 1/5 | 0/5 | 1/5 | 2/15 | 0 |
| entropy-qwen36 | 262144 | 2/5 | 0/5 | 0/5 | 2/15 | 0 |
| entropy-smollm3-3b | 262144 | 1/5 | 1/5 | 0/5 | 2/15 | 0 |
| entropy-qwen25-coder-05b-large | 262144 | 0/5 | 0/5 | 1/5 | 1/15 | 0 |
| entropy-granite-code-3b | 262144 | 0/5 | 0/5 | 0/5 | 0/15 | 0 |
| entropy-qwen35-4b | 262144 | 0/5 | 0/5 | 0/5 | 0/15 | 0 |

## Winners and Read

Top plain EB-LC targets by total score:

- `entropy-devstral-small2`, `entropy-gemma4-e2b`, `entropy-gemma4-e4b`, and `entropy-gptoss20`: tied at 6/15, each with full webpage validation and first-stage factory progress.
- `entropy-qwen35-122b`: 5/15, with full webpage validation but no library/factory progress.
- `entropy-qwen80next`, `entropy-qwen80nextcoder`, and `entropy-qwen80nextcoder-256k`: 5/15, with all webpage generation stages passed but final validation failing on missing artifact.

Interpretation:

- Larger context alone did not guarantee better total score. The 262K targets include both top performers and zero-score failures.
- Webpage-chain rewards page/state continuity and is the only workload where plain mode exposes meaningful separation.
- Library-chain and factory expose a plain-harness output-contract problem more than model capability. They need a repair/extract or file-carry harness mode before claiming deeper model ranking.

## Failure Quality

Canonical failure-class counts:

| Workload | Failure Class | Count |
|---|---|---:|
| webpage-chain | none | 5 |
| webpage-chain | missing_artifact | 3 |
| webpage-chain | generation | 11 |
| library-chain | generation | 19 |
| factory | generation | 15 |
| factory | harness | 4 |

The four factory harness failures are all at `factory-002-stations` after a first-stage pass, with `You cannot call a method on a null-valued expression.` They affect:

- `entropy-nemotron120`
- `entropy-nemotron3-super-120b`
- `entropy-qwen80nextcoder`
- `entropy-qwen80nextcoder-256k`

Those should be marked as contaminated for factory scoring until the null handling is diagnosed. They are not evidence that the models failed stage 2.

MiniMax replacement run judgment:

- Webpage: passed stages 1-4, then failed stage 5 because the prompt exceeded the 16K context limit.
- Library/factory: failed on malformed JSON, not harness encoding.
- This is a valid benchmark outcome after the adapter fix.

## Claims Allowed

Supported:

- EB-LC Wave 1 completed for all 19 single-box targets with Langfuse trace exports.
- Five targets fully validated webpage-chain under plain pass-through LangChain/Langfuse.
- Plain EB-LC does not solve library-chain or factory for any target in this wave.
- The strongest plain-baseline performers are tied at 6/15, but that score is driven almost entirely by webpage-chain.

Not supported yet:

- Any claim that a model can complete the full three-workload EB suite under plain mode.
- Any strong model-ranking claim from library-chain or factory results.
- Any factory-stage-2 model-failure claim for the four harness-contaminated factory rows.

## Next Judgment Work

1. Build a comparison table against archived direct-run Wave 1 and Wave 2 repair-extract runs.
2. Separate model failures from harness failures in factory before scoring right-shift deltas.
3. Run or analyze a repair/extract EB-LC wave if the paper claim needs library/factory model ranking instead of plain-mode failure characterization.
