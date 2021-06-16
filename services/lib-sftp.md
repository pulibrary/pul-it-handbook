## Cron job for cleaning old full and incremental dump files

There is a cron job installed on the lib-sftp server that removes dump files older than 30 days. It runs at 1:00 AM every morning.
The job is installed on the crontab of the `alma` user. To access run this command:

```
sudo su - alma -c "crontab -e"
```
