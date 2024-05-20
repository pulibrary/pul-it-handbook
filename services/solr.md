## Data center constraints for our Solr cloud
Due to latency and throughput issues between our two data centers, all VMs on our Solr cloud must be in a single data center for indexing to run successfully. In an outage, one or more VMs may fail over to the other data center - read operations will continue in this scenario, but reindexing will fail. Once the data center has recovered from the outage, log into vSphere and use vMotion to migrate all VMs in our Solr cloud back to the same data center before reindexing.

## Deploying solr configs
Most solr configs are kept in the [pul_solr](https://github.com/pulibrary/pul_solr) repository. Configs are deployed via capistrano, which has been configured to upload config sets and reload collections, to `/solr/pul_solr/` directories on the "leader" box for the Solr cloud. CDH configs go to `/solr/cdh_solr/`. From there the Solr API copies them to Zookeeper for active use.

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
