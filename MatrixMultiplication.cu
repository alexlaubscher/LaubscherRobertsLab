/*
* Alex Laubscher
* Matrix Multiplication
*/

#include <stdio.h>
#define SIZE 1024

__device__ void multiply(int *a, int *b, int *c, int *a_rows, int *a_cols,
    int *b_rows, int *b_cols) {
    // Will be the index for the product array
    int i = threadIdx.x;
    int block = b_rows * b_cols;
    int multiple = i / block;

    // Will be the index for the left matrix
    int offset = i % block;
    int j = multiple * block + offset;

    // Will be the index for the right matrix
    int rem = i / a_cols;
    int offset = i / (a_rows * a_cols);
    int k = rem * b_cols + offset;

    c[i] = b[j] * c[k];
}

__device__ void sum(int *temp, int *c, int *b_rows) {
    int i = threadIdx.x;
    int index = i / b_rows;
    c[index] += c[i];
}

int main(void) {
    // Initialize the pointers
    int *a, *b, *c;
    int *d_a, *d_b, *d_c, *d_temp;

    // Create the size of the elements
    int a_rows = 3;
    int a_cols = 2;
    int b_rows = 2;
    int b_cols = 4;
    int a_size = a_rows * a_cols * sizeof(int);
    int b_size = b_rows * b_cols * sizeof(int);
    int prod_size = a_rows * b_cols * sizeof(int);
    int temp_size = a_rows * a_cols * b_cols * sizeof(int);

    // Makes sure the matrices can even be multiplied
    if (a_cols != b_rows) {
        printf("Illegal Matrix Sizes\n");
        return 1;
    }

    // Allocate memory on GPU for matrices
    cudaMalloc((void **) &d_a, a_size);
    cudaMalloc((void **) &d_b, b_size);
    cudaMalloc((void **) &d_temp, temp_size);
    cudaMalloc((void **) &d_c, prod_size);

    // Allocate memory on the host
    a = (int *)malloc(a_size);
    b = (int *)malloc(b_size);
    c = (int *)malloc(prod_size);

    // Generate the matrices
    for (int i = 0; i < size; i++) {
        a[i] = i;
        b[i] = i;
    }

    // Move the matrices data to the GPU
    cudaMemcpy(d_a, a, a_size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, b_size, cudaMemcpyHostToDevice);

    // Initialize the kernel for multiplying the matrices
    multiply<<<1, temp_size>>>(d_a, d_b, d_c, a_rows, a_cols, b_rows, b_cols);

    // Initialize the kernel for summing the resultant matrix
    sum<<<1, temp_size>>>(d_temp, d_c, b_rows);

    // Move the product back to the host
    cudaMemcpy(c, d_c, prod_size, cudaMemcpyDeviceToHost);

    // Print out the results
    for (int i = 0; i < prod_size; i++) {
        printf("c[%d] = %d\n", i, c[i]);
    }

    // Free the memory
    free(a); free(b); free(c);
    cudaFree(d_a); cudaFree(d_b); cudaFree(d_c); cudaFree(d_temp);

    return 0;
}
