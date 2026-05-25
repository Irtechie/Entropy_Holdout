use chain_contracts::Operation;

pub struct DoubleOp;

impl Operation for DoubleOp {
    fn execute(&self, value: i32) -> i32 {
        value * 2
    }
}

pub fn double(x: i32) -> i32 {
    DoubleOp.execute(x)
}

