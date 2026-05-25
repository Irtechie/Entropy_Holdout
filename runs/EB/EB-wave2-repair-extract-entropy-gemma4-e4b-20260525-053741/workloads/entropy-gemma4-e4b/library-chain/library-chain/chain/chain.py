from library_chain.contracts.interface import GreetingProcessor

class ChainProcessor:
    def __init__(self, feature_processor: GreetingProcessor):
        self.feature_processor = feature_processor

    def execute_chain(self, name: str) -> str:
        """Executes the full chain of processing by calling the feature library via the contract."""
        return self.feature_processor.process(name)

# Instantiate the chain processor, relying on the feature implementation
from library_chain.feature.feature import feature_processor
chain_processor: GreetingProcessor = ChainProcessor(feature_processor)
