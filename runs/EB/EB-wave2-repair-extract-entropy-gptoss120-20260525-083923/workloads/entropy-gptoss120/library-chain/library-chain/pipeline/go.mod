module example.com/pipeline

go 1.22

require (
    example.com/feature v0.0.0
    example.com/contracts v0.0.0
)

replace (
    example.com/feature => ../feature
    example.com/contracts => ../contracts
)
