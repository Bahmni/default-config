#!/bin/bash

# $1 = $DUMP_NAME 
# $2 = $MYSQL_USER_DEV 
# $3 = $MYSQL_PWD_DEV

sudo service openmrs stop
mysql -u$2 -p$3 openmrs < /var/www/bahmni_config/backup/$1
sudo service openmrs start