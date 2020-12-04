## Restarting the MariaDB cluster

The mariadb cluster will always need a manual restart after a software update
and/or a reboot. There is no way for any of the nodes to know the state of other
members so if there is a mariadb update that isn't well coordinated they will
fall out of sync. In our case all the applications expect to find mariadb1 first
so it will always be the primary node.

## Start mariadb1 first (Make sure other servers have their services stopped)

You will need to edit the garstate.dat file from 

```
[root@mariadb1 ~]# vi /var/lib/mysql/grastate.dat
# GALERA saved state
version: 2.1
uuid: e49a3e4d-e3ae-11e6-8d23-32480d0156a6
seqno: -1
safe_to_bootstrap: 0
```
to

```
[root@mariadb1 ~]# vi /var/lib/mysql/grastate.dat
# GALERA saved state
version: 2.1
uuid: e49a3e4d-e3ae-11e6-8d23-32480d0156a6
seqno: -1
safe_to_bootstrap: 1
```
You are changing the 0 to a 1 in the last line.

Then as superuser run

```
[root@mariadb1 ~]# galera_new_cluster
```

On the other nodes start the mariadb service

```
[root@mariadb2 ~]# systemctl start mariadb.service
[root@mariadb3 ~]# systemctl start mariadb.service
```

## MariaDB Backups

### Location
Backups are most easily located by sshing onto the mariabdb server and looking in `/mnt/diglibdata/mariadb/`

There are backups run daily at 6:45am for each database on the server. For example the database backup files for the library site live on the server in `/mnt/diglibdata/mariadb/prod/automysqlbackup/daily/libwww-prod/`

### Restoring from backup
1. SSH onto the appropriate mariadb server.  If you are unsure of the server look at princeton-ansible to determine which mariadb you service accesses.
1. Locate you backup (see section above)
   We will refer to the backup file as <backup-file> in the instructions below
   We will refer to the name of the database as <database-name> in the instructions below
1. Switch to root.  Then you will not need a user/password for mariadb
   ```
   sudo su 
   ```
1. unzip your backup
   ```
   gunzip <backup-file>
   ```
1. backup your database priori to restoring
   ```
   mysqldump <database name> > before-restore-<database-name>.sql
   ```
1. restore the dump
   ```
   mysql <database-name> < <backup-file>
   ```
 1. rezip the backup
    ```
    gzip <backup-file>
    ```
    
