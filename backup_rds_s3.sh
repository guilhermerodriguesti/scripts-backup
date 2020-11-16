#!/bin/bash
#Autor: Guilherme Rodrigues

ACTION="backup"
DB_NAME="db01"
DB_HOST="database.rds.amazonaws.com"

DB_USER="usr_backup"
DB_PASS="secret"

BASE_DIR="/backup/$(date +"%Y")"
BUCKET_NAME="s3-bucket-backup-mysql"

DATA=$(date --date "0 day ago" +%Y%m%d)
OUTPUT_DIR="$BASE_DIR/$DB_NAME"

if [[ "$ACTION" == backup ]] ;then
    echo "backup"
    mkdir -p $OUTPUT_DIR/$DATA
    aws s3 mb s3://$BUCKET_NAME
    mysqldump --host=$DB_HOST --user=$DB_USER --password=$DB_PASS --databases $DB_NAME > $OUTPUT_DIR/$DATA/$DB_NAME.$DATA.sql
    aws s3 sync $BASE_DIR s3://$BUCKET_NAME
elif [[ "$ACTION" == restore ]] ;then
    echo "restore"
    mkdir -p $OUTPUT_DIR/$DATA
    aws s3 sync s3://$BUCKET_NAME/$DB_NAME/$DATA $OUTPUT_DIR/$DATA
    mysql --host=$DB_HOST --user=$DB_USER --password=$DB_PASS --databases $DB_NAME < $OUTPUT_DIR/$DATA/$DB_NAME.$DATA.sql
fi
