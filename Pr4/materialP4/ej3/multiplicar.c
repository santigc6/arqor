#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <omp.h>
#include "arqo3.h"

void multiply(tipo **matrix1, tipo **matrix2, tipo **res, int n);
void multiply_l1(tipo **matrix1, tipo **matrix2, tipo **res, int n, int n_threads);
void multiply_l2(tipo **matrix1, tipo **matrix2, tipo **res, int n, int n_threads);
void multiply_l3(tipo **matrix1, tipo **matrix2, tipo **res, int n, int n_threads);

int main( int argc, char *argv[]){
    int n;
    int n_threads;
    int ser_par;
	tipo **m1=NULL;
    tipo **m2=NULL;
    tipo **res=NULL;
	struct timeval fin,ini;

    /* Comprobacion de los parametros de entrada */
	if( argc!=4 ){
		printf("Error: %s <matrix size> <ser_par> <threads>\nwhere ser_par possible values are: 0->ser, 1->par_loop1, 2->par_loop2, 3->par_loop3\n", argv[0]);
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
	
	ser_par=atoi(argv[2]);
	n_threads=atoi(argv[3]);
	
	if(ser_par == 0){
		/* En este instante comenzamos a medir tiempos */
		gettimeofday(&ini,NULL);

		/* Main computation */
		multiply(m1, m2, res, n);
		/* End of computation */

		gettimeofday(&fin,NULL);
		printf("Execution time: %f\n", ((fin.tv_sec*1000000+fin.tv_usec)-(ini.tv_sec*1000000+ini.tv_usec))*1.0/1000000.0);
	} else if(ser_par == 1){
		/* En este instante comenzamos a medir tiempos */
		gettimeofday(&ini,NULL);

		/* Main computation */
		multiply_l1(m1, m2, res, n, n_threads);
		/* End of computation */

		gettimeofday(&fin,NULL);
		printf("Execution time: %f\n", ((fin.tv_sec*1000000+fin.tv_usec)-(ini.tv_sec*1000000+ini.tv_usec))*1.0/1000000.0);
	} else if(ser_par == 2){
		/* En este instante comenzamos a medir tiempos */
		gettimeofday(&ini,NULL);

		/* Main computation */
		multiply_l2(m1, m2, res, n, n_threads);
		/* End of computation */

		gettimeofday(&fin,NULL);
		printf("Execution time: %f\n", ((fin.tv_sec*1000000+fin.tv_usec)-(ini.tv_sec*1000000+ini.tv_usec))*1.0/1000000.0);
	} else if(ser_par == 3){
		/* En este instante comenzamos a medir tiempos */
		gettimeofday(&ini,NULL);

		/* Main computation */
		multiply_l3(m1, m2, res, n, n_threads);
		/* End of computation */

		gettimeofday(&fin,NULL);
		printf("Execution time: %f\n", ((fin.tv_sec*1000000+fin.tv_usec)-(ini.tv_sec*1000000+ini.tv_usec))*1.0/1000000.0);
	}

	freeMatrix(m1);
    freeMatrix(m2);
    freeMatrix(res);
	return 0;
}

void multiply(tipo **matrix1, tipo **matrix2, tipo **res, int n) {
    int i, j, k;
    tipo s = 0;
    for(i = 0; i < n; i++){
        for(j = 0; j < n ; j++){
            s = 0;
            for(k = 0; k < n; k++){
                s += matrix1[i][k] * matrix2[k][j];
            }
            res[i][j] = s;
        }
    }
}

void multiply_l1(tipo **matrix1, tipo **matrix2, tipo **res, int n, int n_threads) {
    int i, j, k;
    tipo s = 0;
    omp_set_num_threads(n_threads);
    
    for(i = 0; i < n; i++){
        for(j = 0; j < n ; j++){
            s = 0;
            #pragma omp parallel for reduction(+:s) shared(matrix1, matrix2, n, res, i, j) private(k)
            for(k = 0; k < n; k++){
                s += matrix1[i][k] * matrix2[k][j];
            }
            res[i][j] = s;
        }
    }
}

void multiply_l2(tipo **matrix1, tipo **matrix2, tipo **res, int n, int n_threads) {
    int i, j, k;
    tipo s = 0;
    omp_set_num_threads(n_threads);
    
    for(i = 0; i < n; i++){
    	#pragma omp parallel for reduction(+:s) shared(matrix1, matrix2, n, res, i) private(j, k)
        for(j = 0; j < n ; j++){
            s = 0;
            for(k = 0; k < n; k++){
                s += matrix1[i][k] * matrix2[k][j];
            }
            res[i][j] = s;
        }
    }
}

void multiply_l3(tipo **matrix1, tipo **matrix2, tipo **res, int n, int n_threads) {
    int i, j, k;
    tipo s = 0;
    omp_set_num_threads(n_threads);
    
    #pragma omp parallel for reduction(+:s) shared(matrix1, matrix2, n, res) private(i, j, k)
    for(i = 0; i < n; i++){
        for(j = 0; j < n ; j++){
            s = 0;
            for(k = 0; k < n; k++){
                s += matrix1[i][k] * matrix2[k][j];
            }
            res[i][j] = s;
        }
    }
}
