"""Pipeline library that depends on feature."""

from feature import get_featured_greeting

def get_pipeline_greeting(name: str) -> str:
    """Return a pipeline greeting message for the given name.
    
    Args:
        name: The name to greet.
        
    Returns:
        A pipeline greeting string.
    """
    featured_greeting = get_featured_greeting(name)
    return f"{featured_greeting} Enjoy the pipeline!"

