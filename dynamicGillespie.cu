/*
* Alex Laubscher
* Gillespie with Dynamic Parallelism
*/

#include <curand_kernel.h>
#include <stdio.h>
#include <stdlib.h>

__device__ float *normURN;
__device__ float *logURN;
__device__ float *normURN2;
__device__ float *logURN2;

__global__ void genURN(float *normURN, int *count) {
    int i = threadIdx.x;

    if (i < *count) {
        curandState state;
        curand_init(clock64(), i, 0, &state);
        normURN[i] = curand_uniform(&state);
    }
}

__global__ void genLogURN(float *logURN, int *count) {
    int i = threadIdx.x;

    if (i < *count) {
        curandState state;
        curand_init(clock64(), i, 0, &state);
        normURN[i] = log(curand_uniform(&state));
    }
}

__global__ void devMain(int *counter, int *death, int *total, double *tau,
    double *sample, int *check, int *count, int *pop, double *time,
    double *maxTime, int *birth, int *swap) {

    cudaMalloc((void **) &normURN, 250000*sizeof(float));
    cudaMalloc((void **) &logURN, 250000*sizeof(float));
    cudaMalloc((void **) &normURN2, 250000*sizeof(float));
    cudaMalloc((void **) &logURN2, 250000*sizeof(float));

    *count = 250000;
    *pop = 0;
    *time = 0;
    *maxTime = 10;
    *birth = 1000;

    while(time < maxTime) {
        printf("%f < %f\n", *time, *maxTime);
        *death = *pop;

        *total = *birth + *death;

        *check = *counter % (*count);
        genURN<<<1, 512>>>(logURN, count);
        genLogURN<<<1, 512>>>(normURN, count);

        if (*check == 0) {
            if (*swap == 1) {
                genURN<<<1, 512>>>(logURN2, count);
                genLogURN<<<1, 512>>>(normURN2, count);
                *swap = 2;
            } else {
                genURN<<<1, 512>>>(logURN, count);
                genLogURN<<<1, 512>>>(normURN, count);
                *swap = 1;
            }
        }

        if (*swap == 1) {
            *tau = (1.0 / *total) * logURN[*check];
            *sample = *total * normURN[*check];
        } else {
            *tau = (1.0 / *total) * logURN2[*check];
            *sample = *total * normURN2[*check];
        }


        if (*sample < *birth) {
            *pop = *pop + 1;
        } else {
            *pop = *pop - 1;
        }

        *time = *time - *tau;

        *counter++;
    }

    printf("something is wrong here\n");

    cudaFree(normURN);
    cudaFree(logURN);
    cudaFree(normURN2);
    cudaFree(logURN2);

    printf("Population: %f\n", *pop);
    printf("Counter: %d\n", *counter);
}

int main(void) {
    int *counter;
    int *death;
    int *total;
    double *tau;
    double *sample;
    int *check;
    int *count;
    int *pop;
    double *time;
    double *maxTime;
    int *birth;
    int *swap;

    cudaMalloc(&counter, sizeof(int));
    cudaMalloc(&death, sizeof(int));
    cudaMalloc(&total, sizeof(int));
    cudaMalloc(&tau, sizeof(double));
    cudaMalloc(&sample, sizeof(double));
    cudaMalloc(&check, sizeof(int));
    cudaMalloc(&count, sizeof(int));
    cudaMalloc(&pop, sizeof(int));
    cudaMalloc(&time, sizeof(double));
    cudaMalloc(&maxTime, sizeof(double));
    cudaMalloc(&birth, sizeof(int));
    cudaMalloc(&swap, sizeof(int));

    devMain<<<1, 128>>>(counter, death, total, tau, sample, check, count,
        pop, time, maxTime, birth, swap);

    cudaFree(counter);
    cudaFree(death);
    cudaFree(total);
    cudaFree(tau);
    cudaFree(sample);
    cudaFree(check);
    cudaFree(pop);
    cudaFree(time);
    cudaFree(maxTime);
    cudaFree(birth);
    cudaFree(swap);
}
