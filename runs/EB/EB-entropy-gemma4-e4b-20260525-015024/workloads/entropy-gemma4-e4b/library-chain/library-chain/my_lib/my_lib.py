from core import greet

def process_greeting(name: str) -> str:
    """Processes a greeting by calling the core library."""
    greeting = greet(name)
    return f"Processed: {greeting.upper()}"
