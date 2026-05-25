"""Feature library that depends on core and calls its public function."""

from core import get_greeting

def get_feature_greeting(name: str) -> str:
    """Return a greeting message using the core library.
    
    Args:
        name: The name to greet.
        
    Returns:
        A greeting string from the feature library.
    """
    core_greeting = get_greeting(name)
    return f"[Feature] {core_greeting}"

