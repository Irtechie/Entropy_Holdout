# EB-wave2-repair-extract Failure Origin Audit

- Generated: 2026-05-25T10:51:49.1562928-04:00
- Run glob: `EB-wave2-repair-extract-*`
- Run count: 19
- Failure rows audited: 57
- Audit JSON: `E:\Dev\AI\remote\Entropy\docs\reports\EB-wave2-repair-extract-failure-origin-audit.json`

## Origin Counts

| Origin | Count |
|---|---:|
| context_budget | 12 |
| infra_or_serving | 10 |
| model_or_entropy | 14 |
| prompt_spec_or_validator | 21 |

## First Failures

| Target | Workload | Stage | Class | Origin | Error |
|---|---|---|---|---|---|
| entropy-devstral-small2 | factory | final-validation | missing_artifact | model_or_entropy | factory validation failed: missing station id intake |
| entropy-devstral-small2 | library-chain | final-validation | missing_artifact | prompt_spec_or_validator | library-chain validation failed: missing project: CoreLib/CoreLib.csproj |
| entropy-devstral-small2 | webpage-chain | final-validation | missing_artifact | prompt_spec_or_validator | webpage-chain validation failed: page index.html is missing title text |
| entropy-gemma4-e2b | factory | factory-002-stations | generation | model_or_entropy | model did not generate expected artifact path: factory-system/stations |
| entropy-gemma4-e2b | library-chain | final-validation | missing_artifact | prompt_spec_or_validator | library-chain validation failed: missing project: CoreLib/CoreLib.csproj |
| entropy-gemma4-e2b | webpage-chain | final-validation | missing_artifact | prompt_spec_or_validator | webpage-chain validation failed: page index.html is missing title text |
| entropy-gemma4-e4b | factory | factory-002-stations | generation | model_or_entropy | model did not generate expected artifact path: factory-system/stations |
| entropy-gemma4-e4b | library-chain | final-validation | missing_artifact | prompt_spec_or_validator | library-chain validation failed: missing project: CoreLib/CoreLib.csproj |
| entropy-gemma4-e4b | webpage-chain | final-validation | missing_artifact | prompt_spec_or_validator | webpage-chain validation failed: page index.html is missing title text |
| entropy-gemma431 | factory | factory-004-dashboard | harness | infra_or_serving | curl exited 28 posting http://192.168.1.203:8000/v1/completions body= |
| entropy-gemma431 | library-chain | lib-004-shared-interface | harness | infra_or_serving | model response did not include choices text |
| entropy-gemma431 | webpage-chain | final-validation | missing_artifact | prompt_spec_or_validator | webpage-chain validation failed: page index.html is missing title text |
| entropy-gptoss120 | factory | factory-002-stations | generation | model_or_entropy | model did not generate expected artifact path: factory-system/stations |
| entropy-gptoss120 | library-chain | final-validation | missing_artifact | prompt_spec_or_validator | library-chain validation failed: missing project: CoreLib/CoreLib.csproj |
| entropy-gptoss120 | webpage-chain | web-005-nested-shared-table | harness | context_budget | HTTP 400 posting http://192.168.1.203:8000/v1/completions body={"error":{"code":400,"message":"request (69405 tokens) exceeds the available context size (65536 tokens), try increasing it","type":"exceed_context_size_e... |
| entropy-gptoss20 | factory | factory-002-stations | generation | model_or_entropy | model did not generate expected artifact path: factory-system/stations |
| entropy-gptoss20 | library-chain | lib-002-dependent | harness | infra_or_serving | model response did not include choices text |
| entropy-gptoss20 | webpage-chain | web-002-backlink | harness | infra_or_serving | model response did not include choices text |
| entropy-granite-code-3b | factory | factory-001-layout | harness | context_budget | HTTP 400 posting http://192.168.1.203:8000/v1/completions body={"error":{"code":400,"message":"request (7155 tokens) exceeds the available context size (2048 tokens), try increasing it","type":"exceed_context_size_err... |
| entropy-granite-code-3b | library-chain | lib-001-core | harness | context_budget | HTTP 400 posting http://192.168.1.203:8000/v1/completions body={"error":{"code":400,"message":"request (5882 tokens) exceeds the available context size (2048 tokens), try increasing it","type":"exceed_context_size_err... |
| entropy-granite-code-3b | webpage-chain | web-001-home | harness | context_budget | HTTP 400 posting http://192.168.1.203:8000/v1/completions body={"error":{"code":400,"message":"request (6037 tokens) exceeds the available context size (2048 tokens), try increasing it","type":"exceed_context_size_err... |
| entropy-minimax-m27 | factory | factory-002-stations | harness | context_budget | HTTP 400 posting http://192.168.1.203:8000/v1/completions body={"error":{"code":400,"message":"request (31108 tokens) exceeds the available context size (16384 tokens), try increasing it","type":"exceed_context_size_e... |
| entropy-minimax-m27 | library-chain | lib-004-shared-interface | harness | context_budget | HTTP 400 posting http://192.168.1.203:8000/v1/completions body={"error":{"code":400,"message":"request (35367 tokens) exceeds the available context size (16384 tokens), try increasing it","type":"exceed_context_size_e... |
| entropy-minimax-m27 | webpage-chain | web-005-nested-shared-table | harness | context_budget | HTTP 400 posting http://192.168.1.203:8000/v1/completions body={"error":{"code":400,"message":"request (26450 tokens) exceeds the available context size (16384 tokens), try increasing it","type":"exceed_context_size_e... |
| entropy-nemotron-cascade-30b | factory | factory-002-stations | harness | infra_or_serving | model response did not include choices text |
| entropy-nemotron-cascade-30b | library-chain | lib-001-core | harness | infra_or_serving | model response did not include choices text |
| entropy-nemotron-cascade-30b | webpage-chain | web-001-home | harness | infra_or_serving | model response did not include choices text |
| entropy-nemotron120 | factory | final-validation | missing_artifact | prompt_spec_or_validator | factory validation failed: missing json file: E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-nemotron120-20260525-084852\workloads\entropy-nemotron120\factory\factory-system\config\stations.json |
| entropy-nemotron120 | library-chain | lib-004-shared-interface | harness | infra_or_serving | model response did not include choices text |
| entropy-nemotron120 | webpage-chain | web-003-chain-link | harness | infra_or_serving | model response did not include choices text |
| entropy-nemotron3-super-120b | factory | final-validation | harness | model_or_entropy | factory validation failed: station count mismatch |
| entropy-nemotron3-super-120b | library-chain | lib-004-shared-interface | harness | context_budget | HTTP 400 posting http://192.168.1.203:8000/v1/completions body={"error":{"code":400,"message":"request (72018 tokens) exceeds the available context size (65536 tokens), try increasing it","type":"exceed_context_size_e... |
| entropy-nemotron3-super-120b | webpage-chain | web-005-nested-shared-table | harness | context_budget | HTTP 400 posting http://192.168.1.203:8000/v1/completions body={"error":{"code":400,"message":"request (68034 tokens) exceeds the available context size (65536 tokens), try increasing it","type":"exceed_context_size_e... |
| entropy-qwen25-coder-05b-large | factory | factory-001-layout | generation | model_or_entropy | model copied placeholder content instead of generating real file content |
| entropy-qwen25-coder-05b-large | library-chain | lib-001-core | generation | model_or_entropy | model copied placeholder content instead of generating real file content |
| entropy-qwen25-coder-05b-large | webpage-chain | web-001-home | generation | model_or_entropy | model copied placeholder path instead of generating a real file path |
| entropy-qwen35-122b | factory | factory-002-stations | generation | model_or_entropy | model did not generate expected artifact path: factory-system/stations |
| entropy-qwen35-122b | library-chain | final-validation | missing_artifact | prompt_spec_or_validator | library-chain validation failed: missing project: CoreLib/CoreLib.csproj |
| entropy-qwen35-122b | webpage-chain | final-validation | missing_artifact | prompt_spec_or_validator | webpage-chain validation failed: page index.html is missing title text |
| entropy-qwen35-4b | factory | final-validation | harness | model_or_entropy | factory validation failed: station count mismatch |
| entropy-qwen35-4b | library-chain | lib-004-shared-interface | harness | infra_or_serving | model response did not include choices text |
| entropy-qwen35-4b | webpage-chain | final-validation | missing_artifact | prompt_spec_or_validator | webpage-chain validation failed: page index.html is missing title text |
| entropy-qwen36 | factory | factory-004-dashboard | harness | context_budget | HTTP 400 posting http://192.168.1.203:8000/v1/completions body={"error":{"code":400,"message":"request (340872 tokens) exceeds the available context size (262144 tokens), try increasing it","type":"exceed_context_size... |
| entropy-qwen36 | library-chain | final-validation | missing_artifact | prompt_spec_or_validator | library-chain validation failed: missing project: CoreLib/CoreLib.csproj |
| entropy-qwen36 | webpage-chain | final-validation | missing_artifact | prompt_spec_or_validator | webpage-chain validation failed: page index.html is missing title text |
| entropy-qwen80next | factory | final-validation | missing_artifact | prompt_spec_or_validator | factory validation failed: missing json file: E:\Dev\AI\remote\Entropy\runs\EB\EB-wave2-repair-extract-entropy-qwen80next-20260525-082350\workloads\entropy-qwen80next\factory\factory-system\config\stations.json |
| entropy-qwen80next | library-chain | final-validation | missing_artifact | prompt_spec_or_validator | library-chain validation failed: missing project: CoreLib/CoreLib.csproj |
| entropy-qwen80next | webpage-chain | final-validation | missing_artifact | prompt_spec_or_validator | webpage-chain validation failed: page index.html is missing title text |
| entropy-qwen80nextcoder | factory | factory-002-stations | generation | model_or_entropy | model did not generate expected artifact path: factory-system/stations |
| entropy-qwen80nextcoder | library-chain | final-validation | missing_artifact | prompt_spec_or_validator | library-chain validation failed: missing project: CoreLib/CoreLib.csproj |
| entropy-qwen80nextcoder | webpage-chain | final-validation | missing_artifact | prompt_spec_or_validator | webpage-chain validation failed: page index.html is missing title text |
| entropy-qwen80nextcoder-256k | factory | factory-002-stations | generation | model_or_entropy | model did not generate expected artifact path: factory-system/stations |
| entropy-qwen80nextcoder-256k | library-chain | final-validation | missing_artifact | prompt_spec_or_validator | library-chain validation failed: missing project: CoreLib/CoreLib.csproj |
| entropy-qwen80nextcoder-256k | webpage-chain | final-validation | missing_artifact | prompt_spec_or_validator | webpage-chain validation failed: page index.html is missing title text |
| entropy-smollm3-3b | factory | factory-002-stations | generation | model_or_entropy | model did not generate expected artifact path: factory-system/stations |
| entropy-smollm3-3b | library-chain | lib-004-shared-interface | harness | context_budget | HTTP 400 posting http://192.168.1.203:8000/v1/completions body={"error":{"code":400,"message":"request (121543 tokens) exceeds the available context size (65536 tokens), try increasing it","type":"exceed_context_size_... |
| entropy-smollm3-3b | webpage-chain | web-004-shared-nav | harness | context_budget | HTTP 400 posting http://192.168.1.203:8000/v1/completions body={"error":{"code":400,"message":"request (71876 tokens) exceeds the available context size (65536 tokens), try increasing it","type":"exceed_context_size_e... |
