use library_chain_core::add;

/// A function in the feature library that utilizes the core library's addition function.
pub fn calculate_sum(a: i32, b: i32) -> i32 {
    let result = add(a, b);
    result * 2 // Example operation using the core function
}

