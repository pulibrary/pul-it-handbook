## Allow access from a new box
* ssh as pulsys into lib-postgres1
* go to `/etc/postgresql/9.6/main`
* add the ip to `pg_hba.conf`
* `sudo service postgresql reload`
