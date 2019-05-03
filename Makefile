CC=g++
NVCC=nvcc
CXXFLAGS= -std=c++11 -arch=sm_35
CUDAFLAGS= -std=c++11 -c -arch=sm_35
LIBS= -lopenblas -lpthread -lcudart -lcublas
LIBDIRS=-L/usr/local/lib


all: test

test:
	$(NVCC) -o test dynamicGillespie.o $(LIBDIRS) $(LIBS) $(CXXFLAGS)

dynamicGillespie.o: dynamicGillespie.cu
	$(NVCC) $(CUDAFLAGS)   dynamicGillespie.cu

clean:
	rm -rf test *.o