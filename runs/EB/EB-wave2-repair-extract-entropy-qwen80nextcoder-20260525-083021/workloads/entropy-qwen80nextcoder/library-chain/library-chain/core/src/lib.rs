use library_chain_contracts::SharedContract;

pub fn core_function() -> &'static str {
    "Hello from core!"
}

pub struct CoreLib;

impl SharedContract for CoreLib {
    fn get_name() -> &'static str {
        "CoreLib"
    }
}

