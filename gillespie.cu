/*
* Alex Laubscher
* Gillespie Algorithm
*/

#include <stdio.h>
#define SIZE 1024

int main(void) {
    // Starting the timer
    clock_t start = clock();

    // Initializing pointers
    int *urn;
    int *d_urn;

    // Initializing variables for the while loop
    int counter;
    int birth;
    int death;
    int total;
    int tau;
    int sample;

    // Initial population
    int pop = 0;

    // Initializing time
    int time = 0;
    int maxTime = 1000;

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
        time = time - tau;

        // Increment the counter
        counter++;
    }

    // End the time and convert to sec
    clock_t end = clock();
    double time = (double) (end - start) / CLOCKS_PER_SEC * 1000.0;

    // Calculate the reactions per sec
     double rate = counter / time;
    printf("%d", rate);
}
