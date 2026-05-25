"""Feature library that depends on core."""

from core import get_greeting

def get_featured_greeting(name: str) -> str:
    """Return a featured greeting message for the given name.
    
    Args:
        name: The name to greet.
        
    Returns:
        A featured greeting string.
    """
    base_greeting = get_greeting(name)
    return f"{base_greeting} Welcome to the feature!"

