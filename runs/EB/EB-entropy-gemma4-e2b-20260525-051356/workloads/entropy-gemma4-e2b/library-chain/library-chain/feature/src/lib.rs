use library_chain_contracts::Adder;
use library_chain_core::CoreAdder;

/// Calculates the sum of two numbers by utilizing the core library's add function.
pub fn calculate_sum(a: i32, b: i32) -> i32 {
    let adder = CoreAdder;
    adder.add(a, b)
}

