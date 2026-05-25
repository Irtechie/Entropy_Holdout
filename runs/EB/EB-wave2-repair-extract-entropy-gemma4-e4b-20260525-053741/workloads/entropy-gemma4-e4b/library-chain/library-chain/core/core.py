from library_chain.contracts.interface import GreetingProcessor

class CoreProcessor: # Implements the contract
    def greet(self, name: str) -> str:
        """Returns a greeting message."""
        return f"Hello, {name} from Core!"

# Expose the implementation instance for external use
core_processor: GreetingProcessor = CoreProcessor()
