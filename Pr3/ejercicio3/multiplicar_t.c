#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#include "arqo3.h"

void multiply_t(tipo **matrix1, tipo **matrix2, tipo **res, int n);
void transpose(tipo **m, tipo **t, int n);

int main( int argc, char *argv[]){
	int n;
    int i;
	tipo **m1=NULL;
    tipo **m2=NULL;
    tipo **mt=NULL;
    tipo **res=NULL;
	struct timeval fin,ini;

    /* Comprobacion de los parametros de entrada */
	if( argc!=2 ){
		printf("Error: ./%s <matrix size>\n", argv[0]);
		return -1;
	}

    /* Creamos las matrices operando y resultado (vacia) */
	n=atoi(argv[1]);
	m1 = generateMatrix(n);
    if(!m1){
		return -1;
	}
    m2 = generateMatrix(n);
    if(!m2){
        freeMatrix(m1);
		return -1;
	}
    res = generateEmptyMatrix(n);
    if(!res){
        freeMatrix(m1);
        freeMatrix(m2);
		return -1;
	}
    mt = generateEmptyMatrix(n);
    if(!res){
        freeMatrix(m1);
        freeMatrix(m2);
        freeMatrix(res);
        return -1;
    }

    /* En este instante comenzamos a medir tiempos */
	gettimeofday(&ini,NULL);

	/* Main computation */
    transpose(m2, mt, n);
    multiply_t(m1, mt, res, n);
	/* End of computation */

	gettimeofday(&fin,NULL);
	printf("Execution time: %f\n", ((fin.tv_sec*1000000+fin.tv_usec)-(ini.tv_sec*1000000+ini.tv_usec))*1.0/1000000.0);

	freeMatrix(m1);
    freeMatrix(m2);
    freeMatrix(res);
    freeMatrix(mt);
	return 0;
}

void multiply_t(tipo **matrix1, tipo **matrix2, tipo **res, int n) {
    int i, j, k;
    tipo s = 0;
    for(i = 0; i < n; i++){
        for(j = 0; j < n ; j++){
            s = 0;
            for(k = 0; k < n; k++){
                s += matrix1[i][k] * matrix2[j][k];
            }
            res[i][j] = s;
        }
    }
}

void transpose(tipo **m, tipo **t, int n){
    int i, j;
    for(i = 0; i < n ; i++){
        for(j = 0; j < n; j++){
            t[i][j] = m[j][i];
        }
    }
}
