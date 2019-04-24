/*
* Alex Laubscher
* Gillespie Algorithm
* Runs a singular simulation on a GPU
*/

#include <curand.h>
#include <stdio.h>
#include <time.h>

__global__ void simulation(int count, float *tauURN, float *distURN, curandGenerator_t gen) {

    // Same initialization of variables
    int counter;
    int death;
    int total;
    double tau;
    double sample;
    int check;

    // Initial population
    int pop = 0;

    // Initializing time
    double time = 0;
    double maxTime = 100000;

    // Birth rate
    int birth = 1000;

    // Start the timer
    clock_t time_elapsed = clock();

    // Body of the gillespie
    while (time < maxTime) {
        // Setting the propensity
        death = pop;

        // Sum over the propensities
        total = birth + death;

        // Check if array is empty
        check = counter % count;

        if (check == 0) {
            // Generate the new arrays
            curandGenerateUniform(gen, tauURN, count);
            curandGenerateUniform(gen, distURN, count);
        }

        // Gives us the time step
        tau = (1.0 / total) * tauURN[check];

        // Second random choice
        sample = total * distURN[check];

        // Update populations
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

    // Calculate the time elapsed
    time_elapsed = clock() - time_elapsed;
    double timer = ((double) time_elapsed) / CLOCKS_PER_SEC;

    //Calculate the reactions per sec
    double rate = counter / timer;
    printf("Population: %f\n", pop);
    printf("Counter: %d\n", counter);
    printf("Timer: %f\n", timer);
    printf("Rate: %f\n", rate);

}

int main() {
    // Initialize streams
    cudaStream_t stream1, stream2, stream3, stream4, stream5;
    cudaStreamCreate(&stream1);
    cudaStreamCreate(&stream2);
    cudaStreamCreate(&stream3);
    cudaStreamCreate(&stream4);
    cudaStreamCreate(&stream5);

    // Create the generator
    curandGenerator_t gen;
    curandCreateGenerator(&gen, CURAND_RNG_PSEUDO_DEFAULT);

    int count = 2500000;
    float *tauURN;
    float *distURN;
    cudaMalloc((void **) &tauURN, count*sizeof(float));
    cudaMalloc((void **) &distURN, count*sizeof(float));

    // Run a single simulation on the device
    simulation<<<1, 1024, 0, stream1>>>(count, tauURN, distURN, gen);


    // FREE HOSTS
    cudaFreeHost(;alkdf;alkj);

    curandDestroyGenerator(gen);
    cudaFree(tauURN);
    cudaFree(distURN);
    return 0;
}
