#!/bin/bash
make
rm -f *.dat
i=0
aux=$((33 % 8))
P=$(($aux + 1))
max_tam=$((1024+512+$P))
min_tam=$((512+$P))
tam=0
incr=64
max_hilos=4
n_hilos=0
reps=5
for((i = 0; i < $reps; i++)); do
	echo "Repeticion $i"
	for((tam=$min_tam; tam < $max_tam; tam += $incr)); do
		echo "	Tamanio $tam"
		./multiplicar $tam 0 $n_hilos | grep "time" | awk -v -v "t=$tam" '{print t" "$3}' >> mult_serie.dat
		for((n_hilos = 0; n_hilos < $max_hilos; n_hilos++)); do 
			./multiplicar $tam 1 $n_hilos  | grep "time" | awk -v "t=$tam" '{print t" "$3}' >> mult_paralelo1_$n_hilos.dat
			./multiplicar $tam 2 $n_hilos  | grep "time" | awk -v "t=$tam" '{print t" "$3}' >> mult_paralelo2_$n_hilos.dat
			./multiplicar $tam 3 $n_hilos  | grep "time" | awk -v "t=$tam" '{print t" "$3}' >> mult_paralelo3_$n_hilos.dat
		done
	done
done

awk -v "n=$reps" '{valores[$1]+=$2} END{for(i in valores) print i" "valores[i]/n}' mult_serie.dat | sort -nk1 > mult_serie_media.dat
awk -v "n=$reps" '{valores[$1]+=$2} END{for(i in valores) print i" "valores[i]/n}' mult_paralelo1_0.dat | sort -nk1 > mult_paralelo1_0_media.dat
awk -v "n=$reps" '{valores[$1]+=$2} END{for(i in valores) print i" "valores[i]/n}' mult_paralelo1_1.dat | sort -nk1 > mult_paralelo1_1_media.dat
awk -v "n=$reps" '{valores[$1]+=$2} END{for(i in valores) print i" "valores[i]/n}' mult_paralelo1_2.dat | sort -nk1 > mult_paralelo1_2_media.dat
awk -v "n=$reps" '{valores[$1]+=$2} END{for(i in valores) print i" "valores[i]/n}' mult_paralelo1_3.dat | sort -nk1 > mult_paralelo1_3_media.dat

paste mult_serie_media.dat mult_paralelo1_0_media.dat > aux1.dat
paste mult_serie_media.dat mult_paralelo1_1_media.dat > aux2.dat
paste mult_serie_media.dat mult_paralelo1_2_media.dat > aux3.dat
paste mult_serie_media.dat mult_paralelo1_3_media.dat > aux4.dat

awk '{print $1" "$2/$4}' aux1.dat > speedup11.dat
awk '{print $1" "$2/$4}' aux2.dat > speedup12.dat
awk '{print $1" "$2/$4}' aux3.dat > speedup13.dat
awk '{print $1" "$2/$4}' aux4.dat > speedup14.dat

rm -f aux*.dat

awk -v "n=$reps" '{valores[$1]+=$2} END{for(i in valores) print i" "valores[i]/n}' mult_paralelo2_0.dat | sort -nk1 > mult_paralelo2_0_media.dat
awk -v "n=$reps" '{valores[$1]+=$2} END{for(i in valores) print i" "valores[i]/n}' mult_paralelo2_1.dat | sort -nk1 > mult_paralelo2_1_media.dat
awk -v "n=$reps" '{valores[$1]+=$2} END{for(i in valores) print i" "valores[i]/n}' mult_paralelo2_2.dat | sort -nk1 > mult_paralelo2_2_media.dat
awk -v "n=$reps" '{valores[$1]+=$2} END{for(i in valores) print i" "valores[i]/n}' mult_paralelo2_3.dat | sort -nk1 > mult_paralelo2_3_media.dat

paste mult_serie_media.dat mult_paralelo2_0_media.dat > aux1.dat
paste mult_serie_media.dat mult_paralelo2_1_media.dat > aux2.dat
paste mult_serie_media.dat mult_paralelo2_2_media.dat > aux3.dat
paste mult_serie_media.dat mult_paralelo2_3_media.dat > aux4.dat

awk '{print $1" "$2/$4}' aux1.dat > speedup21.dat
awk '{print $1" "$2/$4}' aux2.dat > speedup22.dat
awk '{print $1" "$2/$4}' aux3.dat > speedup23.dat
awk '{print $1" "$2/$4}' aux4.dat > speedup24.dat

rm -f aux*.dat

awk -v "n=$reps" '{valores[$1]+=$2} END{for(i in valores) print i" "valores[i]/n}' mult_paralelo3_0.dat | sort -nk1 > mult_paralelo3_0_media.dat
awk -v "n=$reps" '{valores[$1]+=$2} END{for(i in valores) print i" "valores[i]/n}' mult_paralelo3_1.dat | sort -nk1 > mult_paralelo3_1_media.dat
awk -v "n=$reps" '{valores[$1]+=$2} END{for(i in valores) print i" "valores[i]/n}' mult_paralelo3_2.dat | sort -nk1 > mult_paralelo3_2_media.dat
awk -v "n=$reps" '{valores[$1]+=$2} END{for(i in valores) print i" "valores[i]/n}' mult_paralelo3_3.dat | sort -nk1 > mult_paralelo3_3_media.dat

paste mult_serie_media.dat mult_paralelo3_0_media.dat > aux1.dat
paste mult_serie_media.dat mult_paralelo3_1_media.dat > aux2.dat
paste mult_serie_media.dat mult_paralelo3_2_media.dat > aux3.dat
paste mult_serie_media.dat mult_paralelo3_3_media.dat > aux4.dat

awk '{print $1" "$2/$4}' aux1.dat > speedup31.dat
awk '{print $1" "$2/$4}' aux2.dat > speedup32.dat
awk '{print $1" "$2/$4}' aux3.dat > speedup33.dat
awk '{print $1" "$2/$4}' aux4.dat > speedup34.dat

rm -f aux*.dat

rm -f mult_serie.dat mult_paralelo_0.dat mult_paralelo_1.dat mult_paralelo_2.dat mult_paralelo_3.dat

gnuplot << END_GNUPLOT
set title "Tiempo serie"
set ylabel "Tiempo"
set xlabel "Tamanio"
set key right bottom
set grid
set term png
set output "t_serie.png"
plot "mult_serie_media.dat" using 1:2 with lines lw 2 title "m_serie"
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
plot "mult_paralelo_0.dat" using 1:2 with lines lw 2 title "m_par_1", \
     "mult_paralelo_1.dat" using 1:4 with lines lw 2 title "m_par_2", \
     "mult_paralelo_2.dat" using 1:2 with lines lw 2 title "m_par_3", \
     "mult_paralelo_3.dat" using 1:4 with lines lw 2 title "m_par_4"
replot
quit
END_GNUPLOT

make clean
