# Certificate Management

Since the switch from Sectigo to CertiNext, our certificates are no longer tracked in ServiceNow.

## Managing TLS Certificates for sites on our load balancers

Most of our sites are served from our load balancers - any site that is configured by a file in the `nginxplus` role in princeton_ansible is served from the load balancers.

### Creating certificates for sites on our load balancers with ACME

1. You can create certificates and keys directly on the load balancers for sites that are served from them. You can create a single certificate and key with [playbooks/incommon_certbot.yml](https://github.com/pulibrary/princeton_ansible/blob/main/playbooks/incommon_certbot.yml) or create a single certificate with multiple names and keys with [playbooks/incommon_certbot_multi.yml](https://github.com/pulibrary/princeton_ansible/blob/main/playbooks/incommon_certbot_multi.yml). All certificates created with these playbooks will automatically renew using ACME and certbot.

   1. You will need to run the above playbook on each load balancer sequentially
   1. If the certificate already exists you will need to revoke it before running your chosen playbook

### Revoking certificates for sites on our load balancers

When we decommission a site, we need to revoke the certificates for that site.

#### Revoking ACME Certificates

For auto-renewing ACME certificates, use playbooks/incommon_certbot.yml](https://github.com/pulibrary/princeton_ansible/blob/main/playbooks/incommon_certbot_revoke.yml). As with the playbook that creates certificates, you must run the revoke playbook on each load balancer sequentially.

## Verifying certbot renewals of ACME certificates

To verify that a certificate on a server will auto-renew (values for the eab-kid and eab-hmac-key are in group_vars/all/vault.yml):

sudo certbot --standalone --non-interactive --agree-tos --email lsupport@princeton.edu --server https://acme-us.certinext.io/v1/directory --eab-kid  <vault_certinext_acme_eab_kid> --eab-hmac-key <vault_certinext_acme_eab_hmac_key> renew --dry-run

This command checks all certs that certbot knows about on that server.

## Managing certificates in CertiNext

Our certificate management system is CertiNext. Operations folks can [log into CertiNext](https://us.certinext.io/login) using the `Microsoft` login option. We can view certificate statuses, request new manual certificates, and revoke manual certificates there.

### Creating manual certificates

You can create certificates in CertiNext. To create a manual certificate, log into CertiNext, open the Certificates menu in the left navigation bar, and select Orders. The main panel opens with the Domains tab selected by default - this tab displays all certs. Select the Orders tab - this tab only displays PUL certs. Click on the New request button in the upper right and fill out the requested fields. Operations team members can approve manual certificates in CertiNext for PUL certs.

Be sure to document the purpose, management, and deployment of all manual certs on this page (see below).

#### Revoking manual Certificates

To revoke a manual certificate, log into CertiNext, open the Certificates menu in the left navigation bar, and select Orders. The main panel opens with the Domains tab selected by default - this tab displays all certs. Select the Orders tab - this tab only displays PUL certs. Use the Filter interface to narrow your search (note that the `Domain Name` column n the Filter interface corresponds to the `Identifier` column header in the data view). Once you have found the certificate you want to revoke, click on the `View` button to see details. In the "hamburger" (three dots) menu in the upper right of the details view, select `Revoke certificate` to revoke that cert. 

Don't revoke ACME certs in CertiNext. It's possible, and it looks successful, but Let's Encrypt will renew the certificate within 24 hours. You must use the playbooks to revoke ACME certificates.

## Managing TLS certificates for sites that do not run on our load balancers

We have a few sites that need a different approach to certificate management. These sites include:

- sites we run on individual servers or in the cloud
- vendor-hosted sites with the '.princeton.edu' extension
- sites we serve from the load balancers with extensions other than '.princeton.edu'

Many of these certs must be deployed manually. Some must also be renewed manually.

If a private key is kept in princeton_ansible, it is encrypted as a file in the `/keys/` directory of the repo.

Here is the current list:

cicognara.org
  * Purpose: public site for the Cicognara collection (a collaborative project)
  * Managed: [Lego](https://github.com/pulibrary/princeton_ansible/blob/main/roles/nginxplus/tasks/lego.yml)
  * Deployed: on the load balancers

dataspace.princeton.edu
  * Purpose: production site for dspace
  * Managed: Via [Lego](lego.md)
  * Deployed: on Google cloud, on prod.pulcloud.io

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
  * Managed: by ACME on ezproxy-prod1
  * Deployed: in /etc/letsencrypt/live/ezproxy on the ezproxy-prod1 server

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

lib-reports.princeton.edu
  * Purpose: 
  * Managed: by ACME on the libserv122 VM (aka lib-reports)
  * Deployed: on the libserv122 VM (aka lib-reports)

lib-storage.princeton.edu
  * Purpose: shared storage
  * Managed: by ACME on the libserv171 VM (aka lib-storage)
  * Deployed: on the libserv171 VM (aka lib-storage)

oar.princeton.edu
  * Purpose: production site for oar
  * Managed: Via [Lego](lego.md)
  * Deployed: on Google cloud, on prod.pulcloud.io

oar-staging.princeton.edu
  * Purpose: production site for oar
  * Managed: Via [Lego](lego.md)
  * Deployed: on Google cloud, on prod.pulcloud.io

openpublishing.princeton.edu
  * Purpose: external hosted service for open access to scholarly work
  * Managed: on DNSimple and Vendor's AWS Certificate Manager
  * Deployed: by vendor (Notch8) and CNAME validation on DNSimple
  * If ever there is a change in the application vendor will provide CNAME which can be added to DNSimple configuration
  * NOTE: DNSimple currently only allows one MFA connection. If you need to log into DNSimple, ping Francis for more information.

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
  * Managed: by ACME on the recapgfa prod VM
  * Deployed: on the recapgfa production VM 

scsb.recaplib.org
  * Purpose: external hosted service for research collections
  * Managed: on DNSimple and Vendor's AWS Certificate Manager
  * Deployed: by vendor and CNAME validation on DNSimple
  * If ever there is a change in the application vendor will provide CNAME which can be added to DNSimple configuration
  * NOTE: DNSimple currently only allows one MFA connection. If you need to log into DNSimple, ping Francis for more information.

tigris.princeton.edu
  * Purpose: hosted service for University Records management
  * Managed: in ServiceNow, private key is in princeton_ansible
  * Deployed: by vendor; to update, email a .pfx file of the cert to <support@gimmal.com>; see details below

#### Tigris renewals

At each renewal period, [tigris.princeton.edu](tigris.princeton.edu) will get an automatic renewal. The following steps will be needed to ensure the certificate remains renewed. Then next renewal date is in December of 2026.

* Open a ticket with tigris (aka Gimmal) support at <support@gimmal.com> and ask who should receive the new chained file.
* You will need the [vaulted private key](https://github.com/pulibrary/princeton_ansible/blob/main/keys/tigris_princeton_edu_priv.key) and the certificate and intermediate certificate to generate a pfx file that you will ship to the vendor

  ```bash
  cat ~/path/to/downloads/tigris_princeton_edu_cert.cer ~/path/to/downloads/tigris_princeton_edu_interm.cer > keys/tigris_princeton_edu_chained.pem
  ```

This will generate a chained file. You will be prompted for a password in the next step.

```bash
  openssl pkcs12 -export -out tigris_princeton_edu.pfx -inkey tigris_princeton_edu_priv.key -in tigris_princeton_edu_chained.pem
```

Send the resulting file to the tigris support folks via [the Secure Send Portal](https://securesend.princeton.edu/#/) along with the password used above

[1] Subject Alternative Names are used when multiple domains share the same certificate as shown ![SAN Example](images/san/san_example.png)
