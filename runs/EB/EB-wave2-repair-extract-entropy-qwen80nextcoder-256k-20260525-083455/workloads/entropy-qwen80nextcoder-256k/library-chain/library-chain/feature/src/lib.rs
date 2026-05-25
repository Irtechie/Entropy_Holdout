use library_chain_core::core_function;
use library_chain_contracts::SharedContract;

pub fn feature_function() -> String {
    format!("{} - extended!", core_function())
}

pub struct FeatureImpl;

impl SharedContract for FeatureImpl {
    fn contract_name() -> &'static str {
        "feature"
    }

    fn version() -> &'static str {
        "0.1.0"
    }
}

