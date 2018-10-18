## Allow access from a new box
* ssh as pulsys into lib-postgres1
* go to `/etc/postgresql/{{ postgres version }}/main`
* add the ip to `pg_hba.conf`
* `sudo service postgresql reload`

When provisioning with ansible, if you haven't done this, you'll get an error message like
```
TASK [pulibrary.postgresql : create postgresql db users] ***************************************************************************************************************************
An exception occurred during task execution. To see the full traceback, use -vvv. The error was: FATAL:  no pg_hba.conf entry for host "XXX.XXX.XXX.XXX", user "[redacted]", database "[redacted]", SSL off
fatal: [my-server.princeton.edu]: FAILED! => {"changed": false, "msg": "unable to connect to database: FATAL: no pg_hba.conf entry for host \"XXX.XXX.XXX.XXX\", user \"[redacted]\", database \"[redacted]\"...}
```
