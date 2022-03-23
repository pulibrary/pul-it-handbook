# VPN

## Providing IPs for external services

Sometimes we have cloud-hosted or vendor services (like ArchivesSpace) which
restricts functionality to parts of the interface to certain IPs, and we'd like
to allow access to VPN (to support our remote staff.) In those cases we need to
provide our VPN endpoint IPs.

Unfortunately the IPs often change and most vendors don't accept FQDNs (fully
qualified domain names, e.g.
canada-west-princeto.gpogn2y5gg2j.gw.gpcloudservice.com) instead
of IP numbers, so we have to resolve the FQDNs and provide them.

All of the endpoints can be found here:
[https://princeton.service-now.com/service?id=kb_article&sys_id=KB0012390](https://princeton.service-now.com/service?id=kb_article&sys_id=KB0012390)
under "Palo Alto GLobalProtect Cloud Gateways". These have been copied into
`services/vpn/ips.txt` in this repository.

### Get IPs

1. Copy all the FQDNs from the article above into `services/vpn/ips.txt`,
   deleting any empty lines or headers which aren't URLs.
1. Run `ruby services/vpn/resolve.rb`
1. Copy the output (IP per line) and send it to the appropriate people.
