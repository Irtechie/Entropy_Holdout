package feature

import "example.com/core"

// Greet calls the core Hello function.
func Greet(name string) string {
    return core.Hello(name)
}

