#include "feature_lib.h"
#include "../core/src/core_lib.h"

int feature_add_extra(int a, int b) {
    return core_add(a, b) + 10;
}

