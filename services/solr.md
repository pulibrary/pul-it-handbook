## Data center constraints for our Solr cloud
Due to latency and throughput issues between our two data centers, all VMs on our Solr cloud must be in a single data center for indexing to run successfully. In an outage, one or more VMs may fail over to the other data center - read operations will continue in this scenario, but reindexing will fail. Once the data center has recovered from the outage, log into vSphere and use vMotion to migrate all VMs in our Solr cloud back to the same data center before reindexing.

## Deploying solr configs
Most solr configs are kept in the [pul_solr](https://github.com/pulibrary/pul_solr) repository. Configs are deployed via capistrano, which has been configured to upload config sets and reload collections, to `/solr/pul_solr/` directories on the "leader" box for the Solr cloud. CDH configs go to `/solr/cdh_solr/`. From there the Solr API copies them to Zookeeper for active use.

## Solr backups
As described in the [pul_solr README](https://github.com/pulibrary/pul_solr/blob/main/README.md), Solr backups are kicked off by a cron job. This cron job gets installed by `whenever` on only one of the VMs that comprise each Solr cloud. The server is defined as the first line of the relevant `solr<version_#>_<env>.rb` file in the [/config/deploy directory](https://github.com/pulibrary/pul_solr/tree/main/config/deploy). To view the cron job, SSH to the correct server and run `sudo crontab -l -u deploy`. The cron job runs a rake task, which in turn creates backup files on a shared, mounted drive at `/mnt/solr_backup/solr<version_#>/<env>/<date>/<index_name>.bk`. The cron job backs up the collections listed in the relevant section of `collections.yml` file in the [/config directory](https://github.com/pulibrary/pul_solr/tree/main/config).

## Diagnosing Solr issues

### Accessing the Solr admin interface
To view the Solr admin UI, open an SSH tunnel to any VM in the Solr cloud (for example, `ssh -L 9000:localhost:8983 lib-solr-prod7`) then point a browser at the localhost port you defined for the tunnel: [localhost:9000](localhost:9000).

If you have the `pul_solr` code and gems available, you can also use the shortcut cap task in pul_solr to open the solr admin console: `bundle exec cap solr-production solr:console` or `bundle exec cap solr8-production solr:console`.

### Using the Solr admin interface
The solr admin interface shows (among other things):
* details about the box you opened a tunnel to in the default `Dashboard`
* performance on all VMs in the Solr cloud at `Cloud > Nodes`
* the status of shards and replicas for all collections at `Cloud > Graph`
* details on the configuration of each collection at `Collections > this-collection`
* performance on all Zookeeper boxes at `Cloud > ZK status`

### Monitoring Solr health in Datadog
Datadog also has a [solr health dashboard](https://app.datadoghq.com/dashboard/ce3-krc-gid/solr-health-dashboard).

### Updating replication factor for a collection

1. Open a Solr console in [pul_solr](https://github.com/pulibrary/pul_solr)
1. Under Collections
    1. Look at the collection alias and see which one is currently in service

    2. Click on Add Collection
        1. Give it a recognizable, but different name. If the current one is `dss-staging1`, use `dss-staging2`, for example.
        2. Choose the appropriate config set for the application
        3. Choose replication factor of 3

    3. Delete the alias
    4. Recreate the alias dss-* (staging/prod) and point it to the new collection you just created

2. Re-index the collection
3. Delete the old collection
