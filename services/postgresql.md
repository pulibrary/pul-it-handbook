## Allow access from a new box

This task is now automated! If you see the error below you need to add the following to your group vars (assumiming postgres version 10 and staging machine) and rerun your playbook
```
postgres_host: '{{ vault_postgres_staging_host }}'
postgres_version: 10
postgres_is_local: false
```

When provisioning with ansible, if you haven't done this, you'll get an error message like
```
TASK [pulibrary.postgresql : create postgresql db users] ***************************************************************************************************************************
An exception occurred during task execution. To see the full traceback, use -vvv. The error was: FATAL:  no pg_hba.conf entry for host "XXX.XXX.XXX.XXX", user "[redacted]", database "[redacted]", SSL off
fatal: [my-server.princeton.edu]: FAILED! => {"changed": false, "msg": "unable to connect to database: FATAL: no pg_hba.conf entry for host \"XXX.XXX.XXX.XXX\", user \"[redacted]\", database \"[redacted]\"...}
```
