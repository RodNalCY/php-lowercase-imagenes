#!/bin/sh

ruta="/home/elsol/wordpress/extranet/mware2/actualiza.php"
log="/home/elsol/logs/extranet_mware.log"

# Indicar que el middleware está ejecutándose
url="https://cronitor.link/p/0e3acc437cf44ea3bc57f6e8f334a117/DbLIXV"
curl "$url?state=run"

# Ejecutar el middleware
/usr/local/bin/php $ruta >> $log

# Indicar si el middleware funcionó correctamente
if [ $? -eq 0 ]; then 
	curl "$url?state=complete"
else 
	curl "$url?state=fail"
fi
