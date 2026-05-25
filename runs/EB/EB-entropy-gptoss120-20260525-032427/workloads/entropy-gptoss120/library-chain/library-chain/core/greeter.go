package core

import "example.com/contracts"

// CoreGreeter implements the Greeter contract using the core Hello function.
type CoreGreeter struct{}

func (g CoreGreeter) Greet(name string) string {
    return Hello(name)
}

// Compile‑time check that CoreGreeter satisfies contracts.Greeter.
var _ contracts.Greeter = CoreGreeter{}

