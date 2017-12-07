#!/bin/bash
make
rm -f ej2/*
i=0
max_int=2147483647
max_tam=2010000000
min_tam=6500000
tam=0
incr=$(((max_tam-min_tam)/10))
max_hilos=4
n_hilos=0
reps=5
for((i = 0; i < $reps; i++)); do
	echo "Repeticion $i"
	for((tam=$min_tam; tam < $max_tam; tam += $incr)); do
		echo "	Tamanio $tam"
		./pescalar_serie $tam | grep "Tiempo" | awk -v -v "t=$tam" '{print t" "$2}' >> ej2/pesc_serie.dat
		for((n_hilos = 0; n_hilos < $max_hilos; n_hilos++)); do 
			./pescalar_par2 $tam $n_hilos | grep "Tiempo" | awk -v "t=$tam" '{print t" "$2}' >> ej2/pesc_paralelo_$n_hilos.dat 
		done
	done
done

awk -v "n=$reps" '{valores[$1]+=$2} END{for(i in valores) print valores[i]/n}' ej2/pesc_serie.dat | sort -nk1 > ej2/pesc_serie_media.dat
awk -v "n=$reps" '{valores[$1]+=$2} END{for(i in valores) print valores[i]/n}' ej2/pesc_paralelo_0.dat | sort -nk1 > ej2/pesc_paralelo_0_media.dat
awk -v "n=$reps" '{valores[$1]+=$2} END{for(i in valores) print valores[i]/n}' ej2/pesc_paralelo_1.dat | sort -nk1 > ej2/pesc_paralelo_1_media.dat
awk -v "n=$reps" '{valores[$1]+=$2} END{for(i in valores) print valores[i]/n}' ej2/pesc_paralelo_2.dat | sort -nk1 > ej2/pesc_paralelo_2_media.dat
awk -v "n=$reps" '{valores[$1]+=$2} END{for(i in valores) print valores[i]/n}' ej2/pesc_paralelo_3.dat | sort -nk1 > ej2/pesc_paralelo_3_media.dat

rm -f ej2/pesc_serie.dat ej2/pesc_paralelo_0.dat ej2/pesc_paralelo_1.dat ej2/pesc_paralelo_2.dat ej2/pesc_paralelo_3.dat

gnuplot << END_GNUPLOT
set title "Tiempo serie"
set ylabel "Tiempo"
set xlabel "Tamanio"
set key right bottom
set grid
set term png
set output "t_serie.png"
plot "ej2/pesc_serie_media.dat" using 1:2 with lines lw 2 title "p_serie"
replot
quit
END_GNUPLOT

gnuplot << END_GNUPLOT
set title "Tiempo paralelo"
set ylabel "Tiempo"
set xlabel "Tamanio"
set key right bottom
set grid
set term png
set output "t_paralelo.png"
plot "ej2/pesc_paralelo_0.dat" using 1:2 with lines lw 2 title "p_par_1", \
     "ej2/pesc_paralelo_1.dat" using 1:4 with lines lw 2 title "p_par_2", \
     "ej2/pesc_paralelo_2.dat" using 1:2 with lines lw 2 title "p_par_3", \
     "ej2/pesc_paralelo_3.dat" using 1:4 with lines lw 2 title "p_par_4"
replot
quit
END_GNUPLOT

make clean
