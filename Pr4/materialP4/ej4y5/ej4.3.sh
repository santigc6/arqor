#!/bin/bash

# Este script genera una gráfica para distintos valores de padding en el
# ejercicio 4 apartado 3. Hacemos 50 repeticiones para estabilizar el resultado.

> m.txt
> res.txt

for((i=1 ; i <= 50 ; i = i+1)); do
    ./pi_par3_pad 1 | grep Tiempo | awk '{print $2}' >> m.txt
    echo "Realizada la ejecución número "$i
done

v1=$(awk '{total += $1} END {print total/50}' m.txt)
echo "1 "$v1 >> res.txt

> m.txt
for((i=1 ; i <= 50 ; i = i+1)); do
    ./pi_par3_pad 2 | grep Tiempo | awk '{print $2}' >> m.txt
    echo "Realizada la ejecución número "$i
done

v2=$(awk '{total += $1} END {print total/50}' m.txt)
echo "2 "$v2 >> res.txt

> m.txt
for((i=1 ; i <= 50 ; i = i+1)); do
    ./pi_par3_pad 4 | grep Tiempo | awk '{print $2}' >> m.txt
    echo "Realizada la ejecución número "$i
done

v4=$(awk '{total += $1} END {print total/50}' m.txt)
echo "4 "$v4 >> res.txt

> m.txt
for((i=1 ; i <= 50 ; i = i+1)); do
    ./pi_par3_pad 6 | grep Tiempo | awk '{print $2}' >> m.txt
    echo "Realizada la ejecución número "$i
done

v6=$(awk '{total += $1} END {print total/50}' m.txt)
echo "6 "$v6 >> res.txt

> m.txt
for((i=1 ; i <= 50 ; i = i+1)); do
    ./pi_par3_pad 7 | grep Tiempo | awk '{print $2}' >> m.txt
    echo "Realizada la ejecución número "$i
done

v7=$(awk '{total += $1} END {print total/50}' m.txt)
echo "7 "$v7 >> res.txt

> m.txt
for((i=1 ; i <= 50 ; i = i+1)); do
    ./pi_par3_pad 8 | grep Tiempo | awk '{print $2}' >> m.txt
    echo "Realizada la ejecución número "$i
done

v8=$(awk '{total += $1} END {print total/50}' m.txt)
echo "8 "$v8 >> res.txt

> m.txt
for((i=1 ; i <= 50 ; i = i+1)); do
    ./pi_par3_pad 9 | grep Tiempo | awk '{print $2}' >> m.txt
    echo "Realizada la ejecución número "$i
done

v9=$(awk '{total += $1} END {print total/50}' m.txt)
echo "9 "$v9 >> res.txt

> m.txt
for((i=1 ; i <= 50 ; i = i+1)); do
    ./pi_par3_pad 10 | grep Tiempo | awk '{print $2}' >> m.txt
    echo "Realizada la ejecución número "$i
done

v10=$(awk '{total += $1} END {print total/50}' m.txt)
echo "10 "$v10 >> res.txt

> m.txt
for((i=1 ; i <= 50 ; i = i+1)); do
    ./pi_par3_pad 12 | grep Tiempo | awk '{print $2}' >> m.txt
    echo "Realizada la ejecución número "$i
done

v12=$(awk '{total += $1} END {print total/50}' m.txt)
echo "12 "$v12 >> res.txt

COMMAND="gnuplot"

$COMMAND << EOF
set title "Tiempo de ejecución"
set xlabel "Pad size"
set ylabel "Tiempo (segundos)"
set term jpeg
set output "padsize.jpeg"
plot "res.txt" using 1:2 with boxes title "Tiempo medio"
exit
EOF

rm -f res.txt m.txt
