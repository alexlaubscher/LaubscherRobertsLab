/*
* Alex Laubscher
* Practice with Dynamic Parallelism
*/

#include <curand.h>
#include <stdio.h>
#include <stdlib.h>
#define SIZE 1024

__global__ void VectorAdd(int *a, int *b, int n) {
    printf("Inside the kernel");
    int i = threadIdx.X;

    if (i < n)
        c[i] = a[i] + b[i];
}


int main() {
    float *dev_a, *dev_b, *dev_c, *dev_d;

    a = (float *)calloc(SIZE, sizeof(float));
    b = (float *)calloc(SIZE, sizeof(float));
    c = (float *)calloc(SIZE, sizeof(float));
    d = (float *)calloc(SIZE, sizeof(float));

    cudaMalloc((void **) &dev_a, count*sizeof(float));
    cudaMalloc((void **) &dev_b, count*sizeof(float));
    cudaMalloc((void **) &dev_c, count*sizeof(float));
    cudaMalloc((void **) &dev_d, count*sizeof(float));


    for (int i = 0; i < SIZE; ++i) {
        a[i] = i;
        b[i] = i;
    }



    free(a), free(b);
    cudaFree(dev_a), cudaFree(dev_b), cudaFree(dev_c), cudaFree(dev_d);
}
