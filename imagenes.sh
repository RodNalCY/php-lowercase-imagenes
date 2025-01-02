#!/bin/sh

# Content Media 2013-2024

ruta="/home/elsol/wordpress/extranet/wp-content/plugins/extelsol/imagenes"
log_ftp="/home/elsol/logs/extranet_imagenes.log"
log_rename="/home/elsol/logs/extranet_imagenes_rename.log"

ext_host="dmz.elsol.pe" # 170.231.82.36
ext_user="extranet"
ext_pass="ExTS..*..RS"

# Indicar que la tarea está ejecutándose
url="https://cronitor.link/p/0e3acc437cf44ea3bc57f6e8f334a117/3G1Gbv"
curl "$url?state=run"

# Ejecutar las tareas

# Descargar los archivos de fotosllantas vía FTP:
#   --passive-ftp: el cliente se conecta al servidor para establecer la conexión, en vez de lo contrario
#   -r: recursivo, -l 6: máximo 6 subdirectorios
#   -nH: deshabilitar generación de un directorio con el nombre del host
#   -o $log: crear un log en el archivo especificado
#   -nv: imprimir solo información básica y mensajes de error
#   -N: activar timestamping, es decir solo pasan los archivos modificados y los nuevos
#   -P $ruta: guardar todos los archivos en la ruta especificada
# Más info: https://man7.org/linux/man-pages/man1/wget.1.html
wget --passive-ftp -r -l 6 -nH -o $log_ftp -nv -N -P$ruta ftp://$ext_user:$ext_pass@$ext_host/fotosllantas/

# Indicar si la tarea funcionó correctamente
if [ $? -ne 0 ]; then
	curl "$url?state=fail"
	exit 1
fi

# Cambiar todos los nombres de archivo y carpetas a minúsculas.
# Windows no tiene problemas entre mayúsculas y minúsculas, pero Linux sí
#   find -depth: lista el contenido de cada directorio antes del directorio mismo
#   mv -T: tratar ruta de destino como un archivo cualquiera (porque también cambiaremos carpetas)
# Más info: https://stackoverflow.com/a/152741
# for SRC in `find $ruta/fotosllantas -depth`
# do
#     DST=`dirname "${SRC}"`/`basename "${SRC}" | tr '[A-Z]' '[a-z]'`
#     if [ "${SRC}" != "${DST}" ]; then
#         [ ! -e "${DST}" ] && mv -T "${SRC}" "${DST}" || echo "${SRC} no se pudo renombrar" >> $log_rename
#     fi
# done

# Ejecución del archivo PHP
php lowercase.php

# Indicar si la tarea funcionó correctamente
if [ $? -eq 0 ]; then
	curl "$url?state=complete"
else
	curl "$url?state=fail"
	exit 1
fi
