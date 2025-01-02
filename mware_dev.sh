#!/bin/sh

# Indicar que el middleware está ejecutándose
url="https://cronitor.link/p/b52c2550f70847628b02ad6e1fd39ac1/paHIDo"
curl "$url?state=run"

# Ejecutar el middleware
/usr/local/bin/php /home/elsol/public_html/extranet2/middleware/actualiza.php >> /home/elsol/logs/extranet_mware_dev_output.log

# Indicar si el middleware funcionó correctamente
if [ $? -eq 0 ]; then 
	curl "$url?state=complete"
else 
	curl "$url?state=fail"
fi
