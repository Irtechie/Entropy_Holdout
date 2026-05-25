package core

import "example.com/contracts"

type coreGreeter struct{}

func (c coreGreeter) Greet(name string) string {
    return Hello(name)
}

// NewGreeter returns a Greeter implementation.
func NewGreeter() contracts.Greeter {
    return coreGreeter{}
}

