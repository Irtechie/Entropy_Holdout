use library_chain_contracts::SharedContract;

pub fn core_function() -> &'static str {
    "Hello from core!"
}

pub struct CoreImpl;

impl SharedContract for CoreImpl {
    fn contract_name() -> &'static str {
        "core"
    }

    fn version() -> &'static str {
        "0.1.0"
    }
}

