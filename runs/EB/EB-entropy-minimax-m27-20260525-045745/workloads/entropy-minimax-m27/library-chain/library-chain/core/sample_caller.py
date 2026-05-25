"""Sample caller for the core library."""

from core import get_greeting

if __name__ == "__main__":
    result = get_greeting("World")
    print(result)

