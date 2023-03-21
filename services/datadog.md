# Datadog

[Datadog](https://app.datadoghq.com/) is a tool we use for monitoring of
application performance, aggregating logs from our servers, and watching some
metrics on each of our servers.

It's moderately expensive, so we try to balance the expense of the service with
the value we get out of it.

## Tips for Controlling Costs

### Logs

We aggregate load balancer and application logs, but try to avoid log monitoring
for services which generate vast amounts of logs - like Solr or database
servers.

### Metrics

Pricing of Datadog is per-host, and is more expensive if that host is tracking
APM (application performance.) So if you want to track things like the memory
and CPU of a server it necessitates spending money. However, if you want to
track metrics about one of our HTTP services you can place those checks on one
of the boxes we already have and then set up monitoring in the DataDog Web API
to use those metrics, which doesn't cost anything extra.

For example, to track SSL certificates configure DPUL to send those metrics -
those boxes are already sending metrics, so it doesn't cost anything extra.
There are two parts - the [Ansible
configuration](https://github.com/pulibrary/princeton_ansible/blob/9c09848656c3a4f14c5007c40c570f3f83345848/group_vars/dpul/production.yml#L119-L148)
and the [Datadog Monitor](https://app.datadoghq.com/monitors/61807889) which
tracks `tls.days_left`.

This is a good trick to use for many of the integrations here:
[https://docs.datadoghq.com/integrations/](https://docs.datadoghq.com/integrations/)

### Uptime Tracking

You can get basic uptime tracking of our sites, if internal checks are
sufficient, via a similar strategy above with the [HTTP
Check](https://docs.datadoghq.com/integrations/http_check/).

However, if you need cloud-based monitoring you can configure Synthetic Tests.
The key to keeping it cheaper is to check as rarely as possible - for many of our sites we check from
one location every 5 minutes. Figgy's manifest check configuration is an
[example](https://app.datadoghq.com/synthetics/edit/czb-n67-mrf).
