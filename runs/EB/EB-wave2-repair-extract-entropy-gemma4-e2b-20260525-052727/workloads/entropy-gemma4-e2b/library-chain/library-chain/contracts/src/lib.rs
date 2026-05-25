pub trait Arithmetic {
    fn perform_operation(&self, a: i32, b: i32) -> i32;
}

// Example implementation for the core operation
pub struct CoreArithmetic;
impl Arithmetic for CoreArithmetic {
    fn perform_operation(&self, a: i32, b: i32) -> i32 {
        a + b
    }
}

