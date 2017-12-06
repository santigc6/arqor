// ----------- Arqo P4-----------------------
// Programa que crea hilos utilizando OpenMP
//
#include <omp.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
	int tid,nthr,nproc;
	int arg;
	
	if(argc <= 1 || argc >= 3){
		fprintf(stderr, "Error, solo se espera un argumento de entrada:\n\t./omp1 n_hilos\n");
		
		return 1;
	}
	
	nproc = omp_get_num_procs();
	
	printf("Hay %d cores disponibles\n", nproc);

	arg = atoi( argv[1] );	
	omp_set_num_threads(arg);
	nthr = omp_get_max_threads();
	printf("Me han pedido que lance %d hilos\n", nthr);
	
	#pragma omp parallel private(tid)
	{
		tid = omp_get_thread_num();
		nthr = omp_get_num_threads();
		printf("Hola, soy el hilo %d de %d\n", tid, nthr);
	}
	
	return 0;
}
