# scripts-backup

- mysql-client
- awscli
- python3
- CREATE USER 'usr_backup'@'%' IDENTIFIED BY 'secret';
- GRANT SELECT,LOCK TABLES ON *.* TO 'usr_backup'@'%';
- Per http://getasysadmin.com/2011/06/amazon-rds-super-privileges/, you need to set log_bin_trust_function_creators to 1 in AWS console, to load your dump file without errors.

If you want to ignore these errors, and load the rest of the dump file, you can use the -f option:

mysql -f my_database -u my_username -p -h  
my_new_database.xxxxxxxxx.us-east-1.rds.amazonaws.com < my_database.sql
The -f will report errors, but will continue processing the remainder of the dump file.
Ref.: https://stackoverflow.com/questions/11601692/mysql-amazon-rds-error-you-do-not-have-super-privileges


export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
export AWS_DEFAULT_REGION="us-east-1"
