/*
* Alex Laubscher
* Practice with Dynamic Parallelism
*/

#include <curand.h>
#include <stdio.h>
#include <stdlib.h>
#define SIZE 1024

int main() {
    int *a, *b, *c;

    cudaMallocManaged(&a, SIZE * sizeof(int));
    cudaMallocManaged(&b, SIZE * sizeof(int));
    cudaMallocManaged(&c, SIZE * sizeof(int));
    cudaMallocManaged(&d, SIZE * sizeof(int));

    for (int i = 0; i < SIZE; ++i) {
        a[i] = i;
        b[i] = i;
        c[i] = 0;
        d[i] = 0;
    }

    VectorAdd
}
