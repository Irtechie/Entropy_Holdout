"""Core library with one public function."""

def get_greeting(name: str) -> str:
    """Return a greeting message for the given name.
    
    Args:
        name: The name to greet.
        
    Returns:
        A greeting string.
    """
    return f"Hello, {name}!"

