use library_chain_feature::calculate_sum;

/// A function in the pipeline library that utilizes the feature library's calculation function.
pub fn process_data(a: i32, b: i32) -> i32 {
    let sum_result = calculate_sum(a, b);
    sum_result / 2 // Example operation using the feature function
}

