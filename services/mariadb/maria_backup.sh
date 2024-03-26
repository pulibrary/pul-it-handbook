#!/bin/bash
PATH="/usr/local/bin:$PATH"
source /home/pulsys/.env.restic
mysql --defaults-extra-file=/home/pulsys/.restic/mysql_cnf -N -e 'show databases' | while read dbname; do /usr/bin/mysqldump --defaults-extra-file=/home/pulsys/.restic/mysql_cnf --complete-insert "$dbname" > "/var/local/mariadb/$dbname".sql; done
restic -r gs:pul-mariadb-backup:yourpath -p /home/pulsys/.restic.pwd backup /var/local/mariadb
restic prune
