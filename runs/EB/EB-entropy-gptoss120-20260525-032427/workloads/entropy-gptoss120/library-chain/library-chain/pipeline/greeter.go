package pipeline

import (
    "example.com/contracts"
    "example.com/feature"
)

// PipelineGreeter implements the Greeter contract by delegating to the feature library.
type PipelineGreeter struct{}

func (g PipelineGreeter) Greet(name string) string {
    return feature.Greet(name)
}

// Ensure PipelineGreeter satisfies contracts.Greeter.
var _ contracts.Greeter = PipelineGreeter{}

