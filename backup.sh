#!/bin/sh

backup="/home/elsol/backup"
dbname="elsol_extranet"
dbuser="$dbname"
dbpass="N2)22ZE.@Bh-@p2S"

# Realizar una copia de la base de datos de la Extranet
# Nota: la contraseña *debe* estar pegada al comando: -p[contraseña]
mysqldump -u $dbuser -p$dbpass $dbname > "$backup/$dbname.sql"

# Comprimir el backup para ahorrar espacio
cd $backup && tar -zcf "${dbname}_$(date +%Y%m%d).tgz" *.sql

# Para evitar llenar el servidor, borrar los backups de más de 1 año
find $backup/*.tgz -mtime +13 -exec rm {} \;
