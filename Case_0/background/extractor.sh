#!/bin/bash

# Archivo de log de OpenFOAM
logfile="log"

# Archivo CSV de salida
output_csv="6dof_positions.csv"

# Imprimir encabezado en el archivo CSV
echo "Time,Centre_of_rotation_x,Centre_of_rotation_y,Centre_of_rotation_z,Centre_of_mass_x,Centre_of_mass_y,Centre_of_mass_z,Orientation_11,Orientation_12,Orientation_13,Orientation_21,Orientation_22,Orientation_23,Orientation_31,Orientation_32,Orientation_33" >$output_csv

# Extraer datos del log y escribir en el CSV
awk '
/^Time =/ { time = $3 }
/^    Centre of rotation:/ { cor = $4 " " $5 " " $6 }
/^    Centre of mass:/ { com = $4 " " $5 " " $6 }
/^    Orientation:/ { orientation = $4 " " $5 " " $6 " " $7 " " $8 " " $9 " " $10 " " $11 " " $12 }
cor && com && orientation {
    gsub(/[()]/, "", cor)  # Eliminar paréntesis
    gsub(/[()]/, "", com)
    gsub(/[()]/, "", orientation)
    
    # Asegurarse de que los datos estén separados por comas
    cor = gensub(/ /, ",", "g", cor)
    com = gensub(/ /, ",", "g", com)
    orientation = gensub(/ /, ",", "g", orientation)

    print time "," cor "," com "," orientation >> "'$output_csv'"
    
    # Limpiar las variables
    cor = com = orientation = ""
}' $logfile

echo "Datos extraídos y guardados en $output_csv"
