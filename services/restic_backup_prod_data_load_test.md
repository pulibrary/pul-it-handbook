## Testing production database backups by restoring them to the staging postgres

1. On the staging leader, retrieve the [Restic backup](restic_backup.md#retrieve-a-backup).
2. On the production leader, retrieve the [Restic backup](restic_backup.md#retrieve-a-backup).
3. Use scp to transfer the production backup to your machine.
    ```bash
    scp pulsys@<server_host>.princeton.edu:/tmp/postgresql/<backup_name>.sql.gz ./
    ```
    For Example:
    ```bash
    scp pulsys@lib-postgres-prod1.princeton.edu:/tmp/postgresql/bibdata_alma_production.sql.gz ./
    ```
4. Use scp to transfer the production backup from your machine to the staging postgres server.
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
7. Stop the Nginx service on the the staging servers that use the database you want to restore. This will close the connections and allow the database to be recreated.
8. On the staging leader server, wait for the connections to have closed and [restore the production backup](restic_backup.md#restore-a-postgresql-database).
9. Restart the Nginx service on the staging servers.
10. Verify the data was loaded successfully.
11. Stop the Nginx service on the staging servers.
12. Restore the[ staging backup](restic_backup.md#restore-a-postgresql-database) to return the staging servers to their initial state.
13. Restart the Nginx service to the staging servers.