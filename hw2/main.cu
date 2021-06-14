
#include <stdio.h>
#include <stdlib.h>

#include "host.h"

#include "parameters.h"

extern u_int8_t *runGPUSimulations(u_int8_t event[2][(N+2)*(N+2)]);

u_int8_t state[N][N]; 
// = {
//     {'1','0','0','0','1'},
//     {'0','0','1','0','0'},
//     {'0','1','1','1','0'},
//     {'0','0','1','0','0'},
//     {'0','1','0','1','0'},
// };

u_int8_t event[2][ (N+2) * (N+2) ] =  {0};

u_int8_t *result;

int main(int argc, char const *argv[])
{
    int i, j;

    state[5][3] = 1;
    state[5][4] = 1;
    state[5][5] = 1;

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

    
    result = runSimulations(event);

    // result = runGPUSimulations(event);

    for(i = 0; i <= N+1; i++) {
        for(j = 0; j <= N+1; j++) {
            if(result[T(i, j)] == 1) {
                printf("alive: x = %d, y = %d\n", i, j);
            }
        }
    }



    return 0;
}