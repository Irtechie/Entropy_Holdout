"""Sample caller for the feature library."""

from feature import get_feature_greeting

if __name__ == "__main__":
    result = get_feature_greeting("World")
    print(result)

