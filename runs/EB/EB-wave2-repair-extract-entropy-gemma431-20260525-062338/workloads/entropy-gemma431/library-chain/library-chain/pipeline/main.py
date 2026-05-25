import sys
import os

# Add the core library directory to the path to allow importing 'core'
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'core')))
# Add the feature library directory to the path to allow importing 'feature'
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'feature')))
# Add the pipeline library directory to the path to allow importing 'pipeline'
sys.path.append(os.path.abspath(os.path.dirname(__file__)))

from pipeline import add_double_and_increment

if __name__ == "__main__":
    # Calculation: (2 + 3) * 2 + 5 = 15
    result = add_double_and_increment(2, 3, 5)
    print(f"Result: {result}")

