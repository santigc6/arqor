#!/bin/bash

make clean
make
chmod ugo+x slow
chmod ugo+x fast
# inicializar variables
aux=$(expr 1301 + 9)
P=$(expr $aux % 10)
echo Valor de P: $P
Ninicio=$((2000 + 1024*$P))
echo Inicio: $Ninicio
Npaso=64
echo Paso: $Npaso
Nfinal=$((2000 + 1024*($P+1)))
echo Final: $Nfinal

rm -f 

echo Introduzca el numero de repeticiones:
read Nreps

echo "Ejecutando slow y fast..."

for((Csize=1024 ; Csize <= 8192 ; Csize = Csize*2)); do
	echo "Tamanio de cache: $Csize"
	for ((K = 0 ; K < $Nreps ; K += 1)); do
		#Generamos un fichero por repetición
		echo "Repeticion: $K"
		fAUX=aux_rep_$Csize.$K.dat
		touch $fAUX
		for ((N = Ninicio ; N <= Nfinal ; N += Npaso)); do
			echo "N: $N / $Nfinal..."

			valgrind --tool=cachegrind --I1=$Csize,1,64 --D1=$Csize,1,64 --LL=8388608,1,64 --cachegrind-out-file=slow_out.dat ./slow $N
			slow_failures=$(cg_annotate slow_out.dat | grep "PROGRAM TOTALS" | awk 'BEGIN{FS=" "} {print $5" "$8}')
			valgrind --tool=cachegrind --I1=$Csize,1,64 --D1=$Csize,1,64 --LL=8388608,1,64 --cachegrind-out-file=fast_out.dat ./fast $N
			fast_failures=$(cg_annotate fast_out.dat | grep "PROGRAM TOTALS" | awk 'BEGIN{FS=" "} {print $5" "$8}')
			
			echo "$N $slow_failures $fast_failures" >> $fAUX
		done
	done
done

cat aux_rep_1024.* > all_1024.dat
cat aux_rep_2048.* > all_2048.dat
cat aux_rep_4096.* > all_4096.dat
cat aux_rep_8192.* > all_8192.dat

awk -v Nrep="$Nreps" '{r_slow[$1] = r_slow[$1] + $2; w_slow[$1] = w_slow[$1] + $3; r_fast[$1] = r_fast[$1] + $4; w_fast[$1] = w_fast[$1] + $5;} END{for(valor in r_slow) print valor" "(r_slow[valor]/Nrep)" "(w_slow[valor]/Nrep)" "(r_fast[valor]/Nrep)" "(w_fast[valor]/Nrep);}' all_1024.dat | sort -nk1 > cache_1024.dat
awk -v Nrep="$Nreps" '{r_slow[$1] = r_slow[$1] + $2; w_slow[$1] = w_slow[$1] + $3; r_fast[$1] = r_fast[$1] + $4; w_fast[$1] = w_fast[$1] + $5;} END{for(valor in r_slow) print valor" "(r_slow[valor]/Nrep)" "(w_slow[valor]/Nrep)" "(r_fast[valor]/Nrep)" "(w_fast[valor]/Nrep);}' all_2048.dat | sort -nk1 > cache_2048.dat
awk -v Nrep="$Nreps" '{r_slow[$1] = r_slow[$1] + $2; w_slow[$1] = w_slow[$1] + $3; r_fast[$1] = r_fast[$1] + $4; w_fast[$1] = w_fast[$1] + $5;} END{for(valor in r_slow) print valor" "(r_slow[valor]/Nrep)" "(w_slow[valor]/Nrep)" "(r_fast[valor]/Nrep)" "(w_fast[valor]/Nrep);}' all_4096.dat | sort -nk1 > cache_4096.dat
awk -v Nrep="$Nreps" '{r_slow[$1] = r_slow[$1] + $2; w_slow[$1] = w_slow[$1] + $3; r_fast[$1] = r_fast[$1] + $4; w_fast[$1] = w_fast[$1] + $5;} END{for(valor in r_slow) print valor" "(r_slow[valor]/Nrep)" "(w_slow[valor]/Nrep)" "(r_fast[valor]/Nrep)" "(w_fast[valor]/Nrep);}' all_8192.dat | sort -nk1 > cache_8192.dat

#echo "Generating plot..."
## llamar a gnuplot para generar el gráfico y pasarle directamente por la entrada
## estándar el script que está entre "<< END_GNUPLOT" y "END_GNUPLOT"
#gnuplot << END_GNUPLOT
#set title "Slow-Fast Failures"
#set ylabel "Execution time (s)"
#set xlabel "Matrix Size"
#set key right bottom
#set grid
#set term png
#set output "$fPNG"
#plot "$fDAT" using 1:2 with lines lw 2 title "slow", \
#     "$fDAT" using 1:3 with lines lw 2 title "fast"
#replot
#quit
#END_GNUPLOT

rm -rf slow fast all_*.dat aux_rep_*
