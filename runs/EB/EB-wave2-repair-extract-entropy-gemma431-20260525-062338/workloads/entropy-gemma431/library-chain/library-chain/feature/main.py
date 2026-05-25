import sys
import os

# Add the core library directory to the path to allow importing 'core'
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'core')))
# Add the feature library directory to the path to allow importing 'feature'
sys.path.append(os.path.abspath(os.path.dirname(__file__)))

from feature import add_and_double

if __name__ == "__main__":
    result = add_and_double(2, 3)
    print(f"Result: {result}")

