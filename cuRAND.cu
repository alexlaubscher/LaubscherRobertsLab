/*
* Alex Laubscher
* Random Number Generation
*/

#include <curand.h>
#include <curand_kernel.h>
#include <stdio.h>
#include <time.h>

int main() {
    // Initialize variables
    int count = 1000;
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
    curandCreateGenerator(&gen, CURAND_RNG_PSEUDO_DEAULT);

    // Set the seed
    curandSetPseudoRandomGeneratorSeed(gen, 1234ULL);

    clock_t startGPU = clock();
        // Generate the floats
        curandGenerateUniform(gen, devURN, count);

        // Copy the numbers back to the device
        cudaMemcpy(devURN, hostURN, count*sizeof(float), cudaMemcpyDeviceToHost);
    double timeGPU = (clock() - startGPU) / CLOCKS_PER_SEC;

    clock_t startCPU = clock();
        for (i = 0; i < count; i++) {
            cpuURN[i] = rand();
        }
    double timeCPU = (clock() - startCPU) / CLOCKS_PER_SEC;

    printf("GPU time: %f\n", timeGPU);
    printf("CPU time: %f\n", timeCPU);

    cudaDestroyGenerator(gen);
    cudaFree(devURN);
    free(cpuURN);
    free(hostURN);
}
