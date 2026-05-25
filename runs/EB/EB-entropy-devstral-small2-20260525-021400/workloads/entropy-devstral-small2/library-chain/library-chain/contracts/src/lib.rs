pub trait MathOperation {
    fn add(a: i32, b: i32) -> i32;
}

pub struct CoreMath;

impl MathOperation for CoreMath {
    fn add(a: i32, b: i32) -> i32 {
        a + b
    }
}

