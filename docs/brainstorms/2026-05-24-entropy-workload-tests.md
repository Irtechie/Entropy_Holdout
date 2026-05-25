# Entropy Workload Tests

Created: 2026-05-24

## Goal

Build staged code-generation workloads that measure where models break by model size, context size, and harness behavior.

The benchmark is meant to answer: how far does Entropy move the needle to the right?

## Workload 1: Webpage Chain

The model builds a website over multiple turns:

1. Create webpage 1.
2. Create webpage 2 and link it back to webpage 1.
3. Create webpage 3 and link it back to webpage 2.
4. Create webpage 4 and link it back to webpage 3.
5. Create webpage 5 and link it back across the previous pages.
6. Add shared structure, such as nested table data or shared navigation, that all pages must use correctly.

## Workload 2: Library / DLL Chain

The model builds a library dependency chain:

1. Create the first library.
2. Create the second library depending on the first.
3. Create the third library depending on the second.
4. Continue until dependency pressure exposes breakage.
5. Validate that public APIs, references, builds, and sample calls still work.

## Workload 3: Factory

The model creates the factory/system itself. This workload is less linear and should force the model to maintain a growing architecture and dependency graph.

The exact dropped-in factory seed is not present in this checkout as of bootstrap. Use a generic factory spec until the real seed is provided or found.

## Measurement

For every model/context/harness combination, capture:

- workload,
- stage reached,
- first failing stage,
- failure class,
- generated files,
- validator output,
- token usage/timing where available,
- whether the harness preserved enough prior state.

## Out Of Scope For First Pass

- Throughput benchmarking.
- Subjective quality scoring beyond validator failures.
- Full long-context semantic grading.
- Reworking the LLMCommune activation smoke harness unless required to call the models.
