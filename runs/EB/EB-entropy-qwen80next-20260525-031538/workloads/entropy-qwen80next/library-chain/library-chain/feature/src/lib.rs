use library_chain_contracts::SharedContract;
use library_chain_core::CoreImpl;

pub struct FeatureImpl;

impl SharedContract for FeatureImpl {
    fn shared_function(&self) -> String {
        let core = CoreImpl {};
        format!("{} and feature", core.shared_function())
    }
}

pub fn feature_function() -> String {
    FeatureImpl {}.shared_function()
}
