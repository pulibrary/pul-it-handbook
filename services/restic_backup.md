## Before you begin

If one doesn’t exist yet create a [Google Service Account](gce_service_account.md) and Google Bucket. 

Create an Object Storage bucket to hold your backup repository. Follow the [Create a Bucket guide](gce_bucket.md) if you do not already have one.


## Install Restic

As the `pulsys` user install restic with the following command:

```bash
sudo apt -y install restic
```

Run the following command to confirm it is installed correctly:

```bash
restic version
```

## Create the Restic Repository

1. Configure Restic to use Google Cloud Bucket access file (Step 6 in [Service Account Keys Creation](gce_service_account.md) and to use the bucket you created in the Before You Begin section of this guide. and substitute `gs:postgres-version-backup:yourpath` below with your own values.

    ```bash
    export GOOGLE_PROJECT_ID=pul-gcdc
    export GOOGLE_APPLICATION_CREDENTIALS=~/.restic/pul-gcdc-filename.json
    restic -r gs:postgres-version-backup:yourpath init
    ```
2. Following the prompt, set a password to encrypt your repository’s data. Enter your desired password twice, and be sure to save it! 
3. Add the encryption password to Lastpass and add it as a vaulted variable in princeton_ansible. **Losing this password will make our backups inaccessible!**

## Store the file and password

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
     
## Backup All Databases

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

## Restore from a backup

To restore the latest usable postgresql backup from restic, run the following commands:

  1. As the postgresql user run the following steps:
     ```bash
      sudo su - postgres
      source .env.restic
      restic -r gs:postgres-version-backup:yourpath -p /var/lib/postgresql/.restic.pwd snapshots
      ```
  2. Find the hash key of the database you want to restore from and dump it with the following commands. In our example the hash will be `4f155a5e`
     ```bash
     restic -r gs:postgres-version-backup:yourpath -p /var/lib/postgresql/.restic.pwd restore 4f155a5e -t /tmp
     ```
     This will restore your database at `/tmp/postgresql`

To restore the latest usable mariadb backup from restic, run the following commands:

  1. As the `pulsys` user run the following steps:
     ```bash
      source .env.restic
      restic -r gs:mariadb-version-backup:yourpath -p /home/pulsys/.restic.pwd snapshots
      ```
  2. Find the hash key of the database you want to restore from and dump it with the following commands. In our example the hash will be `4f155a5e`
     ```bash
     restic -r gs:mariadb-version-backup:yourpath -p /home/pulsys/.restic.pwd restore 4f155a5e -t /tmp
     ```
     This will restore your database at `/tmp/mariadb`
