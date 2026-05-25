package feature

import (
    "example.com/core"
    "example.com/contracts"
)

func Greet(name string) string {
    greeter := core.NewGreeter()
    return greeter.Greet(name)
}

// NewGreeter returns a Greeter implementation from core.
func NewGreeter() contracts.Greeter {
    return core.NewGreeter()
}

