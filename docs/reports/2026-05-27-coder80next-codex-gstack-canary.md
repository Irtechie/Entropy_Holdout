# Coder80Next Codex / GStack Corrected Canary

Date: 2026-05-27

## Scope

Status: `failed_model_harness_incomplete`

This is the first corrected Codex-host GStack canary after nulling the Claude-hosted rows.
It is scoreable as a failed Codex/GStack/Coder80Next canary because the host and model plumbing
were valid and no artificial token, completion, step, or model-budget cap was imposed.

Run root:

`runs/harness-bakeoff/gstack-codex-coder80next-wave1-report-only-20260527-212829`

Configuration:

- Host: `codex-cli 0.133.0`
- Harness: GStack Codex skills, version `1.48.0.0`
- GStack source commit: `a6fb31726cece1d1bba401fde593db7cb96bc738`
- Model target: `entropy-qwen80nextcoder-256k`
- Model id: `Qwen3-Coder-Next-Q4_K_M.gguf`
- Endpoint: `http://192.168.1.203:8000/v1`
- Provider wire protocol: `responses`
- Context: 262144 advertised model context tokens
- Artificial budget caps: none
- Subagents: disabled for the first corrected canary

Codex was launched with the desktop-only non-function tools disabled:

- `web_search="disabled"`
- `--disable image_generation`
- `--disable multi_agent`

That was required because LLMCommune's Responses endpoint accepts plain function tools but
rejects Codex Desktop tool types such as `namespace`, `web_search`, and `image_generation`.

## Outcome

The canary failed before completing the workload set.

Observed Codex usage:

- `input_tokens`: 569813 cumulative observed Codex usage
- `output_tokens`: 3815
- `reasoning_output_tokens`: 0
- Exit code: 0
- Duration: 170 seconds

What completed:

- Read the three workload specs.
- Loaded `office-hours` and `autoplan` skill bodies.
- Generated five HTML files under `site/`.

What did not complete:

- Did not finish `library-chain`.
- Did not start `factory-system`.
- Did not create `HARNESS_EVIDENCE.md`.
- Did not create `IMPLEMENTATION_SUMMARY.md`.
- Did not run validators.
- Did not commit the workspace.

Independent validator state after the run:

| Workload | Result | Evidence |
|---|---|---|
| `webpage-chain` | fail | `index.html` is missing the shared nested table required on all pages |
| `library-chain` | fail | missing `library-chain/` directory |
| `factory` | fail | missing `factory-system/` directory |

## Judgment

This is not an infrastructure null. Codex successfully talked to the local Coder80Next endpoint
through LLMCommune's Responses API after non-function desktop tools were disabled.

The failure is the model/harness interaction:

- Full GStack skill-body loading pushed cumulative observed Codex input usage to 569813 tokens, creating severe context pressure for a 262144-context local target.
- The model still continued, but it stopped after a partial webpage implementation and returned a normal final message.
- The model marked `autoplan` complete without producing a real autoplan gate output.
- The model attempted to run a nonexistent `gstack office-hours` binary after reading the skill body.

Classification: `failed_model_harness_incomplete`, with harness-use deviations recorded.

## Implication

Do not run broad GStack bakeoff rows against local 256k models using full `office-hours` plus full
`autoplan` bodies for the EB three-workload canary. It measures context overload and skill-port friction
more than coding ability.

Next corrected options:

1. Run a lean GStack invocation card that uses only the relevant GStack discipline/checklists, not full
   `office-hours` plus full `autoplan` skill bodies.
2. Treat full GStack `autoplan` as a high-context harness condition for larger-context/frontier models only.
3. For Coder80Next, run the same Codex-local setup with a lighter harness such as ATV-generic or a plain Codex
   baseline before spending more time on GStack.
