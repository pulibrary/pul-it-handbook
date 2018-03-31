## How to restart the Cluster

On `mariadb1` run the following command

```
galera_new_cluster
```

The command is a wrapper and it starts the MariaDB on that node with the
`gcomm://` as the `wsrep_cluster_address` variable. This command should never be
run on more than one node so be sure you are on `mariadb1`

On `mariadb2` run the following command

```
systemctl start mysql
```
