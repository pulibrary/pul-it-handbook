## Allow access from a new box
* ssh as pulsys into `lib-postgres1` (this may also be `lib-postgres3` if one is looking to provide access for a server in the staging environment)
* go to `/etc/postgresql/{{ postgres version }}/main`
* add an entry to `/etc/postgresql/[VERSION]/main/pg_hba.conf` (where VERSION corresponds to the release of PostgreSQ on this server, e. g. `10`)
  * At the bottom of the permitted entries, add the new line structured as the following:
  * `host    all             all             HOST_IP/32       md5`
* `sudo service postgresql reload`

When provisioning with ansible, if you haven't done this, you'll get an error message like
```
TASK [pulibrary.postgresql : create postgresql db users] ***************************************************************************************************************************
An exception occurred during task execution. To see the full traceback, use -vvv. The error was: FATAL:  no pg_hba.conf entry for host "XXX.XXX.XXX.XXX", user "[redacted]", database "[redacted]", SSL off
fatal: [my-server.princeton.edu]: FAILED! => {"changed": false, "msg": "unable to connect to database: FATAL: no pg_hba.conf entry for host \"XXX.XXX.XXX.XXX\", user \"[redacted]\", database \"[redacted]\"...}
```
