# Postgresql databases

## Backups and resilience

### Finding a postgres backup file

Our postgresql database backups are stored in a [Google Cloud bucket](https://console.cloud.google.com/storage/browser?project=pul-gcdc&prefix=&forceOnObjectsSortingFiltering=false&pli=1&forceOnBucketsSortingFiltering=true) alongside backups for Solr, MariaDB, and more.

Most of our applications are running postgresql 15 on lib-postgres-prod1. Backups for psql 15 databases go to a folder named `postgres-15-backup/15/daily/`.

Some applications are still running postgresql 13 on lib-postgres-prod3. Backups for psql 13 databases go to a folder named `pul-postgres-backup/13/daily/`. Within this folder, each application has a directory full of backup files.

Figgy now runs on postgresql 15 on its own database servers. Backups for figgy go to a folder named `figgy-db-backup/daily/`.

Navigate to the correct folder for the application you are seeking. By default, Google Cloud storage sorts files with oldest on top. To find the most recent backups within a folder, in the row above the column names (scroll up if necessary), change `Filter by name prefix only` to `Sort and filter`, then click twice on the `Created` column header. When the arrow in the `Created` column header points down, the most recent backup appears at the top of the list.

### How our backups work

The postgres 15 backups (including Figgy and Geoserver) are run using [restic](https://restic.readthedocs.io/en/latest/010_introduction.html), see their docs for more information.

The postgres 13 backups are run using postgres tools. These backups run in two stages:
1. We run the postgresql script (`/var/lib/postgresql/backup/autopgsqlbackup.sh`) first. The script creates backup files in the `/var/lib/postgresql/postgres_backup/13/daily/` directory.
2. We run an rsync process to move the backup files to the cloud an hour or two later.
Both steps are set in the `postgres` user's crontab. To view them:
- SSH into the database server (lib-postgres3 for figgy; lib-postgres-prod2 for psql 13 applications)
- become the postgres user with `sudo su postgres`
- view the postgres user's crontab with `crontab -l`

### Standbys and resilience

Our postgres 15 servers (including Figgy and Geoserver) have warm standby capability configured. We maintain two servers for each cluster - a leader and a follower. Add more details on the postgresql cluster and replication here.

## Allowing database access from a new VM

When you create a new application or add a new machine for an existing application, you must configure the postgresql cluster to allow database access from the new VM(s). This task is now automated! If you see the error below you need to update your group vars. The example below assumes postgres version 13 and staging machine. After updating your group vars, rerun your playbook.
```
postgres_host: '{{ vault_postgres_staging_host }}'
postgres_version: 13
postgres_is_local: false
```

When provisioning with ansible, if you haven't configured the postgresql cluster for your new VM, you'll get an error message like this:
```
TASK [pulibrary.postgresql : create postgresql db users] ***************************************************************************************************************************
An exception occurred during task execution. To see the full traceback, use -vvv. The error was: FATAL:  no pg_hba.conf entry for host "XXX.XXX.XXX.XXX", user "[redacted]", database "[redacted]", SSL off
fatal: [my-server.princeton.edu]: FAILED! => {"changed": false, "msg": "unable to connect to database: FATAL: no pg_hba.conf entry for host \"XXX.XXX.XXX.XXX\", user \"[redacted]\", database \"[redacted]\"...}
```
