use library_chain_contracts::Adder;
use library_chain_feature::calculate_sum;

/// Calculates the final result by utilizing the feature library's sum function.
pub fn process_pipeline(a: i32, b: i32) -> i32 {
    calculate_sum(a, b)
}

