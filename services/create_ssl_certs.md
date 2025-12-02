# Certificate Management

## Creating TLS Certificates

### For sites on the .princeton.edu domain

1. You can create auto-renewing certificates and keys directly on the load balancers for sites in the .princeton.edu domain. You can create a single certificate and key with [playbooks/incommon_certbot.yml](https://github.com/pulibrary/princeton_ansible/blob/main/playbooks/incommon_certbot.yml) or create a single certificate with multiple names and keys with [playbooks/incommon_certbot_multi.yml](https://github.com/pulibrary/princeton_ansible/blob/main/playbooks/incommon_certbot_multi.yml)

   1. You will need to run the above playbook on each load balancer sequentially
   1. If the certificate already exists you will need to revoke it before running your chosen playbook

### For sites outside the Princeton domain

1. Create a new entry under [sites](https://github.com/pulibrary/princeton_ansible/blob/dac77a6c2e0f1301201c9b2a63b9ebead5f7b7ac/group_vars/nginxplus/production.yml#L16)
2. Run the [nginxplus playbook](https://github.com/pulibrary/princeton_ansible/blob/main/playbooks/nginxplus.yml)
3. Your TLS/SSL cert will be on the production loadbalancer
4. Verify the files you get back and add them to your server configuration.

## Verifying certbot certificate renewals

To verify that a certificate on a server will auto-renew:

sudo certbot --standalone --non-interactive --agree-tos --email <simonlee@princeton.edu> --server <https://acme.sectigo.com/v2/InCommonRSAOV> --eab-kid  <certbot-key-eab-kid> --eab-hmac-key <certbot-key-eab-hmac-key> renew --dry-run

This command checks all certs that certbot knows about on that server.

## Viewing certificates in Sectigo

Our certificate management system is Sectigo. Operations folks can [log into Sectigo](https://cert-manager.com/customer/InCommon) using their alias email accounts and individual passwords. We can view certificate status there, but we cannot revoke or renew certificates there.

## Manually managed certs list

These certs are not managed by our usual process. These certs cover:

- sites we do not serve from the load balancers
- vendor-hosted sites with the '.princeton.edu' extension

Many of these certs must be deployed manually. Some must also be renewed manually. If a private key is kept in princeton_ansible, it is encrypted as a file in the `/keys/` directory of the repo.

cicognara.org
  * Purpose: public site for the Cicognara collection (a collaborative project)
  * Managed: [Lego](https://github.com/pulibrary/princeton_ansible/blob/main/roles/nginxplus/tasks/lego.yml)
  * Deployed: on the load balancers

dataspace.princeton.edu
  * Purpose: production site for dspace
  * Managed: Via [Lego](lego.md)
  * Deployed: on Google cloud, on prod.pulcloud.io

dataspace-dev.princeton.edu
  * Purpose: dev/staging site for dspace
  * Managed: Via [Lego](lego.md)
  * Deployed: on Google cloud, on dev.pulcloud.io

dataspace-staging.princeton.edu
  * Purpose: dev/staging site for dspace
  * Managed: Via [Lego](lego.md)
  * Deployed: on Google cloud, on dev.pulcloud.io

dss2.princeton.edu
  * Purpose: secures dataset downloads from a separate server for DSS via a web browser
  * Managed: in ServiceNow - John will move to letsencrypt
  * Deployed: on the dss2 CentOS VM
  * Notes: cannot be a SAN name for the main DSS cert, because we only want to secure this functionality on one machine - can be tricky to maintain because server access requires signing nondisclosure agreements (for protected data)

ezproxy.princeton.edu
  * Purpose: allows access to journals by confirming Princeton affiliation
  * Managed: on ezproxy-prod1 by letsencrypt
  * Deployed: in /etc/letsencrypt/live/ezproxy on the ezproxy-prod1 server

imagecat2.princeton.edu
  * Philippe will shut down the server once he has copied whatever we need from it. Once it's gone, we can revoke the cert.

lib-aeon.princeton.edu
  * Purpose: redirects traffic to hosted Aeon service at <https://princeton.aeon.atlas-sys.com>
  * Managed: for new site by the vendor
  * Deployed: to new site by the vendor
  * Notes: We would like to redirect the old URL on the load balancers and power off the old lib-aeon machine. The templates for printing Aeon call slips, which used to live on the lib-aeon machine, have been moved to a fileshare called aeonprint on lib-fileshare.

lib-gisportal.princeton.edu
  * Purpose: for maps (Wangyal)
  * Managed: in ServiceNow
  * Deployed: in IIS on a physical machine that runs MS HyperV virtualization - cluster of lib-geoserv1 and lib-geoserv2 (not the Lib-Gisportal2 VM) server
  * Notes: windows physical machine, you must be an admin on the Windows box, expires 2024/07/30

lib-illsql.princeton.edu
  * Purpose: interlibrary loan
  * Managed: in ServiceNow
  * Deployed: in IIS, on the lib-illiad-new VM
  * Notes: Windows VM; cert has a SAN name of lib-illiad.princeton.edu; we hope to migrate this to a hosted platform in 2024

libserv97.princeton.edu
  * Purpose: Philippe's test machine, may disappear in 2024
  * Managed: in ServiceNow
  * Deployed: directly on the libserv97 VM (dev environment)

oar.princeton.edu
  * Purpose: production site for oar
  * Managed: Via [Lego](lego.md)
  * Deployed: on Google cloud, on prod.pulcloud.io

oar-dev.princeton.edu
  * Purpose: production site for oar
  * Managed: Via [Lego](lego.md)
  * Deployed: on Google cloud, on prod.pulcloud.io

oar-staging.princeton.edu
  * Purpose: production site for oar
  * Managed: Via [Lego](lego.md)
  * Deployed: on Google cloud, on prod.pulcloud.io

pcdm.org
  * Purpose: Portland Common Data Model
  * Managed: [Lego](https://github.com/pulibrary/princeton_ansible/blob/main/roles/nginxplus/tasks/lego.yml)
  * Deployed: on the load balancers

pulmirror.princeton.edu
  * Purpose: distributing Ubuntu packages
  * Managed: Via [Lego](lego.md)
  * Deployed: on Google cloud at pulmirror.princeton.edu

recapgfa.princeton.edu
  * Purpose: ReCAP inventory management system
  * Managed: by ACME directly on the VM
  * Deployed: N/A - it automatically renews

scsb.recaplib.org
  * Purpose: external hosted service for research collections
  * Managed: on DNSimple and Vendor's AWS Certificate Manager
  * Deployed: by vendor and CNAME validation on DNSimple

simrisk.pulcloud.io
  * Purpose: experimental application for CDH
  * Managed: on staging.pulcloud.io by acme-client contacting letsencrypt CA
  * Deployed: in /etc/ssl/simrisk.pulcloud.io.fullchain.pem on the staging.pulcloud.io server
  * Maintained using `/etc/daily.local` as root

tigris.princeton.edu
  * Purpose: hosted service for University Records management
  * Managed: in ServiceNow, private key is in princeton_ansible
  * Deployed: by vendor; to update, email a .pfx file of the cert to <support@gimmal.com>

### scsb

If ever there is a change in the application vendor will provide CNAME which can be added to DNSimple configuration

#### Tigris

In July of every year [tigris.princeton.edu](tigris.princeton.edu) will get an automatic renewal. The following steps will be needed to ensure the certificate remains renewed.

- Open a ticket with tigris (aka Gimmal) support at <support@gimmal.com> and ask who should receive the new chained file.
- You will need the [vaulted private key](https://github.com/pulibrary/princeton_ansible/blob/main/keys/tigris_princeton_edu_priv.key) and the certificate and intermediate certificate to generate a pfx file that you will ship to the vendor

  ```bash
  cat ~/path/to/downloads/tigris_princeton_edu_cert.cer ~/path/to/downloads/tigris_princeton_edu_interm.cer > keys/tigris_princeton_edu_chained.pem
  ```

This will generate a chained file. You will be prompted for a password in the next step.

```bash
  openssl pkcs12 -export -out tigris_princeton_edu.pfx -inkey tigris_princeton_edu_priv.key -in tigris_princeton_edu_chained.pem
```

Send the resulting file to the tigris support folks via [the Secure Send Portal](https://securesend.princeton.edu/#/) along with the password used above

[1] Subject Alternative Names are used when multiple domains share the same certificate as shown ![SAN Example](images/san/san_example.png)
