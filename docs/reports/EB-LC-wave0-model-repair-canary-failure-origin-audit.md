# EB-LC-wave0-model-repair-canary Failure Origin Audit

- Generated: 2026-05-25T17:10:39.3151738-04:00
- Run glob: `EB-LC-wave0-model-repair-*`
- Run count: 3
- Failure rows audited: 8
- Audit JSON: `E:\Dev\AI\remote\Entropy\docs\reports\EB-LC-wave0-model-repair-canary-failure-origin-audit.json`

## Origin Counts

| Origin | Count |
|---|---:|
| context_budget | 1 |
| harness | 2 |
| model_or_entropy | 5 |

## First Failures

| Target | Workload | Stage | Class | Origin | Error |
|---|---|---|---|---|---|
| entropy-devstral-small2 | factory | final-validation | missing_artifact | model_or_entropy | factory validation failed: missing station id intake |
| entropy-devstral-small2 | library-chain | final-validation | missing_artifact | model_or_entropy | library-chain validation failed: project FeatureLib missing reference CoreLib/CoreLib.csproj |
| entropy-gptoss20 | factory | factory-003-configuration | generation | model_or_entropy | model did not return a JSON object |
| entropy-gptoss20 | library-chain | lib-001-core | generation | model_or_entropy | Conversion from JSON failed with error: Unexpected end when deserializing object. Path 'files[7]', line 34, position 5. |
| entropy-gptoss20 | webpage-chain | web-005-nested-shared-table | generation | context_budget | langchain adapter exited 1: Traceback (most recent call last):    File "E:\Dev\AI\remote\Entropy\tools\langchain_completion.py", line 184, in <module>      raise SystemExit(main())                       ^^^^^^    File... |
| entropy-qwen80nextcoder-256k | factory | factory-003-configuration | harness | harness | You cannot call a method on a null-valued expression. |
| entropy-qwen80nextcoder-256k | library-chain | lib-003-chain | harness | harness | You cannot call a method on a null-valued expression. |
| entropy-qwen80nextcoder-256k | webpage-chain | final-validation | missing_artifact | model_or_entropy | webpage-chain validation failed: page page-4.html shared nav is missing page-4.html |
