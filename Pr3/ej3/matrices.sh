#!/bin/bash

# Compilamos los programas necesarios
gcc -c arqo3.c
gcc -c multiplicar.c
gcc -c multiplicar_t.c
gcc -o multiplicar multiplicar.o arqo3.o
gcc -o multiplicar_t multiplicar_t.o arqo3.o

# Damos permisos de ejecucion
chmod ugo+x multiplicar
chmod ugo+x multiplicar_t

# Inicializamos variables

aux=$(expr 1301 + 9)
P=$(expr $aux % 10)
echo Valor de P: $P
Ninicio=1  #$((256 + 256*$P))
echo Inicio: $Ninicio
Npaso=1
echo Paso: $Npaso
Nfinal=20 #$((256 + 256*($P+1)))
echo Final: $Nfinal

fDAT=mult_time.dat
fFINAL=mult.dat
fFAIL1=fail1.dat
fFAIL2=fail2.dat
fPNG1=mult_time.png
fPNG2=mult_cache_read.png
fPNG3=mult_cache_write.png
fAUX=all.dat # Fichero para tiempos
fAUXF=allF.dat # Fichero para tiempos
fAUX2=auxi.dat
# Borrar el fichero DAT y el fichero PNG
rm -f $fFINAL $fPNG1 $fPNG2 $fPNG3

echo Introduzca el numero de repeticiones:
read Nreps

echo "Ejecutando la multiplicacion de matrices..."


for ((K = 0 ; K < $Nreps ; K += 1)); do
    echo "Comenzando repetición $K"
    fFAILn=cacheN.dat
    fFAILt=cacheT.dat
	touch $fAUX
	for ((N = Ninicio ; N <= Nfinal ; N += Npaso)); do
		echo "N: $N / $Nfinal..."
        > $fFAILn # Dejamos en blanco los archivos
        > $fFAILt # Dejamos en blanco los archivos
		normalTime=$(valgrind --tool=cachegrind --cachegrind-out-file=$fFAILn -q ./multiplicar $N | grep 'time' | awk '{print $3}')
		transTime=$(valgrind --tool=cachegrind --cachegrind-out-file=$fFAILt -q ./multiplicar_t $N | grep 'time' | awk '{print $3}')
        # Guardando fichero temporal con tiempos
		echo "$N	$normalTime	$transTime" >> $fAUX
        # Guardando fichero temporal con fallos de memoria
        FAIL1=$(cg_annotate $fFAILn | grep 'PROGRAM TOTALS' | awk 'BEGIN{FS=" "} {print $5" "$8}') # De la mult normal D1mr y D1mw
        FAIL2=$(cg_annotate $fFAILt | grep 'PROGRAM TOTALS' | awk 'BEGIN{FS=" "} {print $5" "$8}') # De la mult traspuesta D1mr y D1mw$fDAT $fPNG1 $fPNG2
        echo "$N    $FAIL1  $FAIL2" >> $fAUXF
	done
    rm $fFAILn $fFAILt
done

#Calculamos la media para cada tamaño
#Media para tiempos
awk -v Nrep="$Nreps" '{n_normal[$1] = n_normal[$1] + $2; n_trans[$1] = n_trans[$1] + $3;} END{for(valor in n_normal) print valor" "(n_normal[valor]/Nrep)" "(n_trans[valor]/Nrep);}' all.dat | sort -nk1 > $fDAT

#Media para fallos
sed -i 's/,//g' $fAUXF # Eliminamos las comas para poder operar
awk -v Nrep="$Nreps" '{mr[$1] = mr[$1] + $2; mw[$1] = mw[$1] + $3;} END {for(valor in mr) print valor" "(mr[valor]/Nrep)" "(mw[valor]/Nrep)}' allF.dat | sort -nk1 > $fFAIL1
awk -v Nrep="$Nreps" '{mr[$1] = mr[$1] + $4; mw[$1] = mw[$1] + $5;} END {for(valor in mr) print (valor" "mr[valor]/Nrep)" "(mw[valor]/Nrep)}' allF.dat | sort -nk1 > $fFAIL2

# Generamos el fichero pedido en el enunciado con el siguiente formato:
# <N> <tiempo “normal”> N <D1mr “normal”> <D1mw “normal”> <tiempo “trasp”> N < D1mr “trasp”> <D1mw “trasp”>
> $fFINAL
awk '{print $1" "$2}' $fDAT >> aux1.dat
awk '{print $3}' $fDAT >> aux2.dat
paste aux1.dat $fFAIL1 aux2.dat $fFAIL2 >> $fAUX2

awk '{print $1" "$2" "$4" "$5" "$6" "$8" "$9}' $fAUX2 > $fFINAL

# Generamos las gráficas
echo "Generando gráficas de tiempos..."
gnuplot << END_GNUPLOT
set title "Normal/Transposed Matrix Product Execution Time"
set ylabel "Execution time (s)"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$fPNG1"
plot "$fFINAL" using 1:2 with lines lw 2 title "Normal", \
     "$fFINAL" using 1:5 with lines lw 2 title "Transposed"
replot
quit
END_GNUPLOT

echo "Generando gráficas de de fallos de lectura"
gnuplot << END_GNUPLOT
set title "Normal/Transposed Matrix Product Read Failures"
set ylabel "Failures"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$fPNG2"
plot "$fFINAL" using 1:3 with lines lw 2 title "Normal", \
     "$fFINAL" using 1:6 with lines lw 2 title "Transposed"
replot
quit
END_GNUPLOT

# Generamos las gráficas de los tamaños
echo "Generando gráficas de fallos de escritura..."
gnuplot << END_GNUPLOT
set title "Normal/Transposed Matrix Product Write Failures"
set ylabel "Failures"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$fPNG3"
plot "$fFINAL" using 1:4 with lines lw 2 title "Normal", \
     "$fFINAL" using 1:7 with lines lw 2 title "Transposed"
replot
quit
END_GNUPLOT

rm -rf multiplicar multiplicar_t *.o $fAUX aux1.dat aux2.dat $fDAT $fAUXF $fFAIL1 $fFAIL2 $fAUX2
