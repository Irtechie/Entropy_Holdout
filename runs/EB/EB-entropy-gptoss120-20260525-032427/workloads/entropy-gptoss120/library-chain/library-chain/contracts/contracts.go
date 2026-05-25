package contracts

// Greeter defines a contract for greeting.
type Greeter interface {
    Greet(name string) string
}

