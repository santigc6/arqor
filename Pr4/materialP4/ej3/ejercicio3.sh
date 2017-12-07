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
reps=5
for((i = 0; i < $reps; i++)); do
	echo "Repeticion $i"
	for((tam=$min_tam; tam <= $max_tam; tam += $incr)); do
		echo "	Tamanio $tam"
		./multiplicar $tam 0 0 | grep "time" | awk -v t="$tam" '{print t" "$3}' >> mult_serie.dat
		./multiplicar $tam 3 4  | grep "time" | awk -v t="$tam" '{print t" "$3}' >> mult_paralelo3_4.dat
	done
done

awk -v n="$reps" '{valores[$1]+=$2} END{for(i in valores) print i" "valores[i]/n}' mult_serie.dat | sort -nk1 > mult_serie_media.dat
awk -v n="$reps" '{valores[$1]+=$2} END{for(i in valores) print i" "valores[i]/n}' mult_paralelo3_4.dat | sort -nk1 > mult_paralelo3_4_media.dat

paste mult_serie_media.dat mult_paralelo3_4_media.dat > aux4.dat

awk '{print $1" "$2/$4" "$2/$2}' aux4.dat > speedup34.dat

rm -f aux4.dat

rm -f mult_serie.dat mult_paralelo_4.dat

gnuplot << END_GNUPLOT
set title "Tiempo"
set ylabel "Tiempo"
set xlabel "Tamanio"
set key right bottom
set grid
set term png
set output "time.png"
plot "mult_serie_media.dat" using 1:2 with lines lw 2 title "m_serie", \
     "mult_paralelo3_4_media.dat" using 1:2 with lines lw 2 title "m_par3_4"
replot
quit
END_GNUPLOT

gnuplot << END_GNUPLOT
set title "Aceleracion"
set ylabel "Aceleracion"
set xlabel "Tamanio"
set key right bottom
set grid
set term png
set output "speedup.png"
plot "speedup34.dat" using 1:2 with lines lw 2 title "speedup_m3_4", \
     "speedup34.dat" using 1:3 with lines lw 2 title "speedup_s",
replot
quit
END_GNUPLOT

make clean
