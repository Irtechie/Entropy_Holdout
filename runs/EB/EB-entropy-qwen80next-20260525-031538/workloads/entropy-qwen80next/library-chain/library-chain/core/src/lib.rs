use library_chain_contracts::SharedContract;

pub struct CoreImpl;

impl SharedContract for CoreImpl {
    fn shared_function(&self) -> String {
        "Hello from core".to_string()
    }
}

pub fn core_function() -> String {
    CoreImpl {}.shared_function()
}
