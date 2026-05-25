use library_chain_core::SharedContract;

pub fn feature_function() -> String {
    let core = CoreImpl {};
    format!("{} and feature", core.shared_function())
}
