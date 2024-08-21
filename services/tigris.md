## Infolinx/Tigris

Tigris is a service hosted by [Gimmal](https://gimmal.com/).

### Purpose
Records management software used by both University staff and Library staff in the Library's Records Management. Anne-Marie Phillips is the primary contact for the software. The software product name for this is currently "Infolinx". [Further information](https://gimmal.my.site.com/gimmalsupport/s/). Our implementation is called Tigris.

### Access
Web [tigris login](https://tigris.princeton.edu). You can log into Tigris using your Princeton SSO credentials, as authentication is integrated with our campus IDP. Some Princeton people outside the library also deposit materials to this site. Authorization is governed by membership in certain Active Directory groups established specifically for Tigris. These need to be managed via OIT's [web tools portal](https://tools.princeton.edu). 

Groups defined
* TIGRIS Administrator
* TIGRIS Legal User
* TIGRIS Read Write
* TIGRIS Storage User
* TIGRIS User  

### Renewing the SSL Cert
Our DNS record for tigris.princeton.edu points to: princetonuniversity.cloudapp.net. When the certificate is expiring a new one needs to be emailed to support for tigris at: support@gimmal.com. Must be submitted as a .pfx file. See creating [SSL certs](https://github.com/pulibrary/pul-it-handbook/blob/main/services/create_ssl_certs.md) for more details.

### Getting Tigris Support
General application support questions should be sent via the vendor's support email address of support@gimmal.com. 

