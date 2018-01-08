## Allow access from a new box
* ssh as pulsys into lib-postgres1
* go to `/etc/postgresql/{{ postgres version }}/main`
* add the ip to `pg_hba.conf`
* `sudo service postgresql reload`
