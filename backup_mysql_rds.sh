#!/bin/bash
#Autor: Guilherme Rodrigues

DB_NAME="db01"
DB_HOST="db01.sa-east-1.rds.amazonaws.com"

DB_USER="usr_backup"
DB_PASS="secret"

BASE_DIR="/backup/$(date +"%Y")"
BUCKET_NAME="bucket-backup-mysql"

DATA=$(date --date "0 day ago" +%Y%m%d)
OUTPUT_DIR="$BASE_DIR/$DB_NAME"
    echo "Backup..."
    mkdir -p $OUTPUT_DIR/$DATA
    aws s3 mb s3://$BUCKET_NAME
    mysqldump --set-gtid-purged=OFF --host=$DB_HOST --user=$DB_USER --password=$DB_PASS --databases $DB_NAME > $OUTPUT_DIR/$DATA/$DB_NAME.$DATA.sql
    aws s3 sync $BASE_DIR s3://$BUCKET_NAME
