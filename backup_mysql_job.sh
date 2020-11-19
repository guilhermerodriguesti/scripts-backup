#!/bin/bash
#Autor: Guilherme Rodrigues
# Create crontab: */1 * * * *     sh /usr/local/bin/backup_mysql.sh database01 > /tmp/backup_job_database01.log
TODAY=$(date --date "0 day ago" +%Y%m%d)
TSTAMP=$(date +%H%M%S)

DB_NAME="$1"
DB_HOST="database01.us-east-1.rds.amazonaws.com"
DB_USER="usr_backup"
DB_PASS="secret"

BASE_DIR="/tmp/backup/$(date +"%Y")"
BUCKET_NAME="bucket-backup-mysql"

log=/tmp/backup_${DB_NAME}-${TODAY}-${TSTAMP}.log

echo "########################################################################################################" >> $log
echo "########################################################################################################" >> $log
echo "--------------------------------------------------------------------------------------------------------" >> $log
echo " INICIADO - $TODAY as $TSTAMP"                                                                            >> $log
echo "--------------------------------------------------------------------------------------------------------" >> $log
OUTPUT_DIR="$BASE_DIR/$DB_NAME"
echo "\033[91m CRIANDO REPOSITORIOS DO BACKUP... \033[39m"                                                      >> $log
    mkdir -p $OUTPUT_DIR/$TODAY
    aws s3 mb s3://$BUCKET_NAME
echo "\033[91m GERANDO O ARQUIVO DO BACKUP... \033[39m"                                                         >> $log
    mysqldump --host=$DB_HOST --user=$DB_USER --password=$DB_PASS --databases $DB_NAME > $OUTPUT_DIR/$TODAY/$DB_NAME.$TODAY.sql
echo "\033[91m SINCRONIZANDO O ARQUIVO DO BACKUP... \033[39m"                                                   >> $log
    aws s3 sync $BASE_DIR s3://$BUCKET_NAME
echo "\033[91m LIMPANDO O ARQUIVO DIARIO... \033[39m"                                                           >> $log
    rm -rf $OUTPUT_DIR/$TODAY

echo "--------------------------------------------------------------------------------------------------------" >> $log
echo " FINALIZADO - $TODAY - $TSTAMP"                                                                           >> $log
echo "--------------------------------------------------------------------------------------------------------" >> $log
echo "########################################################################################################" >> $log
echo "########################################################################################################" >> $log
