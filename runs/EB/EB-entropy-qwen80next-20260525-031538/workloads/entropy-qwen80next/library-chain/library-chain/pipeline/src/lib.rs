use library_chain_contracts::SharedContract;
use library_chain_feature::FeatureImpl;

pub struct PipelineImpl;

impl SharedContract for PipelineImpl {
    fn shared_function(&self) -> String {
        let feature = FeatureImpl {};
        format!("{} and pipeline", feature.shared_function())
    }
}

pub fn pipeline_function() -> String {
    PipelineImpl {}.shared_function()
}
