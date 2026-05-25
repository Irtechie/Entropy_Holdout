package feature

import (
    "example.com/contracts"
    "example.com/core"
)

// FeatureGreeter implements the Greeter contract by delegating to the core library.
type FeatureGreeter struct{}

func (g FeatureGreeter) Greet(name string) string {
    return core.Hello(name)
}

// Ensure FeatureGreeter satisfies contracts.Greeter.
var _ contracts.Greeter = FeatureGreeter{}

