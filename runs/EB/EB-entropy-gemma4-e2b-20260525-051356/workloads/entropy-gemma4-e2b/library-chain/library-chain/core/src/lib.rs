use library_chain_contracts::Adder;

pub struct CoreAdder;

impl Adder for CoreAdder {
    fn add(&self, a: i32, b: i32) -> i32 {
        a + b
    }
}

