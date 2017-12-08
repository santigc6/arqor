#!/bin/bash
make
rm -f ej2/*
i=0
max_tam=800000000
min_tam=100000000
tam=0
incr=$(((max_tam-min_tam)/10))
max_hilos=4
n_hilos=0
reps=5
for((i = 0; i < $reps; i++)); do
	echo "Repeticion $i"
	for((tam=$min_tam; tam <= $max_tam; tam += $incr)); do
		echo "	Tamanio $tam"
		./pescalar_serie $tam | grep "Tiempo" | awk -v t="$tam" '{print t" "$2}' >> ej2/pesc_serie.dat
		for((n_hilos = 1; n_hilos <= $max_hilos; n_hilos++)); do
			./pescalar_par2 $tam $n_hilos | grep "Tiempo" | awk -v t="$tam" '{print t" "$2}' >> ej2/pesc_paralelo_$n_hilos.dat 
		done
	done
done

awk -v n="$reps" '{valores[$1]+=$2} END{for(i in valores) print i" "valores[i]/n}' ej2/pesc_serie.dat | sort -nk1 > ej2/pesc_serie_media.dat
awk -v n="$reps" '{valores[$1]+=$2} END{for(i in valores) print i" "valores[i]/n}' ej2/pesc_paralelo_1.dat | sort -nk1 > ej2/pesc_paralelo_1_media.dat
awk -v n="$reps" '{valores[$1]+=$2} END{for(i in valores) print i" "valores[i]/n}' ej2/pesc_paralelo_2.dat | sort -nk1 > ej2/pesc_paralelo_2_media.dat
awk -v n="$reps" '{valores[$1]+=$2} END{for(i in valores) print i" "valores[i]/n}' ej2/pesc_paralelo_3.dat | sort -nk1 > ej2/pesc_paralelo_3_media.dat
awk -v n="$reps" '{valores[$1]+=$2} END{for(i in valores) print i" "valores[i]/n}' ej2/pesc_paralelo_4.dat | sort -nk1 > ej2/pesc_paralelo_4_media.dat

rm -f ej2/pesc_serie.dat ej2/pesc_paralelo_1.dat ej2/pesc_paralelo_2.dat ej2/pesc_paralelo_3.dat ej2/pesc_paralelo_4.dat

paste ej2/pesc_serie_media.dat ej2/pesc_paralelo_1_media.dat ej2/pesc_paralelo_2_media.dat ej2/pesc_paralelo_3_media.dat ej2/pesc_paralelo_4_media.dat > ej2/aux.dat

awk '{print $1" "$2/$2" "$2/$4" "$2/$6" "$2/$8" "$2/$10}' ej2/aux.dat > ej2/speedups.dat

cd ej2

gnuplot << END_GNUPLOT
set title "Aceleracion"
set ylabel "Aceleracion"
set xlabel "Tamanio"
set key right bottom
set grid
set term png
set output "speedup.png"
plot "speedups.dat" using 1:2 with lines lw 2 title "p_serie", \
     "speedups.dat" using 1:3 with lines lw 2 title "p_par_1", \
     "speedups.dat" using 1:4 with lines lw 2 title "p_par_2", \
     "speedups.dat" using 1:5 with lines lw 2 title "p_par_3", \
     "speedups.dat" using 1:6 with lines lw 2 title "p_par_4"
replot
quit
END_GNUPLOT

gnuplot << END_GNUPLOT
set title "Tiempo"
set ylabel "Tiempo"
set xlabel "Tamanio"
set key right bottom
set grid
set term png
set output "times.png"
plot "pesc_serie_media.dat" using 1:2 with lines lw 2 title "p_serie", \
     "pesc_paralelo_1_media.dat" using 1:2 with lines lw 2 title "p_par_1", \
     "pesc_paralelo_2_media.dat" using 1:2 with lines lw 2 title "p_par_2", \
     "pesc_paralelo_3_media.dat" using 1:2 with lines lw 2 title "p_par_3", \
     "pesc_paralelo_4_media.dat" using 1:2 with lines lw 2 title "p_par_4"
replot
quit
END_GNUPLOT

cd ..

make clean
