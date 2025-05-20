# Database backup documentation

## Emergency restore instructions

Note: these instructions were tested on a staging system in May, 2025. We hope to refine the process soon.

If you are dealing with a database failure of some kind and need to restore a database from a backup, take a deep breath and follow these instructions:

1. On the leader of the database cluster, retrieve the [Restic backup](#Retrieve-from-the-CLI).
1. Use scp to transfer the backup to your local machine.
    ```bash
    scp pulsys@<server_host>.princeton.edu:/tmp/postgresql/<backup_name>.sql.gz ./
    ```
    For Example:
    ```bash
    scp pulsys@lib-postgres-prod1.princeton.edu:/tmp/postgresql/bibdata_alma_production.sql.gz ./
    ```
1. Use scp to transfer the backup from your local machine to the web server.
    ```bash
    scp <backup_name.sql.gz pulsys@<web_server_host>:/tmp
    ```
    For Example:
    ```bash
    scp bibdata_alma_production.sql.gz pulsys@bibdata-prod1:/tmp
    ```
1. On the web server, as the pulsys user, unzip the backup files.
    ```bash
    gzip -d <backup_name>.sql.gz
    ```
1. View the backup `.sql` file to confirm that it references the correct database name.
1. Stop the Nginx service on all web servers that use the database you want to restore. This will close the connections and allow the database to be recreated.
1. On the database server, wait until the connections have closed. You can check for active connections with `ps aux | grep postgres | grep <database-name>`
1. The restore process is designed to drop the original database and recreate it before restoring the tables from the backup, but right now those tasks fail, so we need to do them manually.
    1. On the database server, as the postgres user, manually drop the existing/old/corrupted database:
         ```bash
         dropdb <database-name>
         ```
    1. On the database server, as the postgres user, manually recreate an empty database to restore to:
         ```bash
         createdb -0 <database-name> <database-owner>
         ```
1. On the web server, run the command to restore the tables from the backup file - the command passes the correct database owner:
     ```bash
     psql -h <FQDN-of-database-server> -U <database-owner> -d <database-name> -f </path/to/backup-file.sql>
     ```
     For example:
     ```bash
    psql -h lib-postgres-prod1.princeton.edu -U approvals_prod -d approvals_prod -f /tmp/approvals_prod.sql
     ```
1. On the database server, log into postgres (as the postgres user, do `psql`). Confirm that the database exists and has tables that are owned by the correct user.
     ```bash
    postgres=# \c <database-name>
    You are now connected to database "<database-name>" as user "postgres".
    <database-name> =# \dt
    (output omitted)
    <database-name> =# \q
     ```
    If the tables are owned by the `postgres` user, you did the restore from the database server. To fix table ownership, run this as the postgres user:
     ```bash
     for tbl in `psql -qAt -c "select tablename from pg_tables where schemaname = 'public';" <database_name>`; do psql -c "alter table public.\"$tbl\" owner to <database_owner>" -d <database_name> -U postgres
     done
     ```
     For example:
     ```bash
     for tbl in `psql -qAt -c "select tablename from pg_tables where schemaname = 'public';" approvals_staging`; do psql -c "alter table public.\"$tbl\" owner to approvals_staging" -d approvals_staging -U postgres
     done
     ```
1. Restart the Nginx service on the web servers.
1. Log into the service and verify the data was loaded successfully.
1. Do whatever else is appropriate to end the incident, then take another deep breath.

## Setting up automated database backups with restic

### Before you begin

Double-check that you are logged into the correct database server. If the database server is part of a cluster, only one server in the cluster will create backups. Generally that is the machine with `1` in the name.

If you are creating a new backup setup, you will need a [Google Service Account](gce_service_account.md) and a Google Bucket. If they do not exist yet, create them.

The Object Storage bucket will hold your backup repository. Follow the [Create a Bucket guide](gce_bucket.md) if you do not already have one.


### Install Restic

As the `pulsys` user install restic with the following command:

```bash
sudo apt -y install restic
```

Run the following command to confirm it is installed correctly:

```bash
restic version
```

### Create the Restic Repository

1. Configure Restic to use Google Cloud Bucket access file (Step 6 in [Service Account Keys Creation](gce_service_account.md) and to use the bucket you created in the Before You Begin section of this guide. and substitute `gs:postgres-version-backup:yourpath` below with your own values.

    ```bash
    export GOOGLE_PROJECT_ID=pul-gcdc
    export GOOGLE_APPLICATION_CREDENTIALS=~/.restic/pul-gcdc-filename.json
    restic -r gs:postgres-version-backup:yourpath init
    ```
2. Following the prompt, set a password to encrypt your repository’s data. Enter your desired password twice, and be sure to save it!
3. Add the encryption password to Lastpass and add it as a vaulted variable in princeton_ansible. **Losing this password will make our backups inaccessible!**

### Store the file and password

The access keyfile, and password are required every time Restic communicates with your repository. To make it easier to work with your repository, create a shell script containing your credentials.

  1. To keep your credentials secure, using a text editor, copy and adapt the example script in the home directory of the user who will run the backup's home directory. Run all your Restic scripts as this user. The example uses the `postgres` user and the vim text editor.
       ```bash
       sudo su - postgres
       mkdir -p .restic
       vim .env.restic
       ```

     Copy and paste the json keyfile’s content and replace and with your own Object Storage account’s keyfile.

     ```file
     ### repository on google cloud
     export GOOGLE_APPLICATION_CREDENTIALS='/var/lib/postgresql/.restic/pul-gcdc-filename.json'

     export RESTIC_ARCHIVE_REPOSITORY='gs:postgres-version-backup:yourpath'

     export RESTIC_REPOSITORY=$RESTIC_ARCHIVE_REPOSITORY
     export RESTIC_PASSWORD_FILE='/var/lib/postgresql/.restic.pwd'
     ```

     If you are backing up postgreSQL, use the path `/var/lib/postgresql`.
     If you are backing up mariadb, use the path `/home/pulsys`.

  2. Create a password file to hold your Restic password:
     ```bash
     sudo su - postgres
     vim ~/.restic.pwd
     ```
     Enter your Rustic password and save the file/
     ```file
     ~/.restic.pwd
     secretpassword # goes into lastpass and ansible vault
     ```

### Backup All Databases

For postgresql use the [postgresql](postgresql) scripts as a cronjob.

  1. Copy all files above in your ~/.restic directory:
     ```bash
     sudo su - postgres
     mkdir -p ~/.restic/log
     ```
  2. Make all the scripts executable by the `postgres` user:
     ```bash
     chmod u+x ~/.restic/{common.sh,full_pg_backup.sh,pg_backup.sh,prune.sh}
     ```

  3. Set Up automated backups by creating a cron job for the `postgres` user with the following:
     ```bash
      sudo su - postgres
      crontab -e
      ```
     Add a line that points to the `full_pg_backup.sh` script

    ```file
    0 5 * * * /var/lib/postgresql/.restic/full_pg_backup.sh
    ```

For mariadb do the following:

  1. Copy all the files under the [mariadb](mariadb) to the `pulsys` user:
     ```bash
     mkdir -p ~/.restic/log
     ```
  2. Make all the scripts executable by the `pulsys` user:
     ```bash
     chmod u+x ~/.restic/maria_backup.sh
     ```
  3. Set Up automated backups by creating a cron job for the `pulsys` user with the following:
     ```bash
      crontab -e
      ```
     Add a line that points to the `full_pg_backup.sh` script:

    ```file
    0 5 * * * /home/pulsys/.restic/maria_backup.sh
    ```

# Retrieving a database backup

## Retrieve from the GUI

  1. Install the restic-browser app with

    ```bash
    brew install restic-browser
    ```

  2. In the 'Applications' directory find and launch 'Restic-Browser'.

     Create a new Location (this may take some time):

       * In the **Type**: Select Google Cloud Storage
       * In the **Bucket**: Enter the name and path of your bucket in all lower case. (e.g., gs:postgres-15-backup:daily) - you can see a list of all [our PUL buckets](https://console.cloud.google.com/storage/browser)
       * In the **GOOGLE_PROJECT_ID**: Enter pul-gcdc
       * In the **GOOGLE_APPLICATION_CREDENTIALS**: Get a copy of the credentials and place them at a known location
         * Log into `lib-postgres-prod1` (`ssh pulsys@lib-postgres-prod1`) and download or copy the credentials with the following
           ```bash
           sudo su - postgres
           cat ~/.restic/pul-gcdc-UUIDnumber.json
           ```
       * In the **Repository Password**: Get the contents from the server
         * Log into `lib-postgres-prod1` (`ssh pulsys@lib-postgres-prod1`) and get the password with the following
           ```bash
           sudo su - postgres
           cat ~/.restic.pwd
           ```

## Retrieve from the CLI

To retrieve the latest usable postgresql backup from restic, run the following commands:

  1. As the postgresql user run the following steps:
     ```bash
      sudo su - postgres
      source .env.restic
     ```
      To find the value of `postgres-version-backup:yourpath` below, run `env` as a postgres user and look at the `RESTIC_REPOSITORY` variable.

      `restic -r gs:postgres-version-backup:yourpath -p /var/lib/postgresql/.restic.pwd snapshots`


  2. Find the hash key of the database you want to restore from and dump it with the following commands. In our example the hash will be `4f155a5e`

     Results of postgres-version-backup:yourpath below can be seen if you run `env` as a postgres user in the `RESTIC_REPOSITORY` variable
     ```bash
     restic -r gs:postgres-version-backup:yourpath -p /var/lib/postgresql/.restic.pwd restore 4f155a5e -t /tmp
     ```
     This will retrieve the database backup and place it into `/tmp/postgresql`

To retrieve the latest usable mariadb backup from restic, run the following commands:

  1. As the `pulsys` user run the following steps:
     ```bash
      source .env.restic
      restic -r gs:mariadb-version-backup:yourpath -p /home/pulsys/.restic.pwd snapshots
      ```
  2. Find the hash key of the database you want to retrieve a backup from and dump it with the following commands. In our example the hash will be `4f155a5e`
     ```bash
     restic -r gs:mariadb-version-backup:yourpath -p /home/pulsys/.restic.pwd restore 4f155a5e -t /tmp
     ```
     This will retrieve your database backup and place it into `/tmp/mariadb`

## Restore a postgreSQL database
To restore a postgreSQL database from the backup you just retrieved, unzip the database backup file and use the database utility to restore:

  1. Unzip the database backup files:
     ```bash
     gzip -d /tmp/postgresql/<your_backup_file>.sql.gz
     ```
  1. The restore will not work if there are open connections to the database. Stop the Nginx service on VMs that connect to the target database and wait for the connections to close.
  1. The restore process is designed to drop the original database and recreate it before restoring the tables from the backup, but right now those tasks fail, so we need to do them manually.
      1. On the database server, as the postgres user, manually drop the existing/old/corrupted database:
         ```bash
         dropdb <database-name>
         ```
      1. On the database server, as the postgres user, manually recreate an empty database to restore to:
         ```bash
         createdb -0 <database-name> <database-owner>
         ```
1. On the WEB SERVER, restore the tables from the backup file - this allows you to pass the correct database owner:
     ```bash
     psql -h <FQDN-of-database-server> -U <database-owner> -d <database-name> -f </path/to/backup-file.sql>
     ```
     For example:
     ```bash
    psql -h lib-postgres-prod1.princeton.edu -U approvals_prod -d approvals_prod -f /tmp/approvals_prod.sql
     ```
  1. Alternatively, you can start the restore process as the `postgres` user on the database server:
     ```bash
     psql -d <database_name> -f /tmp/postgresql/<your_backup_file>.sql
     ```
     For example:
     ```bash
     psql -d bibdata_alma_staging -f /tmp/postgresql/bibdata_alma_staging.sql
     ```
     Add `-a` if you want to print the results to STDOUT.
  1. On the database server, log into postgres (as the postgres user, do `psql`). Confirm that the database exists and has tables that are owned by the correct user.
     ```bash
     postgres=# \c <database-name>
     You are now connected to database "<database-name>" as user "postgres".
     <database-name> =# \dt
     (output omitted)
     <database-name> =# \q
     ```
     If the tables are owned by the `postgres` user, you did the restore from the database server. To fix table ownership, run this as the postgres user:
     ```bash
     for tbl in `psql -qAt -c "select tablename from pg_tables where schemaname = 'public';" <database-name>` ; do  psql -c "alter table \"$tbl\" owner to <database-owner>" app ; done
     ```
     For example:
     ```bash
     for tbl in `psql -qAt -c "select tablename from pg_tables where schemaname = 'public';" approvals_staging` ; do  psql -c "alter table \"$tbl\" owner to approvals_staging" app ; done
     ```
  1. Restart the Nginx service on the web servers.
  1. Log into the service and verify the data was loaded successfully.
Note: The `.sql` file includes the name of the database that was backed up - so it is different for production and staging. If you are restoring a production database backup into the staging database cluster, you must edit the `.sql` file and change the database name everywhere it appears.

## Testing production database backups by restoring them to the staging postgres

1. On the staging leader, retrieve the [Restic backup](#retrieve-a-backup).
2. On the production leader, retrieve the [Restic backup](#retrieve-a-backup).
3. Use scp to transfer the production backup to your local machine.
    ```bash
    scp pulsys@<server_host>.princeton.edu:/tmp/postgresql/<backup_name>.sql.gz ./
    ```
    For Example:
    ```bash
    scp pulsys@lib-postgres-prod1.princeton.edu:/tmp/postgresql/bibdata_alma_production.sql.gz ./
    ```
4. Use scp to transfer the production backup from your local machine to the staging postgres server. Be sure the name includes `production` so you can tell it apart from the staging backup.
    ```bash
    scp <backup_name.sql.gz pulsys@<staging_server_host>:/tmp
    ```
    For Example:
    ```bash
    scp bibdata_alma_production.sql.gz pulsys@lib-postgres-staging1:/tmp
    ```
5. On the staging server, use chown to change the production backup owner to `postgres`.
    ```bash
    chown postgres:postgres <production_backup>.sql.gz
    ```
6. As the `postgres` user, move the file from `/tmp` to `/tmp/posgressql`
7. Unzip the backup files.
    ```bash
    gzip -d <backup_name>.sql.gz
    ```
8. Edit the production backup .sql file to change the database name to match the staging database.
For Example:
    Replace `bibdata_alma_production` with `bibdata_alma_staging`.
There should be three instances of the database name in the file.
9. Stop the Nginx service on the the staging servers that use the database you want to restore. This will close the connections and allow the database to be recreated.
10. On the staging leader server, wait until the connections have closed, then [restore the production backup](#restore-a-postgresql-database).
11. Restart the Nginx service on the staging servers.
12. Verify the data was loaded successfully.
13. Stop the Nginx service on the staging servers.
14. Restore the[ staging backup](#restore-a-postgresql-database) to return the staging servers to their initial state.
15. Restart the Nginx service to the staging servers.
