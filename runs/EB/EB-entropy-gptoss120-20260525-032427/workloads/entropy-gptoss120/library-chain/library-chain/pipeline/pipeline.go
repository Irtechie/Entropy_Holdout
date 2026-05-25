package pipeline

import "example.com/feature"

// Run forwards the call to the feature library's Greet function.
func Run(name string) string {
    return feature.Greet(name)
}

