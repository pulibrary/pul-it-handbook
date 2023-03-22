# VPN

## Providing IPs for external services

Sometimes we have cloud-hosted or vendor services (like ArchivesSpace) which
restricts functionality to parts of the interface to certain IPs, and we'd like
to allow access to VPN (to support our remote staff.) In those cases we need to
provide our VPN endpoint IPs, along with any other IPs (like application VMs)
that will require access.

Unfortunately the VPN IPs often change and most vendors don't accept FQDNs (fully
qualified domain names, e.g.
canada-west-princeto.gpogn2y5gg2j.gw.gpcloudservice.com) instead
of IP numbers, so we have to resolve the FQDNs and provide them.

All of the VPN endpoints can be found here:
[https://princeton.service-now.com/service?id=kb_article&sys_id=KB0012390](https://princeton.service-now.com/service?id=kb_article&sys_id=KB0012390)
under "Palo Alto GLobalProtect Cloud Gateways".

### Get IPs

1. Copy all the FQDNs from the article above into `services/vpn/ips.txt`,
   deleting any empty lines or headers which aren't URLs.
1. Run `ruby services/vpn/resolve.rb`
1. Copy the output (IP per line) into a local file.
1. Add the entries from the article under the headings `Palo Alto GlobalProtect` and `Palo Alto GlobalProtect Clientless VPN (Portal)`.
1. Add the IPs for our application VMs. Find them in the lastpass in Shared-ITIMS-Passwords/PUL-VM-IP-ranges
1. Add the IPs for any other applications.
   1. for pulfalight, add the libnova ip, found in lastpass in Shared-ITIMS-Passwords/libnova-IP
1. Send the list to the appropriate people. This should be the complete list of
   machines that need access.
