use chain_contracts::Operation;

pub struct TripleOp;

impl Operation for TripleOp {
    fn execute(&self, value: i32) -> i32 {
        chain_core::double(value) + value
    }
}

pub fn triple(x: i32) -> i32 {
    TripleOp.execute(x)
}

