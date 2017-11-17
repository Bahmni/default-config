#!/bin/bash

# $1 = DUMP_NAME
# $2 = AWS_PEM_KEY_DEV
# $3 = AWS_USER_STAGING
# $4 = AWS_IP_STAGING
# $5 = MYSQL_USER_DEV
# $6 = MYSQL_PWD_DEV

mysqldump -u$5 -p$6 openmrs > /var/www/bahmni_config/backup/$1
sudo scp -i $2 /var/www/bahmni_config/backup/$1 $3@$4:/var/www/bahmni_config/backup