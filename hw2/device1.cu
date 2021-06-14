#include "parameters.h"

__global__ void gpu_simulate(u_int8_t *dNow, u_int8_t *dNext)
{	
    int i, j;
    int t, adjac;

    int limI = N / blockNum;
    int limJ = N / gridNum;

    for(i = threadIdx.x; i <= threadIdx.x + limI; i++) {
        for(j = blockIdx.x; j <= blockIdx.x + limJ; j++) {

            adjac = 
                dNow[T(i-1, j-1)] + dNow[T(i, j-1)] + dNow[T(i+1, j-1)] + 
                dNow[T(i-1, j)]   +                 + dNow[T(i+1, j)]   + 
                dNow[T(i-1, j+1)] + dNow[T(i, j+1)] + dNow[T(i+1, j+1)];
    
    
            t = dNow[T(i, j)];
        
            if((!t && adjac == 3) || (t && adjac == 2) || (t && adjac == 3)) {
                dNext[T(i, j)] = 1;
            }
            else {
                dNext[T(i, j)] = 0;
            }
        
        }
    }
    
}

u_int8_t *runGPUSimulations(u_int8_t event[2][(N+2)*(N+2)]) {
    
    u_int8_t *gpuEvent[2];

	cudaMalloc((void**)&gpuEvent[0], sizeof(u_int8_t)*((N+2)*(N+2)));
	cudaMalloc((void**)&gpuEvent[1], sizeof(u_int8_t)*((N+2)*(N+2)));

    cudaMemcpy(gpuEvent[0], event[0], sizeof(u_int8_t)*((N+2)*(N+2)), cudaMemcpyHostToDevice);
    cudaMemcpy(gpuEvent[1], event[1], sizeof(u_int8_t)*((N+2)*(N+2)), cudaMemcpyHostToDevice);

    // Launch Kernel
	dim3 dimGrid(gridNum);
    dim3 dimBlock(blockNum);

    for(int m = 0; m < M; m++) {
        gpu_simulate<<<dimGrid,dimBlock>>>(gpuEvent[m%2], gpuEvent[(m+1)%2]);
    }

	cudaMemcpy(event[0], gpuEvent[0], sizeof(u_int8_t)*((N+2)*(N+2)), cudaMemcpyDeviceToHost);
	cudaMemcpy(event[1], gpuEvent[1], sizeof(u_int8_t)*((N+2)*(N+2)), cudaMemcpyDeviceToHost);

    return event[M%2];
}
