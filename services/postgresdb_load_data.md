# Dump data from production Postgres DB and Load them in staging Postgres DB

This document describes the steps to dump a production database and load the dump file into the staging database.

## Dump data from production

1. ssh to one of the production VMs. Find a [list of the production Vms](https://github.com/pulibrary/princeton_ansible/tree/main/inventory/all_projects).

`ssh deploy@<productionVMName>`
  - Run:  
    `env | grep -i postgres` to find which [postgres production VM](https://github.com/pulibrary/princeton_ansible/blob/main/inventory/all_projects/postgresql#L8-L9) the application is connected to.
    `env | grep -i DB` to find the production <productionDBname> set in the env variable.

2. ssh to the postgres production VM that the <application-production> is connected to. 

   If this is lib-postgres-prod1:

  `ssh pulsys@lib-postgres-prod1` 
  - Run:  
    `sudo su - postgres` to connect to postgres
    `pg_dump -d <productionDBname> -Fc -f /tmp/<productionDBname>_db.dump` to generate  the `productionDBname>_db.dump` dump file.

## Load data into the application staging database  

1. ssh to one of the staging VMs. Find a [list of the staging VMs](https://github.com/pulibrary/princeton_ansible/tree/main/inventory/all_projects).

  `ssh deploy@<stagingVMName>`
  - Run:  
      `env | grep -i postgres` to find which [postgres staging VM](https://github.com/pulibrary/princeton_ansible/blob/main/inventory/all_projects/postgresql#L11-L12) the application is connected to.
      `env | grep -i DB` to find the staging <stagingDBname> and the staging <stagingRoleDBName>: 

2. scp the `productionDBname>_db.dump` dump file you generated in section - Dump data from production - to your local and then to the `/tmp/` directory in the postgres staging VM that the <application-staging> is using. 
If the postgres-production VM has the public key from the postgres-staging VM then you can scp the file directly from the postgres-production VM into the postgres-staging VM.

3. ssh as pulsys in all the staging machines. Find a [list of the staging Vms](https://github.com/pulibrary/princeton_ansible/tree/main/inventory/all_projects) and stop the nginx service.
 
   `ssh pulsys@<stagingVMName>`
   `sudo service nginx stop`


4. ssh to the postgres staging VM that the <application-staging> is connected to.
    
    If this is lib-postgres-staging1:  

   `ssh pulsys@lib-postgres-staging1`
   `sudo su - postgres` to connect to postgres
   `ls /tmp/` confirm that the file `<productionDBname>_db.dump` you transferred in step 2 exists in `/tmp`. If it does not exist do not continue. Go back to step 2 and make sure to transfer the dump file to `/tmp`.

   `dropdb <stagingDBname>` to drop the staging database
   `createdb -O <stagingRoleDBName> <stagingDBname>` to create a new <stagingDBname> with role <stagingRoleDBName> 
   
   `pg_restore -d <stagingDBname>  /tmp/<productionDBname>_db.dump` to load the dump file into the <stagingDBname> database.

5. Deploy the application to the staging environment.
   
   - From your local main branch deploy the application using capistrano to the staging environment.
   - OR deploy the application to the staging environment using [ansible tower](https://ansible-tower.princeton.edu/#/home).

6. ssh as pulsys in all the staging machines. Find a [list of the staging Vms](https://github.com/pulibrary/princeton_ansible/tree/main/inventory/all_projects) and start the nginx service.

e.g.: 
   `ssh pulsys@<stagingVMName>`
   `sudo service nginx start`

7. Go to the <application-staging> url and make sure the application loads and works as expected.

