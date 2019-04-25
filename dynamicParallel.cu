/*
* Alex Laubscher
* Practice with Dynamic Parallelism
*/

#include <curand.h>
#include <stdio.h>
#include <stdlib.h>
#define SIZE 1024

__global__ void kidKernel(void) {
    for (int i = SIZE - 5; i < SIZE; ++i) {
        printf("c[%d] = %d\n", i, dev_c[i]);
    }
}

__global__ void VectorAdd(float *a, float *b, float *c, int n) {
    printf("Inside the kernel");
    int i = threadIdx.X;

    if (i < n)
        c[i] = a[i] + b[i];

    kidKernel <<<1, 1>>> ();

}


int main() {
    float *dev_a, *dev_b, *dev_c, *dev_d;

    float *a = (float *)calloc(SIZE, sizeof(float));
    float *b = (float *)calloc(SIZE, sizeof(float));
    float *c = (float *)calloc(SIZE, sizeof(float));
    float *d = (float *)calloc(SIZE, sizeof(float));

    cudaMalloc((void **) &dev_a, SIZE*sizeof(float));
    cudaMalloc((void **) &dev_b, SIZE*sizeof(float));
    cudaMalloc((void **) &dev_c, SIZE*sizeof(float));
    cudaMalloc((void **) &dev_d, SIZE*sizeof(float));

    cudaMemcpy(dev_a, a, SIZE, cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b, b, SIZE, cudaMemcpyHostToDevice);

    for (int i = 0; i < SIZE; ++i) {
        a[i] = i;
        b[i] = i;
    }

    VectorAdd <<<1, SIZE>>> (&dev_a, &dev_b, &dev_c, SIZE);

    free(a), free(b);
    cudaFree(dev_a), cudaFree(dev_b), cudaFree(dev_c), cudaFree(dev_d);
}
