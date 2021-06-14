
#include <stdio.h>
#include <stdlib.h>

#define T(x, y) ((x) + (N+2)*(y))

const int N = 5; // NxN grid
int M = 1; // M rounds

u_int8_t state[N][N] = {
    {'1','0','0','0','1'},
    {'0','0','1','0','0'},
    {'0','1','1','1','0'},
    {'0','0','1','0','0'},
    {'0','1','0','1','0'},
};

u_int8_t event[2][ (N+2) * (N+2) ] =  {0};

int simulate(int r) {
    int i, j, t;
    int nr = (r + 1) % 2;
    int adjac;
    for(i = 1; i <= N; i++) {
        for(j = 1; j <= N; j++) {
            adjac = 
                event[r][T(i-1, j-1)] + event[r][T(i, j-1)] + event[r][T(i+1, j-1)] + 
                event[r][T(i-1, j)]   +                     + event[r][T(i+1, j)]   + 
                event[r][T(i-1, j+1)] + event[r][T(i, j+1)]   + event[r][T(i+1, j+1)];


            t = event[r][T(i, j)];

    
            if((!t && adjac == 3) || (t && adjac == 2) || (t && adjac == 3)) {
                event[nr][T(i, j)] = 1;
            }
            else {
                event[nr][T(i, j)] = 0;
            }
            // printf("%d %d: %c - %d\n", i, j, '0'+event[nr][T(i, j)], adjac);
        }

    }
    return nr;
}


int runSimulations() {
    
    int r = 0;

    // do simulation m times
    for(int m = 0; m < M; m++) {

        r = simulate(r);
    }
    return r;
}

int main(int argc, char const *argv[])
{
    int i, j;
    int r;

    for(i = 1; i <= N; i++) {
        for(j = 1; j <= N; j++) {
            event[0][T(i, j)] = state[i-1][j-1] - '0';
        }
    }

    for(i = 0; i <= N+1; i++) {
        for(j = 0; j <= N+1; j++) {
            printf("%c", event[0][T(i, j)] + '0');
        }
        printf("\n");
    }
    printf("\n-----\n");

    
    r = runSimulations();

    for(i = 0; i <= N+1; i++) {
        for(j = 0; j <= N+1; j++) {
            printf("%c", event[r][T(i, j)] + '0');
        }
        printf("\n");
    }


    return 0;
}