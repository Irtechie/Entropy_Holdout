from library_chain.contracts.interface import GreetingProcessor

class FeatureProcessor:
    def __init__(self, core_processor: GreetingProcessor):
        self.core_processor = core_processor

    def process_greeting(self, name: str) -> str:
        """Processes a greeting using the core library via the contract."""
        base_greeting = self.core_processor.process(name)
        return f"Feature processed: {base_greeting.upper()}"

# Instantiate the feature processor, relying on the core implementation
# Note: In a real scenario, dependency injection would be managed externally.
# Here we assume the core implementation is available for instantiation.
from library_chain.core.core import core_processor
feature_processor: GreetingProcessor = FeatureProcessor(core_processor)
