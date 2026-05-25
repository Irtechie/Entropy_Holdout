pub trait SharedContract {
    fn contract_name() -> &'static str;
    fn version() -> &'static str;
}

