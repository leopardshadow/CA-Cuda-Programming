#include "parameters.h"

#ifndef T
#define T(x, y) ((x) + (N+2)*(y))
#endif


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


u_int8_t *runSimulations(u_int8_t event[2][(N+2)*(N+2)]) {
    
    // do simulation m times
    for(int m = 0; m < M; m++) {

        simulate(event[m%2], event[(m+1)%2]);
    }
    return event[M%2];
}