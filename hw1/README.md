# hw1

## Build

```
nvcc main.cu device1.cu
```

OR

```
nvcc main.cu device2.cu
```

(`Makefile` & `configure.ocelot` are provided by the TA. Those files are used to build in a VirtualBox. But I don't use them. :))

## Run

```
./a.out
```

## Explantion

### Cuda Basics

```
            host (CPU)
              |
              | (kernel)
              v
           device (GPU)
+-------------------------------+
|             grid              |
+-------------------------------+
|    blocl 0    |    blocl 1    |
+-------------------------------+
| t0| t1| t2| t3| t0| t1| t2| t3|
+-------------------------------+
| 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
```

### Split the Data

The data in this assignment is an 1D length-16 array.
In this assignment, I perform two different ways to split the data, as shown below.

```
+---------------------------------------------------------------+
| 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10| 11| 12| 13| 14| 15|
+---------------------------------------------------------------+
  0   0   1   1   2   2   3   3   4   4   5   5   6   6   7   7 ----> device 1
  0   1   2   3   4   5   6   7   0   1   2   3   4   5   6   7 ----> device 2
```


## Notes

第一次寫 Cuda 程式，[cudaMemcpy](https://docs.nvidia.com/cuda/cuda-runtime-api/group__CUDART__MEMORY.html#group__CUDART__MEMORY_1gc263dbe6574220cc776b45438fc351e8) 是把 detination 放前面，source 放後面，和我一開始以為的相反。
