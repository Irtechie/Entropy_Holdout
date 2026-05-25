package pipeline

import "example.com/feature"

func Chain(name string) string {
    greeter := feature.NewGreeter()
    return greeter.Greet(name)
}

