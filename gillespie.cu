/*
* Alex Laubscher
* Gillespie Algorithm
*/

// blah

#include <stdio.h>
#define SIZE 1024

int main(void) {
    // Initializing variables
    int *urn;
    int *d_urn;

    // Initial population
    int pop = 0;

    // Initializing time
    time = 0;
    maxTime = 1000;

    // Allocating memory for the random numbers
    urn = (int *)malloc(SIZE * sizeof(int));
    d_urn = cudaMalloc((void **) &d_urn, SIZE * sizeof(int));

    // Run the while loop over 100,000 simulation seconds
    while (time < maxTime) {
        // Setting the propensity of the rxn
        birth = 1000;
        death = pop;

        // Sum over the propensities
        total = birth + death;

        // Calculate time step
        tau = 1 / total * log(rand());

        // Second random choice
        sample = total * rand();

        // Update populations based on second urn
        if (sample < birth) {
            y1 += 1;
        } else {
            y1 -= 1;
        }

        // Update the time step
        time = time - tau
    }
}
