---
name: eb-wave-runner
description: Run Entropy Benchmark (EB) waves with first-principles failure discipline and durable evidence export. Use when the user asks to run, queue, slice, audit, compare, resume, export telemetry, or report EB benchmark waves; when running Wave 1/Wave 2/later model sweeps; when deciding whether a benchmark failure is a valid model/entropy failure versus infrastructure, serving, context-budget, prompt/spec, validator, or harness contamination; or when preparing reproducible EB run folders, Langfuse exports, and critique artifacts.
---

# EB Wave Runner

## Prime Directive

Preserve the experiment. Do not report "the model failed" unless the run gave the model the intended contract, the serving path worked, the request fit the available context, and the validator matched the prompt.

Separate these origins on every failed target/workload:

- `model_or_entropy`: the model received a fair contract and still produced bad/missing/wrong code.
- `infra_or_serving`: activation, model load, controller state, timeout, empty response, API shape, or host failure.
- `context_budget`: request exceeded the actual served context or token budget.
- `prompt_spec_or_validator`: prompt allowed outputs the validator rejects, or omitted exact required paths, language, framework, names, literals, or behavior.
- `harness`: runner/extractor/validator bug, bad result aggregation, or an unhandled tool failure.
- `needs_manual_review`: evidence is insufficient to classify.

Infrastructure recovery is allowed. Generated-output repair is only allowed when the wave's named harness mode explicitly includes it.

## Before A Wave

1. Confirm a clean baseline:
   - `git status --short --branch`
   - current branch and pushed state
   - experiment JSON, queue JSON, and run prefix
2. Check prompt-validator parity before running models:
   - Exact file paths required by validators appear in prompts.
   - Exact languages/frameworks/project names required by validators appear in prompts.
   - Exact literal strings/titles/routes/sample outputs required by validators appear in prompts.
3. Check context feasibility:
   - Compare expected prompt growth against each target's actual served context.
   - Do not count context overflow as model failure.
   - Canonical waves must declare `min_context_tokens`; default final-wave floor is 32768 unless a target is explicitly marked as a low-context diagnostic/control.
4. Check serving token budget:
   - Canonical waves must declare `max_completion_tokens`, `min_completion_tokens`, and `min_completion_chars`.
   - `max_completion_tokens` must be large enough for the workload contract, normally 4096 for the current EB staged code workloads.
   - A failed response with tiny completion usage, length finish reason, missing canonical token usage, or a configured cap below the declared minimum is infrastructure/serving contamination, not a model failure.
5. Define commit boundaries:
   - one run folder per target unless the user explicitly asks for grouped runs
   - commit/push each completed target if requested
6. State the failure-origin policy in the wave plan or handoff before launch.
7. Pick the wave-specific skill:
   - Wave 1 plain baseline: use `eb-wave-1-plain`.
   - Wave 2 repair/extract: use `eb-wave-2-repair-extract`.
   - Later waves: create a new `eb-wave-N-name` skill before running the first target.
8. Define the harness artifact:
   - The harness must be reproducible from GitHub.
   - Save wave-specific experiment config, queue config, runner behavior, prompts, validators, and reporting/audit commands.
   - A third party should be able to clone the repo, replace only the model-serving backend or harness under test, and rerun the same wave.

## During A Wave

For each target:

- Treat activation cooldown/retry as infrastructure handling, not benchmark intervention.
- Stop or classify as infrastructure if the controller wedges, model does not load, API returns no usable choice, or the request exceeds context.
- Stop or classify as infrastructure if the serving path silently caps completions below the declared budget. A 32-token completion on these code-generation tasks is an invalid serving/configuration datapoint unless the stage already passed from valid existing artifacts.
- Keep raw prompts, raw response text, raw API JSON, generated files, token usage, events, critique, and queue status.
- Never edit generated artifacts manually and count the result as model output.
- If a repair harness is active, record every repair prompt/response and token usage.
- LangChain may wrap the LLM workflow for structure and tracing only when it is behavior-pass-through: same prompt bytes, same model endpoint/options, same call count, same raw response, no memory injection, no output parsing/fixing, no retry, no fallback, no tool call, and no hidden prompt template change.
- Langfuse may capture traces, metrics, token usage, timing, prompts, raw responses, run sections, and screenshots as instrumentation.
- Playwright may copy or screenshot rendered artifacts for evidence as instrumentation.
- If any observability layer changes prompts, retries, extraction, memory, tool use, routing, or output repair, it is part of the harness and requires a new wave/harness id.
- Treat Langfuse trace IDs as join keys, not complete evidence. For canonical EB-LC runs, export Langfuse trace payloads into the run folder before final claims.

## After A Wave

Before summarizing results:

1. Audit every first failure by target/workload.
2. Assign `failure_origin`.
3. Mark contaminated outcomes separately from valid entropy failures.
4. Export Langfuse traces for every completed EB-LC run:
   - `pwsh .\tools\export_eb_langfuse_traces.ps1`
   - use `-RunRoot <path>` for one target folder
   - outputs must include `langfuse/manifest.json`, `langfuse/summary.json`, `langfuse/summary.jsonl`, and `langfuse/traces/*.json`
5. Verify trace coverage:
   - model-call rows with `langfuse_trace_id` should have matching `langfuse/traces/<trace_id>.json`
   - validation-only rows may have no trace because no model call occurred
   - missing traces on model-call rows are observability contamination, not model failure
6. Report counts by origin and list contaminated target/workloads.
7. Avoid overclaiming: a completed data run is not necessarily a clean benchmark datapoint.
8. Recommend reruns only for contaminated outcomes unless the user asks for a full rerun.

If the repo has `tools/write_eb_failure_origin_audit.ps1`, use it to generate markdown and JSON audit artifacts before giving a final wave summary.

Commit or clearly stage the complete wave harness before broad execution. Results without the exact harness and telemetry export are diagnostics, not reproducible benchmark evidence.

## Reporting Language

Use precise wording:

- Good: "19 targets completed as data runs; 14 target/workload failures are clean model/entropy failures, 22 are infra/context contaminated."
- Bad: "Wave passed" or "the models failed" without origin counts.

Call out bad-test failures directly. The point of EB is to measure the model/harness breakpoint, not to launder runner mistakes into model scores.
