/*
* Alex Laubscher
* Gillespie Algorithm
*/

#include <stdio.h>
#include <time.h>
#define SIZE 1024

int main(void) {
    // Starting the timer
    clock_t time_elapsed = clock();

    // Initializing variables for the while loop
    // double counter;
    int total;
    double tau;
    double sample;

    // Initial population
    int pop = 0;

    // Initializing time
    double time = 0;
    double maxTime = 100000;

    // Moved this outside because its going to be constant
    int birth = 1000;
    
    // Run the while loop over 100,000 simulation seconds
    while (time < maxTime) {
	
        // Sum over the propensities
        total = birth + pop;

        // Calculate time step
        tau = (1.0 / total) * log((double) rand() / (RAND_MAX));

        // Second random choice
        sample = total * ((double) rand() / (RAND_MAX));

        // Update populations based on second urn
        if (sample < birth) {
            pop++;
        } else {
            pop--;
        }

        // Update the time step
        time = time - tau;

        // Increment the counter
        // counter++;
    }

    // End the time and convert to sec
    time_elapsed = (clock() - time_elapsed);
    double timer = ((double) time_elapsed) / CLOCKS_PER_SEC;

    // Calculate the reactions per sec
    double rate = 200020751 / timer;
    printf("Population: %d\n", pop);
    // printf("Counter: %f\n", counter);
    printf("Timer: %f\n", timer);
    printf("Rate: %f\n", rate);
}
