#!/bin/bash

make clean
make
chmod ugo+x slow
chmod ugo+x fast
# inicializar variables
aux=$(expr 1301 + 9)
P=$(expr $aux % 10)
echo Valor de P: $P
Ninicio=$((10000 + 1024*$P))
echo Inicio: $Ninicio
Npaso=64
echo Paso: $Npaso
Nfinal=$((10000 + 1024*($P+1)))
echo Final: $Nfinal

fDAT=slow_fast_time.dat
fPNG=slow_fast_time.png

# borrar el fichero DAT y el fichero PNG
rm -f $fDAT $fPNG

echo Introduzca el numero de repeticiones:
read Nreps

echo "Ejecutando slow y fast..."
# bucle para N desde inicio a fin
#for N in $(seq $Ninicio $Npaso $Nfinal);
for ((K = 0 ; K < $Nreps ; K += 1)); do
	#Generamos un fichero por repetición
	fAUX=aux_rep_$K.dat
	touch $fAUX
	for ((N = Ninicio ; N <= Nfinal ; N += Npaso)); do
		echo "N: $N / $Nfinal..."
	
		# ejecutar los programas slow y fast consecutivamente con tamaño de matriz N
		# para cada uno, filtrar la línea que contiene el tiempo y seleccionar la
		# tercera columna (el valor del tiempo). Dejar los valores en variables
		# para poder imprimirlos en la misma línea del fichero de datos
		slowTime=$(./slow $N | grep 'time' | awk '{print $3}')
		fastTime=$(./fast $N | grep 'time' | awk '{print $3}')

		echo "$N	$slowTime	$fastTime" >> $fAUX
	done
done

#Calculamos la media para cada tamaño
#Fichero con todos los tiempos de las múltiples repeticiones
cat aux_rep_* > all.dat 
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
