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

fDAT=slow_fast_cache.dat
fPNG=slow_fast_cache.png

# borrar el fichero DAT y el fichero PNG
rm -f $fDAT $fPNG

echo Introduzca el numero de repeticiones:
read Nreps

echo "Ejecutando slow y fast..."

for((Csize=1024 ; Csize <= 8192 ; Csize = Csize*2)); do
	for ((K = 0 ; K < $Nreps ; K += 1)); do
		#Generamos un fichero por repetición
		fAUX=aux_rep_$Csize_$K.dat
		touch $fAUX
		for ((N = Ninicio ; N <= Nfinal ; N += Npaso)); do
			echo "N: $N / $Nfinal..."

			valgrind --tool=cachegrind --I1=$Csize,1,64 --D1=$Csize,1,64 --LL=8000000,1,64 --cachegrind-out-file=slow_out.dat ./slow $N
			cg_annotate slow_out. dat | grep "PROGRAM TOTALS" >
			awk '' >
			valgrind --tool=cachegrind --I1=$Csize,1,64 --D1=$Csize,1,64 --LL=8000000,1,64 --cachegrind-out-file=fast_out.dat ./fast $N
			cg_annotate fast_out. dat | grep "PROGRAM TOTALS" >
			awk '' >
			echo "$Csize	$N	$slowTime	$fastTime" >> $fAUX
		done
	done
done

cat aux_rep_1024_* > all_1024.dat
cat aux_rep_2048_* > all_2048.dat
cat aux_rep_4096_* > all_4096.dat
cat aux_rep_8192_* > all_8192.dat

awk -v Nrep="$Nreps" '{n_slow[$1] = n_slow[$1] + $2; n_fast[$1] = n_fast[$1] + $3;} END{for(valor in n_slow) print valor" "(n_slow[valor]/Nrep)" "(n_fast[valor]/Nrep);}' all.dat | sort -nk1 > $fDAT

echo "Generating plot..."
# llamar a gnuplot para generar el gráfico y pasarle directamente por la entrada
# estándar el script que está entre "<< END_GNUPLOT" y "END_GNUPLOT"
gnuplot << END_GNUPLOT
set title "Slow-Fast Execution Time"
set ylabel "Execution time (s)"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$fPNG"
plot "$fDAT" using 1:2 with lines lw 2 title "slow", \
     "$fDAT" using 1:3 with lines lw 2 title "fast"
replot
quit
END_GNUPLOT

rm -rf slow fast all.dat aux_rep_*
