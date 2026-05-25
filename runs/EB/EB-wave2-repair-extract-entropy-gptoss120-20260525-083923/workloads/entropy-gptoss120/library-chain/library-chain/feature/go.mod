module example.com/feature

go 1.22

require (
    example.com/core v0.0.0
    example.com/contracts v0.0.0
)

replace (
    example.com/core => ../core
    example.com/contracts => ../contracts
)
