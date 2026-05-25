from chain import execute_chain

def run_pipeline(name: str) -> str:
    """Runs the full processing pipeline by executing the chain library."""
    return execute_chain(name)
