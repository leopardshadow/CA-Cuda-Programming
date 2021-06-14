
#include <stdio.h>
#include <stdlib.h>

#include "parameters.h"

#define T(x, y) ((x) + (N+2)*(y))

extern float GPU_kernel(int *B, int *A);

u_int8_t state[N][N]; 
// = {
//     {'1','0','0','0','1'},
//     {'0','0','1','0','0'},
//     {'0','1','1','1','0'},
//     {'0','0','1','0','0'},
//     {'0','1','0','1','0'},
// };

u_int8_t event[2][ (N+2) * (N+2) ] =  {0};

u_int8_t *gpuEvent[2];

u_int8_t *result;

void simulate(u_int8_t *now, u_int8_t *next) {
    int i, j, t;
    int adjac;
    for(i = 1; i <= N; i++) {
        for(j = 1; j <= N; j++) {
            adjac = 
                now[T(i-1, j-1)] + now[T(i, j-1)] + now[T(i+1, j-1)] + 
                now[T(i-1, j)]   +                + now[T(i+1, j)]   + 
                now[T(i-1, j+1)] + now[T(i, j+1)] + now[T(i+1, j+1)];


            t = now[T(i, j)];

    
            if((!t && adjac == 3) || (t && adjac == 2) || (t && adjac == 3)) {
                next[T(i, j)] = 1;
            }
            else {
                next[T(i, j)] = 0;
            }
            // printf("%d %d: %c - %d\n", i, j, '0'+next[T(i, j)], adjac);
        }

    }
}


void runSimulations() {
    
    // do simulation m times
    for(int m = 0; m < M; m++) {

        simulate(event[m%2], event[(m+1)%2]);
    }
    result = event[M%2];
}

__global__ void gpu_simulate(u_int8_t *dNow, u_int8_t *dNext)
{	
    int i, j;
    int t, adjac;

    int stripeI = N / gridNum;
    int stripeJ = N / blockNum;

    for(i = 1; i <= N; i+=stripeI) {
        for(j = 1; j <= N; j+=stripeJ) {

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



void runGPUSimulations() {
    

	cudaMalloc((void**)&gpuEvent[0], sizeof(u_int8_t)*((N+2)*(N+2)));
	cudaMalloc((void**)&gpuEvent[1], sizeof(u_int8_t)*((N+2)*(N+2)));

    cudaMemcpy(gpuEvent[0], event[0], sizeof(u_int8_t)*((N+2)*(N+2)), cudaMemcpyHostToDevice);
    cudaMemcpy(gpuEvent[1], event[1], sizeof(u_int8_t)*((N+2)*(N+2)), cudaMemcpyHostToDevice);

    // Launch Kernel
	dim3 dimGrid(blockNum);
    dim3 dimBlock(gridNum);

    for(int m = 0; m < M; m++) {
        gpu_simulate<<<dimGrid,dimBlock>>>(gpuEvent[m%2], gpuEvent[(m+1)%2]);
    }

	cudaMemcpy(event[0], gpuEvent[0], sizeof(u_int8_t)*((N+2)*(N+2)), cudaMemcpyDeviceToHost);
	cudaMemcpy(event[1], gpuEvent[1], sizeof(u_int8_t)*((N+2)*(N+2)), cudaMemcpyDeviceToHost);

    result = event[M%2];
}



int main(int argc, char const *argv[])
{
    int i, j;

    state[150][49] = 1;
    state[150][50] = 1;
    state[150][51] = 1;

    for(i = 1; i <= N; i++) {
        for(j = 1; j <= N; j++) {
            event[0][T(i, j)] = state[i-1][j-1];
        }
    }

    // for(i = 0; i <= N+1; i++) {
    //     for(j = 0; j <= N+1; j++) {
    //         printf("%c", event[0][T(i, j)] + '0');
    //     }
    //     printf("\n");
    // }
    // printf("\n-----\n");

    
    // runSimulations();

    runGPUSimulations();

    for(i = 0; i <= N+1; i++) {
        for(j = 0; j <= N+1; j++) {
            if(result[T(i, j)] == 1) {
                printf("alive: x = %d, y = %d\n", i, j);
            }
        }
    }



    return 0;
}