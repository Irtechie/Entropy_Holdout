use library_chain_feature::feature_function;
use library_chain_contracts::SharedContract;

pub fn pipeline_function() -> &'static str {
    let feature_msg = feature_function();
    format!("Pipeline says: {}", feature_msg)
}

pub struct PipelineLib;

impl SharedContract for PipelineLib {
    fn get_name() -> &'static str {
        "PipelineLib"
    }
}

