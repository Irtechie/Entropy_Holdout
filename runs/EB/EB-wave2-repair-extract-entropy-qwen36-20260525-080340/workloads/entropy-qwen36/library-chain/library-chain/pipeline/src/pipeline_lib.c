#include "pipeline_lib.h"
#include "../feature/src/feature_lib.h"

int pipeline_process(int a, int b) {
    return feature_add_extra(a, b) * 2;
}

