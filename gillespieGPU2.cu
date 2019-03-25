/*
* Alex Laubscher
* Gillespie Algorithm
* Runs a singular simulation on a GPU
*/

#include <curand.h>
#include <stdio.h>
#include <time.h>

__device__ void simulation() {

}

int main() {
    // Start the timer 
    clock_t time_elapsed = clock();

    // Run a single simulation on the device
    simulation<<<1, 1>>>();

    // Calculate the time elapsed
    time_elapsed = clock() - time_elapsed;
    double timer = ((double) time_elapsed) / CLOCKS_PER_SEC;

    return 0;
}
