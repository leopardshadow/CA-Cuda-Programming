#include "parameters.h"


__global__ void cuda_kernel(int *B,int *A,IndexSave *dInd)
{	
	//
	int i = 0;
	int totalThread = blockDim.x * gridDim.x;
	int stripe = totalThread;
	int head = blockDim.x * blockIdx.x + threadIdx.x;
	for(i = head; i < SIZE; i+=stripe) {
		dInd[i].blockInd_x = blockIdx.x;
		dInd[i].threadInd_x = threadIdx.x;
		dInd[i].head = head;
		dInd[i].stripe = stripe;
		for(int j=1;j<LOOP;j++) {
			B[i]*=A[i];
		}
	}
};


float GPU_kernel(int *B,int *A,IndexSave* indsave){

	int *dA,*dB;
	IndexSave* dInd;

	// Creat Timing Event
  	cudaEvent_t start, stop;
	cudaEventCreate (&start);
	cudaEventCreate (&stop); 	

	// Allocate Memory Space on Device
	cudaMalloc((void**)&dA,sizeof(int)*SIZE);
	cudaMalloc((void**)&dB,sizeof(int)*SIZE);

	// Allocate Memory Space on Device (for observation)
	cudaMalloc((void**)&dInd,sizeof(IndexSave)*SIZE);

	// Copy Data to be Calculated
	cudaMemcpy(dA, A, sizeof(int)*SIZE, cudaMemcpyHostToDevice);
	cudaMemcpy(dB, A, sizeof(int)*SIZE, cudaMemcpyHostToDevice);

	// Copy Data (indsave array) to device
	cudaMemcpy(dInd, indsave, sizeof(IndexSave)*SIZE, cudaMemcpyHostToDevice);
	
	// Start Timer
	cudaEventRecord(start, 0);

	// Lunch Kernel
	dim3 dimGrid(2);
	dim3 dimBlock(4);
	cuda_kernel<<<dimGrid,dimBlock>>>(dB,dA,dInd);

	// Stop Timer
	cudaEventRecord(stop, 0);
  	cudaEventSynchronize(stop); 

	// Copy Output back
	cudaMemcpy(indsave, dInd, sizeof(IndexSave)*SIZE, cudaMemcpyDeviceToHost);
	cudaMemcpy(B, dB, sizeof(int)*SIZE, cudaMemcpyDeviceToHost);

	// Release Memory Space on Device
	cudaFree(dA);
	cudaFree(dB);
	cudaFree(dInd);

	// Calculate Elapsed Time
  	float elapsedTime; 
  	cudaEventElapsedTime(&elapsedTime, start, stop);  

	return elapsedTime;
}
