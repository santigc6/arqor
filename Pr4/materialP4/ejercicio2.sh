#!/bin/bash
paste ej2/pesc_serie_media.dat ej2/pesc_paralelo_0_media.dat ej2/pesc_paralelo_1_media.dat ej2/pesc_paralelo_2_media.dat ej2/pesc_paralelo_3_media.dat > ej2/aux.dat

awk '{print $1" "$2/$2" "$2/$4" "$2/$6" "$2/$8" "$2/$10}' ej2/aux.dat > ej2/speedups.dat

gnuplot << END_GNUPLOT
set title "Aceleracion"
set ylabel "Aceleracion"
set xlabel "Tamanio"
set key right bottom
set grid
set term png
set output "speedup.png"
plot "ej2/speedups.dat" using 1:2 with lines lw 2 title "p_serie", \
     "ej2/speedups.dat" using 1:3 with lines lw 2 title "p_par_1", \
     "ej2/speedups.dat" using 1:4 with lines lw 2 title "p_par_2", \
     "ej2/speedups.dat" using 1:5 with lines lw 2 title "p_par_3", \
     "ej2/speedups.dat" using 1:6 with lines lw 2 title "p_par_4"
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
plot "ej2/pesc_serie_media.dat" using 1:2 with lines lw 2 title "p_serie", \
     "ej2/pesc_paralelo_0_media.dat" using 1:2 with lines lw 2 title "p_par_1", \
     "ej2/pesc_paralelo_1_media.dat" using 1:2 with lines lw 2 title "p_par_2", \
     "ej2/pesc_paralelo_2_media.dat" using 1:2 with lines lw 2 title "p_par_3", \
     "ej2/pesc_paralelo_3_media.dat" using 1:2 with lines lw 2 title "p_par_4"
replot
quit
END_GNUPLOT

make clean
