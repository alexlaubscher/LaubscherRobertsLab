/*
* Alex Laubscher
* Gillespie Algorithm
*/

#include <curand.h>
#include <curand_kernel.h>
#include <stdio.h>
#include <time.h>
#define SIZE 1024

__device__ void genUrn(double *urn) {
    urn[threadIdx.x] = (double) curand() / (RAND_MAX);
}

int main(void) {
    // Starting the timer
    clock_t start = clock();

    // Initializing pointers
    double *urn;
    double *d_urn;

    // Initializing variables for the while loop
    double counter;
    int death;
    int total;
    double tau;
    double sample;
    int allocSize = SIZE * sizeof(double);

    // Initial population
    double pop = 0;

    // Initializing time
    double time = 0;
    double maxTime = 100000;

    // Allocating memory for the random numbers
    urn = (double *)malloc(allocSize);
    cudaMalloc((void **) &d_urn, allocSize);

    // Move the array over to the GPU
    cudaMemcpy(d_urn, urn, allocSize, cudaMemcpyHostToDevice);

    // Can be outside cuz it never changes
    int birth = 1000;

    // Run the while loop over 100,000 simulation seconds
    while (time < maxTime) {
        // Setting the propensity of the rxn
        death = pop;

        // Sum over the propensities
        total = birth + death;

        // Need to cast the double
        int check = (int) counter % 512;

        if (check == 0) {
            genUrn<<<1, allocSize>>>(d_urn);
            cudaMemcpy(urn, d_urn, allocSize, cudaMemcpyDeviceToHost);
        }

        // Calculate time step
        tau = (1.0 / total) * log(urn[check * 2]);

        // Second random choice
        sample = total * (urn[check * 2 + 1]);

        // Update populations based on second urn
        if (sample < birth) {
            pop = pop + 1;
        } else {
            pop = pop - 1;
        }

        // Update the time step
        time = time - tau;

        // Increment the counter
        counter++;
    }

    // End the time and convert to sec
    clock_t end = clock();
    double timer = (end - start) / CLOCKS_PER_SEC;

    //Calculate the reactions per sec
    double rate = counter / timer;
    printf("Population: %f\n", pop);
    printf("Counter: %f\n", counter);
    printf("Timer: %f\n", timer);
    printf("Rate: %f\n", rate);

    free(urn);
    cudaFree(d_urn);

    return 0;
}
