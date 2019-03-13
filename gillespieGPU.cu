/*
* Alex Laubscher
* Gillespie Algorithm
*/

#include <curand.h>
#include <curand_kernel.h>
#include <stdio.h>
#include <time.h>
#define SIZE 1024

int main(void) {

    // Initializing variables for gillespie algorithm
    double counter;
    int death;
    int total;
    double tau;
    double sample;

    // Initialize variables for the GPU generator
    int count = 50000;
    curandGenerator_t gen;
    float *devURN;
    float *hostURN;

    // Allocate n floats on host
    hostURN = (float *)calloc(count, sizeof(float));

    // Allocate n floats on device
    cudaMalloc((void **) &devURN, count*sizeof(float));

    // Create the generator
    curandCreateGenerator(&gen, CURAND_RNG_PSEUDO_DEFAULT);

    // Set the seed
    curandSetPseudoRandomGeneratorSeed(gen, 1234ULL);

    // Initial population
    double pop = 0;

    // Initializing time
    double time = 0;
    double maxTime = 100000;

    // Can be outside cuz it never changes
    int birth = 1000;

    // Starting the timer
    clock_t time_elapsed = clock();

    // Run the while loop over 100,000 simulation seconds
    while (time < maxTime) {
        // Setting the propensity of the rxn
        death = pop;

        // Sum over the propensities
        total = birth + death;

        // Need to cast the double
        int check = (int) counter % count;

        if (check == 0) {
            // Generate the floats
            curandGenerateUniform(gen, devURN, count);

            // Copy the numbers back to the device
            cudaMemcpy(hostURN, devURN, count*sizeof(float),
                cudaMemcpyDeviceToHost);
        }

        // Calculate time step
        tau = (1.0 / total) * log(hostURN[check * 2]);

        // Second random choice
        sample = total * (hostURN[check * 2 + 1]);

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
    time_elapsed = clock() - time_elapsed;
    double timer = ((double) time_elapsed) / CLOCKS_PER_SEC;

    //Calculate the reactions per sec
    double rate = counter / timer;
    printf("Population: %f\n", pop);
    printf("Counter: %f\n", counter);
    printf("Timer: %f\n", timer);
    printf("Rate: %f\n", rate);

    curandDestroyGenerator(gen);
    cudaFree(devURN);
    free(hostURN);

    return 0;
}
