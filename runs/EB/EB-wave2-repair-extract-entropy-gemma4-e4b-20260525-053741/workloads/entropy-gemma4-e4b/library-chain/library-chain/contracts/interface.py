from typing import Protocol

class GreetingProcessor(Protocol):
    """Defines the shared interface for greeting processing."""
    def process(self, name: str) -> str
