use library_chain_feature::feature_function;
use library_chain_contracts::SharedContract;

pub fn pipeline_function() -> String {
    format!("{} - pipeline!", feature_function())
}

pub struct PipelineImpl;

impl SharedContract for PipelineImpl {
    fn contract_name() -> &'static str {
        "pipeline"
    }

    fn version() -> &'static str {
        "0.1.0"
    }
}

