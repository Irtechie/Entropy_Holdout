# Benchmark Wave Design

Checked: 2026-05-25
Budget mode: standard

## Question

How should the next Entropy Benchmark waves be designed so they produce usable model/harness evidence without repeatedly spending operator time and model-fleet availability on runs that later turn out to be underspecified, harness-contaminated, or impossible to interpret?

## Findings

1. Treat harness qualification as a separate phase from model evaluation. SWE-bench's public harness documentation emphasizes reproducible execution environments, logs, gold-patch verification, and explicit grading. For Entropy, that means a wave is not ready for model spend until local fixtures prove the workload spec, prompt contract, artifact assertions, validators, critique writer, Langfuse export, and failure-origin audit agree with each other.

2. Task quality has to be audited before scoring. OpenAI's SWE-bench Verified work is directly relevant: their review found many original benchmark samples were underspecified, had tests that could reject valid solutions, or had setup failures independent of solution quality. The local Entropy evidence has the same class of risk: `library-chain` currently has an expected-artifact mismatch between `workloads.json` and `library_chain.json`, and four Wave 1 factory rows hit a harness null-method error.

3. A benchmark can measure the harness instead of the model if output recovery is not explicit. Current `repair-extract` behavior in `tools/run_entropy_workload.ps1` is model-reprompt repair after a parse/artifact failure. It is not a deterministic extractor. That may be a valid harness mode, but it must be named and scored as model-assisted repair, not as deterministic file extraction.

4. Canary waves should gate full waves. LiveCodeBench's repository supports reusing existing outputs/evaluations and has a faster lite configuration; the general lesson for Entropy is to run a small but capable representative canary before expanding. The canary should not be made of the weakest models, because that only proves weak models fail. A final all-target wave should only run after the local gate and canary pass their stop conditions.

5. Interpretability requires failure-origin auditing, not just pass depth. The existing `tools/write_eb_failure_origin_audit.ps1` is the right direction, but it needs to become a required gate. Any `harness`, `prompt_spec_or_validator`, missing trace export, or ambiguous failure-origin row blocks expansion to the next model wave.

## Sources

- SWE-bench original paper: https://arxiv.org/abs/2310.06770
- SWE-bench evaluation harness reference: https://www.swebench.com/SWE-bench/reference/harness/
- SWE-bench Verified overview: https://www.swebench.com/verified.html
- OpenAI SWE-bench Verified methodology: https://openai.com/index/introducing-swe-bench-verified/
- LiveCodeBench ICLR 2025 abstract: https://proceedings.iclr.cc/paper_files/paper/2025/hash/94074dd5a072d28ff75a76dabed43767-Abstract-Conference.html
- LiveCodeBench repository evaluation notes: https://github.com/livecodebench/livecodebench

## Applies When

- Designing EB/EB-LC benchmark waves.
- Deciding whether a result supports a model-capability claim.
- Deciding whether a failed run should be counted, quarantined, or rerun.
- Adding a new harness mode such as `repair-extract`, deterministic extraction, `file-carry`, or `entropy`.

## Stale When

- Workloads are replaced with a different benchmark family.
- The harness no longer uses staged JSON file generation.
- A later audit proves `workloads.json`, workload specs, validators, and reports are aligned by automated golden fixtures.
- The external benchmark methodology materially changes and invalidates the cited lessons.

## Rejected Approaches

- Running another all-target wave before local contract alignment. This repeats the known failure mode: expensive data that later needs to be partially quarantined.
- Calling the current `repair-extract` final without qualification. It is model-assisted repair, not deterministic extraction.
- Scoring `factory-002-stations` null-method failures as model failures before the harness path is reproduced and fixed.
- Using average score alone. It hides whether the score came from model behavior, output contract failure, harness defects, context budget, or infrastructure.

## Impact On Current Project

The next wave is blocked on a no-spend gate. After that gate passes, the protocol should freeze. Later surprises should usually become quarantines or report caveats, not whole-wave restarts.

1. Fix or explicitly adjudicate `library-chain` expected-artifact paths.
2. Reproduce and diagnose the factory null-method failure class.
3. Define harness modes precisely, especially `repair-extract`.
4. Add golden fixtures or equivalent deterministic local checks for all three workloads.
5. Require a canary with Langfuse export and failure-origin audit before any full-target run.
