#include "pipeline.h"
#include "../feature/feature.h"
#include "../core/core.h"

int pipeline_func(int a, int b) {
    int result = multiply(a, b);
    return add(result, 0);
}

