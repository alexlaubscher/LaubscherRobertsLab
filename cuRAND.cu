/*
* Alex Laubscher
* Random Number Generation
*/

#include <curand.h>
#include <cuda.h>
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Initialize variables
    int count = 500000;
    int i;
    curandGenerator_t gen;
    float *devURN;
    float *hostURN;
    float *cpuURN;

    // Allocate n floats on host
    hostURN = (float *)calloc(count, sizeof(float));
    cpuURN = (float*)calloc(count, sizeof(float));

    // Allocate n floats on device
    cudaMalloc((void **) &devURN, count*sizeof(float));

    // Create the generator
    curandCreateGenerator(&gen, CURAND_RNG_PSEUDO_DEFAULT);

    // Set the seed
    curandSetPseudoRandomGeneratorSeed(gen, 1234ULL);

    clock_t time_elapsed = clock();
    
    // Generate the floats
    curandGenerateUniform(gen, devURN, count);

    // Copy the numbers back to the device
    cudaMemcpy(hostURN, devURN, count*sizeof(float), cudaMemcpyDeviceToHost);

    time_elapsed = (clock() - time_elapsed);
    double GPU_time = ((double) time_elapsed) / CLOCKS_PER_SEC;

    time_elapsed = clock();

    for (i = 0; i < count; i++) {
        cpuURN[i] = rand();
    }

    time_elapsed = (clock() - time_elapsed);
    double CPU_time = ((double) time_elapsed) / CLOCKS_PER_SEC;

    for (i = 0; i < 10; i++) {
        printf("GPU: %f CPU: %f\n", hostURN[i], cpuURN[i]);
    }

    printf("GPU time: %f\n", GPU_time);
    printf("CPU time: %f\n", CPU_time);

    curandDestroyGenerator(gen);
    cudaFree(devURN);
    free(cpuURN);
    free(hostURN);
}
