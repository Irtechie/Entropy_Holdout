use library_chain_feature::calculate_sum;

/// Orchestrates the calculation by using the feature library.
pub fn run_pipeline(a: i32, b: i32) -> i32 {
    calculate_sum(a, b)
}

