#!/bin/bash
make
rm -f ejercicio2/*
max_tam=
min_tam=34000000
tam=0
incr=$((max_tam/min_tam))
max_hilos=4
n_hilos=0

for((n_hilos = 0; n_hilos < $max_hilos; n_hilos++)); do
	for((tam=min_tam; tam < max_tam; tam += incr)); do
		./pescalar_serie tam
		./pescalar_par2 tam n_hilos
	done
done
