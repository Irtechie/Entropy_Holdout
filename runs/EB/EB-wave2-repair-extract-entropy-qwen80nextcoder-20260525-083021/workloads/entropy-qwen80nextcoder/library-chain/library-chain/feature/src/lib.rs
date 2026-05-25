use library_chain_core::core_function;
use library_chain_contracts::SharedContract;

pub fn feature_function() -> &'static str {
    let core_msg = core_function();
    format!("Feature says: {}", core_msg)
}

pub struct FeatureLib;

impl SharedContract for FeatureLib {
    fn get_name() -> &'static str {
        "FeatureLib"
    }
}

