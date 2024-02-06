## Before you begin

If one doesn’t exist yet create a Google Service Account and Google Bucket. 

Create an Object Storage bucket to hold your backup repository. Follow the Create a Bucket guide if you do not already have one.


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

Configure Restic to use Google Cloud Bucket access file  and to use the bucket you created in the Before You Begin section of this guide. and gs:postgres-version-backup:yourpath with your own values.

```bash
export GOOGLE_PROJECT_ID=pul-gcdc
export GOOGLE_APPLICATION_CREDENTIALS=~/.restic/pul-gcdc-filename.json
restic -r gs:postgres-version-backup:yourpath init
```
