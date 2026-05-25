#include <stdio.h>
#include "src/pipeline_lib.h"

int main() {
    int result = pipeline_process(2, 3);
    printf("Pipeline Result: %d\n", result);
    return 0;
}

