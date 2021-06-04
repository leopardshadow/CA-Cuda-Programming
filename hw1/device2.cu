#include "parameters.h"


__global__ void cuda_kernel(int *B,int *A,IndexSave *dInd)
{	
	//
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
