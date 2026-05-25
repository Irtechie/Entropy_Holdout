"""Sample caller for the pipeline library."""

from pipeline import get_pipeline_greeting

if __name__ == "__main__":
    result = get_pipeline_greeting("World")
    print(result)

