# EB-wave1-plain Failure Origin Audit

- Generated: 2026-05-25T10:51:49.1562320-04:00
- Run glob: `EB-entropy-*`
- Run count: 19
- Failure rows audited: 57
- Audit JSON: `E:\Dev\AI\remote\Entropy\docs\reports\EB-wave1-plain-failure-origin-audit.json`

## Origin Counts

| Origin | Count |
|---|---:|
| context_budget | 1 |
| infra_or_serving | 7 |
| model_or_entropy | 36 |
| prompt_spec_or_validator | 13 |

## First Failures

| Target | Workload | Stage | Class | Origin | Error |
|---|---|---|---|---|---|
| entropy-devstral-small2 | factory | final-validation | missing_artifact | model_or_entropy | factory validation failed: missing station id intake |
| entropy-devstral-small2 | library-chain | final-validation | missing_artifact | prompt_spec_or_validator | library-chain validation failed: missing project: CoreLib/CoreLib.csproj |
| entropy-devstral-small2 | webpage-chain | final-validation | missing_artifact | prompt_spec_or_validator | webpage-chain validation failed: page index.html is missing title text |
| entropy-gemma4-e2b | factory | factory-002-stations | generation | model_or_entropy | model did not generate expected artifact path: factory-system/stations |
| entropy-gemma4-e2b | library-chain | final-validation | missing_artifact | prompt_spec_or_validator | library-chain validation failed: missing project: CoreLib/CoreLib.csproj |
| entropy-gemma4-e2b | webpage-chain | web-005-nested-shared-table | generation | model_or_entropy | model did not generate expected artifact path: site/page-5.html |
| entropy-gemma4-e4b | factory | factory-001-layout | generation | model_or_entropy | Conversion from JSON failed with error: After parsing a value an unexpected character was encountered: \. Path 'files[4].content', line 21, position 1238. |
| entropy-gemma4-e4b | library-chain | lib-002-dependent | generation | model_or_entropy | model did not generate expected artifact path: library-chain/feature |
| entropy-gemma4-e4b | webpage-chain | final-validation | missing_artifact | prompt_spec_or_validator | webpage-chain validation failed: page index.html is missing title text |
| entropy-gemma431 | factory | factory-002-stations | harness | infra_or_serving | model response did not include choices text |
| entropy-gemma431 | library-chain | lib-002-dependent | harness | infra_or_serving | model response did not include choices text |
| entropy-gemma431 | webpage-chain | web-005-nested-shared-table | generation | model_or_entropy | Conversion from JSON failed with error: Invalid property identifier character: \. Path 'files', line 23, position 4. |
| entropy-gptoss120 | factory | factory-002-stations | generation | model_or_entropy | model did not generate expected artifact path: factory-system/stations |
| entropy-gptoss120 | library-chain | final-validation | missing_artifact | prompt_spec_or_validator | library-chain validation failed: missing project: CoreLib/CoreLib.csproj |
| entropy-gptoss120 | webpage-chain | web-005-nested-shared-table | generation | model_or_entropy | Conversion from JSON failed with error: Unexpected end when deserializing object. Path 'files[1]', line 10, position 5. |
| entropy-gptoss20 | factory | factory-003-configuration | generation | model_or_entropy | model did not generate expected artifact path: factory-system/config |
| entropy-gptoss20 | library-chain | lib-002-dependent | generation | model_or_entropy | model did not generate expected artifact path: library-chain/feature |
| entropy-gptoss20 | webpage-chain | final-validation | missing_artifact | prompt_spec_or_validator | webpage-chain validation failed: page index.html is missing title text |
| entropy-granite-code-3b | factory | factory-001-layout | generation | model_or_entropy | model did not return a JSON object |
| entropy-granite-code-3b | library-chain | lib-001-core | generation | model_or_entropy | model did not return a JSON object |
| entropy-granite-code-3b | webpage-chain | web-001-home | generation | model_or_entropy | model did not return a JSON object |
| entropy-minimax-m27 | factory | factory-001-layout | generation | model_or_entropy | Conversion from JSON failed with error: Additional text encountered after finished reading JSON content: `. Path '', line 34, position 0. |
| entropy-minimax-m27 | library-chain | lib-003-chain | generation | model_or_entropy | Conversion from JSON failed with error: Invalid JavaScript property identifier character: }. Path '', line 1, position 5. |
| entropy-minimax-m27 | webpage-chain | web-005-nested-shared-table | harness | context_budget | HTTP 400 posting http://192.168.1.203:8000/v1/completions body={"error":{"code":400,"message":"request (26774 tokens) exceeds the available context size (16384 tokens), try increasing it","type":"exceed_context_size_e... |
| entropy-nemotron-cascade-30b | factory | factory-002-stations | generation | model_or_entropy | model did not generate expected artifact path: factory-system/stations |
| entropy-nemotron-cascade-30b | library-chain | lib-001-core | harness | infra_or_serving | model response did not include choices text |
| entropy-nemotron-cascade-30b | webpage-chain | web-001-home | harness | infra_or_serving | model response did not include choices text |
| entropy-nemotron120 | factory | final-validation | missing_artifact | model_or_entropy | factory validation failed: missing station id intake |
| entropy-nemotron120 | library-chain | lib-003-chain | generation | model_or_entropy | model did not generate expected artifact path: library-chain/pipeline |
| entropy-nemotron120 | webpage-chain | web-005-nested-shared-table | generation | model_or_entropy | Conversion from JSON failed with error: Unexpected end when deserializing object. Path 'files[0]', line 6, position 5. |
| entropy-nemotron3-super-120b | factory | factory-002-stations | generation | model_or_entropy | model did not generate expected artifact path: factory-system/stations |
| entropy-nemotron3-super-120b | library-chain | lib-002-dependent | generation | model_or_entropy | Conversion from JSON failed with error: Unexpected end when deserializing object. Path 'files[2]', line 14, position 5. |
| entropy-nemotron3-super-120b | webpage-chain | web-005-nested-shared-table | harness | infra_or_serving | model response did not include choices text |
| entropy-qwen25-coder-05b-large | factory | factory-001-layout | generation | model_or_entropy | model copied placeholder content instead of generating real file content |
| entropy-qwen25-coder-05b-large | library-chain | lib-001-core | generation | model_or_entropy | model did not generate expected artifact path: library-chain/core |
| entropy-qwen25-coder-05b-large | webpage-chain | web-001-home | generation | model_or_entropy | model copied placeholder content instead of generating real file content |
| entropy-qwen35-122b | factory | factory-002-stations | harness | infra_or_serving | model response did not include choices text |
| entropy-qwen35-122b | library-chain | lib-004-shared-interface | harness | infra_or_serving | model response did not include choices text |
| entropy-qwen35-122b | webpage-chain | web-004-shared-nav | generation | model_or_entropy | Conversion from JSON failed with error: Unexpected end when deserializing object. Path 'files[0]', line 6, position 5. |
| entropy-qwen35-4b | factory | factory-002-stations | generation | model_or_entropy | model did not generate expected artifact path: factory-system/stations |
| entropy-qwen35-4b | library-chain | final-validation | missing_artifact | prompt_spec_or_validator | library-chain validation failed: missing project: CoreLib/CoreLib.csproj |
| entropy-qwen35-4b | webpage-chain | final-validation | missing_artifact | prompt_spec_or_validator | webpage-chain validation failed: page index.html is missing title text |
| entropy-qwen36 | factory | factory-001-layout | generation | model_or_entropy | Conversion from JSON failed with error: Unexpected end when deserializing object. Path 'files[3]', line 6, position 258. |
| entropy-qwen36 | library-chain | final-validation | missing_artifact | prompt_spec_or_validator | library-chain validation failed: missing project: CoreLib/CoreLib.csproj |
| entropy-qwen36 | webpage-chain | web-004-shared-nav | generation | model_or_entropy | Conversion from JSON failed with error: Unexpected end when deserializing object. Path 'files[2]', line 14, position 5. |
| entropy-qwen80next | factory | factory-002-stations | generation | model_or_entropy | model did not generate expected artifact path: factory-system/stations |
| entropy-qwen80next | library-chain | final-validation | missing_artifact | prompt_spec_or_validator | library-chain validation failed: missing project: CoreLib/CoreLib.csproj |
| entropy-qwen80next | webpage-chain | final-validation | missing_artifact | prompt_spec_or_validator | webpage-chain validation failed: page index.html is missing title text |
| entropy-qwen80nextcoder | factory | factory-002-stations | generation | model_or_entropy | model did not generate expected artifact path: factory-system/stations |
| entropy-qwen80nextcoder | library-chain | lib-003-chain | generation | model_or_entropy | Conversion from JSON failed with error: After parsing a value an unexpected character was encountered: l. Path 'files[0].content', line 5, position 37. |
| entropy-qwen80nextcoder | webpage-chain | final-validation | missing_artifact | prompt_spec_or_validator | webpage-chain validation failed: page index.html is missing title text |
| entropy-qwen80nextcoder-256k | factory | factory-002-stations | generation | model_or_entropy | model did not generate expected artifact path: factory-system/stations |
| entropy-qwen80nextcoder-256k | library-chain | lib-003-chain | generation | model_or_entropy | Conversion from JSON failed with error: After parsing a value an unexpected character was encountered: l. Path 'files[0].content', line 5, position 37. |
| entropy-qwen80nextcoder-256k | webpage-chain | final-validation | missing_artifact | prompt_spec_or_validator | webpage-chain validation failed: page index.html is missing title text |
| entropy-smollm3-3b | factory | factory-001-layout | generation | model_or_entropy | Conversion from JSON failed with error: After parsing a value an unexpected character was encountered: l. Path 'files[14].content', line 61, position 83. |
| entropy-smollm3-3b | library-chain | lib-001-core | generation | model_or_entropy | Conversion from JSON failed with error: After parsing a value an unexpected character was encountered: H. Path 'files[0].content', line 5, position 244. |
| entropy-smollm3-3b | webpage-chain | web-002-backlink | generation | model_or_entropy | model did not generate expected artifact path: site/page-2.html |
