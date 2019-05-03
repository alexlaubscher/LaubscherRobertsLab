CC=g++
NVCC=nvcc
CXXFLAGS= -fopenmp -O3 -Wextra -std=c++11
CUDAFLAGS= -std=c++11 -c -arch=sm_35
LIBS= -lopenblas -lpthread -lcudart -lcublas
LIBDIRS=-L/usr/local/lib

dynamicGillespie.o: dynamicGillespie.cu
	$(NVCC) $(CUDAFLAGS)   dynamicGillespie.cu
all: dynamicGillespie.o
	$(CC) -o test dynamicGillespie.o $(LIBDIRS) $(LIBS) $(CXXFLAGS)
clean:
	rm -rf test *.o
