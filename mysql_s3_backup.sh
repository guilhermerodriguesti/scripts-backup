#!/bin/bash
DB_NAME="$1"
echo "Backup..." $DB_NAME
DB_USER="user_backup"
DB_PASS="secret"
DB_HOST="localhost"
BASE_DIR="/backup/$(date +"%Y")"

BUCKET_NAME="bucket-backup-mysql"
#default file postfixes
TSTAMP=$(date +%H%M%S)
#current date/time YYY-MM-DD-hhmm
TODAY=$(date +"%Y-%m-%d")

log=/tmp/${BUCKET_NAME}-${TODAY}-${TSTAMP}.log
echo "########################################################################################################" >> $log
echo "########################################################################################################" >> $log
echo "--------------------------------------------------------------------------------------------------------" >> $log
echo " INICIADO - $data - $hora"                                                                                >> $log
echo "--------------------------------------------------------------------------------------------------------" >> $log
echo -e "\033[91m CRIANDO BUCKET BACKUP... \033[39m"                                                            >> $log
aws s3 mb s3://$BUCKET_NAME
    #output directory
    OUTPUT_DIR="$BASE_DIR/$DB_NAME"

    #create the DB directory if it doesn't exist
    if [ ! -d $OUTPUT_DIR ]; then
    echo -e "\033[91m CRIANDO DIRETORIO BACKUP... \033[39m"                                                     >> $log
        mkdir -p $OUTPUT_DIR
    fi
    echo -e "\033[91m GERANDO BACKUP... \033[39m"                                                               >> $log
    cd $OUTPUT_DIR
    #mysqldump sql script
    mysqldump --host=$DB_HOST --user=$DB_USER --password=$DB_PASS --databases $DB_NAME > $DB_NAME.$TODAY-$TSTAMP.sql

    if [ -f $DB_NAME.$TODAY-$TSTAMP.sql ]; then
        #zip to TODAY zip
        #zip -q $OUTPUT_DIR/$DB_NAME.sql.$TODAY-$TSTAMP.zip $DB_NAME.$TODAY-$TSTAMP.sql
        echo -e "\033[91m SINCRONIZANDO ARQUIVO... \033[39m"                                                    >> $log
        aws s3 sync $BASE_DIR s3://$BUCKET_NAME

    fi
echo "--------------------------------------------------------------------------------------------------------" >> $log
echo " FINALIZADO - $data - $hora" >> $log
echo "--------------------------------------------------------------------------------------------------------" >> $log
echo "########################################################################################################" >> $log
echo "########################################################################################################" >> $log
