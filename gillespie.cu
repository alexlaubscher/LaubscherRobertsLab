/*
* Alex Laubscher
* Gillespie Algorithm
*/

#include <stdio.h>
#include <time.h>
#define SIZE 1024

int main(void) {
    // Starting the timer
    clock_t start = clock();

    // Initializing pointers
    int *urn;
    int *d_urn;

    // Initializing variables for the while loop
    double counter;
    int birth;
    int death;
    int total;
    double tau;
    double sample;

    // Initial population
    int pop = 0;

    // Initializing time
    double time = 0;
    double maxTime = 1;

    // Allocating memory for the random numbers
    urn = (int *)malloc(SIZE * sizeof(int));
    cudaMalloc((void **) &d_urn, SIZE * sizeof(int));

    // Run the while loop over 100,000 simulation seconds
    while (time < maxTime) {
        // Setting the propensity of the rxn
        birth = 1000;
        death = pop;

        // Sum over the propensities
        total = birth + death;

        // Calculate time step
        tau = (1.0 / total) * log((rand() % 10000) / 10000.0);

        // Second random choice
        sample = total * (rand() % 10000) / 10000.0;

        // Update populations based on second urn
        if (sample < birth) {
            pop = pop + 1;
        } else {
            pop = pop - 1;
        }

        // Update the time step
        time = time - tau;

        // Increment the counter
        counter = counter + 1;
	printf("%f -- %f\n", tau, sample);
    }

    // End the time and convert to sec
    // clock_t end = clock();
    // int timer = (end - start) / CLOCKS_PER_SEC * 1000.0;

    // Calculate the reactions per sec
    // double rate = counter / timer;
    // printf("%d", timer);
}
