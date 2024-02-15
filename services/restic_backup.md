## Before you begin

If one doesn’t exist yet create a [Google Service Account](gce_service_account.md) and Google Bucket. 

Create an Object Storage bucket to hold your backup repository. Follow the [Create a Bucket guide](gce_bucket.md) if you do not already have one.


## Install Restic

As the `pulsys` user install restic with the following command:

```bash
sudo apt -y install restic
```

Run the following command to ensure it is installed correctly

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
2. Following the prompt, set a password to encrypt your repository’s data. Enter your desired password twice. (Save this to lastpass and ansible-vault)
3. Losing this password will make our backup inaccessible

## Store the file and password

The access keyfile, and password are required every time Restic communicates with your repository. To make it easier to work with your repository, create a shell script containing your credentials.

  1. To keep your credentials secure, using a text editor, create the example script in the user’s who will run the backup's home directory, and run all your Restic scripts as this user. The example uses the `postgres` user and the vim text editor.
       ```bash
       sudo su - postgres
       mkdir -p .restic
       vim .env.restic
       ```
       
     Copy and paste the json keyfile’s content and replace and with your own Object Storage account’s keyfile.

     ```file
     ### repository on google cloud
     export GOOGLE_APPLICATION_CREDENTIALS='/var/lib/postgresql/.restic/pul-gcdc-07a5b5a58963.json'

     export RESTIC_ARCHIVE_REPOSITORY='gs:postgres-15-backup:daily'

     export RESTIC_REPOSITORY=$RESTIC_ARCHIVE_REPOSITORY
     export RESTIC_PASSWORD_FILE='/var/lib/postgresql/.restic.pwd'
     ```
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
     mkdir ~/.restic/log
     ```
  2. Make all the scripts executable by the user:
     ```bash
     chmod u+x ~/.restic/{common.sh,full_pg_backup.sh,pg_backup.sh,prune.sh}
     ```
     
