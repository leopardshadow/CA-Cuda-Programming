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


+---------------------------------------------------------------+
| 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10| 11| 12| 13| 14| 15|
+---------------------------------------------------------------+
```
