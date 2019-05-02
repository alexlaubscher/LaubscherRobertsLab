/*
* Alex Laubscher
* Gillespie with Dynamic Parallelism
*/

#include <curand.h>
#include <stdio.h>
#include <stdlib.h>

int main() {
    int *counter;
    int *death;
    int *total;
    double *tau;
    double *sample;
    int *check;
    int *pop;
    double *time;
    double *maxTime;
    int *birth;
    double *normURN;
    double *logURN;

    cudaMalloc(&counter, size*sizeof(int));
    cudaMalloc(&death, size*sizeof(int));
    cudaMalloc(&total, size*sizeof(int));
    cudaMalloc(&tau, size*sizeof(double));
    cudaMalloc(&sample, size*sizeof(double));
    cudaMalloc(&check, size*sizeof(int));
    cudaMalloc(&pop, size*sizeof(int));
    cudaMalloc(&time, size*sizeof(double));
    cudaMalloc(&maxTime, size*sizeof(double));
    cudaMalloc(&birth, size*sizeof(int));
    cudaMalloc((void **) &normURN, 250000*sizeof(double));
    cudaMalloc((void **) &logURN, 250000*sizeof(double));

    devMain<<<1, 128>>>(counter, death, total, tau, sample, check
        pop, time, maxTime, birth, normURN, logURN);

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
    cudaFree(normURN);
    cudaFree(logURN);
}
