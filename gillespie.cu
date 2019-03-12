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

    // Initializing variables for the while loop
    double counter;
    int birth;
    int *death;
    int total;
    double tau;
    double sample;

    // Initial population
    double pop = 0;

    // Initializing time
    double time = 0;
    double maxTime = 100000;

    // Moved this outside because its going to be constant
    birth = 1000;
    death = pop;

    // Run the while loop over 100,000 simulation seconds
    while (time < maxTime) {

        // Sum over the propensities
        total = birth + death;

        // Calculate time step
        tau = (1.0 / total) * log((double) rand() / (RAND_MAX));

        // Second random choice
        sample = total * ((double) rand() / (RAND_MAX));

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
    int timer = (end - start) / CLOCKS_PER_SEC;

    //Calculate the reactions per sec
    double rate = counter / timer;
    printf("Population: %f\n", pop);
    printf("Counter: %f\n", counter);
    printf("Timer: %d\n", timer);
    printf("Rate: %f\n", rate);
}
