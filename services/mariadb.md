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
