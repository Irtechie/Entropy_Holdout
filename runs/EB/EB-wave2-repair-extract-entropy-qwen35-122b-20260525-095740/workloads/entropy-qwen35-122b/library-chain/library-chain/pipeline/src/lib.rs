use chain_contracts::Operation;

pub struct QuadrupleOp;

impl Operation for QuadrupleOp {
    fn execute(&self, value: i32) -> i32 {
        chain_feature::triple(value) + value
    }
}

pub fn quadruple(x: i32) -> i32 {
    QuadrupleOp.execute(x)
}

