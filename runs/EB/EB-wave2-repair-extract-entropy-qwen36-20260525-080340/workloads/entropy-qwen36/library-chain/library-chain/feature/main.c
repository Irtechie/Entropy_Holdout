#include <stdio.h>
#include "src/feature_lib.h"

int main() {
    int result = feature_add_extra(2, 3);
    printf("Feature Result: %d\n", result);
    return 0;
}

