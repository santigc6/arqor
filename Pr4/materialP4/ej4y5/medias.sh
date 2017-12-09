#!/bin/bash

# Este script realiza 100 ejecuciones de la integración numérica (versiones de
# la 1 a la 7) para comparar rendimientos.

> m.txt
# Realizando la media de tiempo de ejecución de la version 1
echo "Testeando la versión 1"
for((i=1 ; i <= 100 ; i = i+1)); do
    ./pi_par1 | grep Tiempo | awk '{print $2}' >> m.txt
    echo "Realizada la ejecución número "$i
done

v1=$(awk '{total += $1} END {print total/100}' m.txt)

> m.txt
# Realizando la media de tiempo de ejecución de la version 1
echo "Testeando la versión 2"
for((i=1 ; i <= 100 ; i = i+1)); do
    ./pi_par2 | grep Tiempo | awk '{print $2}' >> m.txt
    echo "Realizada la ejecución número "$i
done

v2=$(awk '{total += $1} END {print total/100}' m.txt)

echo "Testeando la versión 3"
> m.txt
for((i=1 ; i <= 100 ; i = i+1)); do
    ./pi_par3 | grep Tiempo | awk '{print $2}' >> m.txt
    echo "Realizada la ejecución número "$i
done

v3=$(awk '{total += $1} END {print total/100}' m.txt)

> m.txt
# Realizando la media de tiempo de ejecución de la version 1
echo "Testeando la versión 4"
for((i=1 ; i <= 100 ; i = i+1)); do
    ./pi_par4 | grep Tiempo | awk '{print $2}' >> m.txt
    echo "Realizada la ejecución número "$i
done

v4=$(awk '{total += $1} END {print total/100}' m.txt)

> m.txt
# Realizando la media de tiempo de ejecución de la version 1
echo "Testeando la versión 5"
for((i=1 ; i <= 100 ; i = i+1)); do
    ./pi_par5 | grep Tiempo | awk '{print $2}' >> m.txt
    echo "Realizada la ejecución número "$i
done

v5=$(awk '{total += $1} END {print total/100}' m.txt)

> m.txt
# Realizando la media de tiempo de ejecución de la version 1
echo "Testeando la versión 6"
for((i=1 ; i <= 100 ; i = i+1)); do
    ./pi_par6 | grep Tiempo | awk '{print $2}' >> m.txt
    echo "Realizada la ejecución número "$i
done

v6=$(awk '{total += $1} END {print total/100}' m.txt)

> m.txt
# Realizando la media de tiempo de ejecución de la version 1
echo "Testeando la versión 7"
for((i=1 ; i <= 100 ; i = i+1)); do
    ./pi_par7 | grep Tiempo | awk '{print $2}' >> m.txt
    echo "Realizada la ejecución número "$i
done

v7=$(awk '{total += $1} END {print total/100}' m.txt)

echo "Tiempo medio version 1: "$v1
echo "Tiempo medio version 2: "$v2
echo "Tiempo medio version 3: "$v3
echo "Tiempo medio version 4: "$v4
echo "Tiempo medio version 5: "$v5
echo "Tiempo medio version 6: "$v6
echo "Tiempo medio version 7: "$v7

rm -f m.txt
