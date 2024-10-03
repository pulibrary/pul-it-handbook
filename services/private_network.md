# Private Network Migration

Library IT is migrating VMs to new IPs to take advantage of our private network. Our Application Delivery Controllers (loadbalancers) are multi-homed on both the private and public networks, so they can connect to servers on the private network. In tandem with this IP migration, we are also moving FQDNs for VMs to the `.lib` domain and moving staging sites to our staging load balancers.

By migrating our VMs to IPs on the private network, we improve our security posture, expand our network throughput (because the private network has 10GB capacity, compared to 1GB on the public network), and release scarce publicly routable IPs back to the University.

By migrating VM FQDNs to the .lib domain, we can easily see which VMs have publicly routable IPs and which do not.

By migrating staging sites to the staging load balancers, we free up capacity on the production load balancers and reduce risk to production sites from experimentation on staging sites.

## Don't Panic

This guide describes the migration of a fictional brownfield staging application. When it's done, the application servers will be on our [private network (RFC 1918)](https://www.rfc-editor.org/rfc/rfc1918), the VMs will be on our `.lib` domain, and the site will be on our staging load balancers.

### Fictional site before the Migration

The fictional site is called `mithril-staging.princeton.edu`. It's a fairly typcial staging site. Before the migration begins, the site has:
  * An alias configured on our production loadbalancers as mithril-staging.princeton.edu
  * Two VMs called `mithril-staging1.princeton.edu` and `mithril-staging2.princeton.edu` 
  * An nginxplus upstream configuration file in `roles/nginxplus/files/conf/http/mithril_staging.conf`
  * Pointers in that configuration file to the two VMs:
    ```conf
    upstream mithril-staging {
    zone mithril-staging 128k;
    least_conn;
    server mithril-staging1.princeton.edu resolve;
    server mithril-staging2.princeton.edu resolve;
    ```

### Migrating IPs to the private network

To migrate a VM's IP address from a publicly routable IP (usually 128.112.x) to an IP on our private network (usually 10.0.x):

Use the [Network Record - Modify form](https://princeton.service-now.com/service?id=sc_cat_item&sys_id=b28546e14f09ab4818ddd48e5210c756) to request a new IP address for each VM.
1. Select the Device - for example, `mithril-staging1.princeton.edu`
2. Under 'What would you like to modify?' select `Wired static IP`
3. Select the Host (there will only be one) and check 'Add/Modify/Delete MAC Address or Static IP'
4. Under 'IPv4 requiring network change' select the IP/MAC address (there will only be one)
5. Under 'New Network' select `ip4-library-servers`
6. Click Submit
This creates a ticket in ServiceNow, and you should receive the usual ServiceNow updates.

### Migrating VM FQDNs to the .lib domain

We use two kinds of FQDNs in common library tasks: sites and VMs. For example, `mithril-staging.princeton.edu` is a site FQDN; `mithril-staging1.princeton.edu` is a VM FQDN. We can (and probably will) leave all site FQDNs as they are. We do not need to  add `.lib` to site FQDNs - though we can if folks want to!

NOTE: Migrating existing VMs does involve some downtime. If you want to avoid downtime, create new VMs instead. Be sure to give them the `.lib.princeton.edu` extension (in vSphere and in DNS) and to request IPs in the private IP space (the `ip4-library-servers` network).

For example, to migrate `mithril_staging1.princeton.edu` to `mithril_staging1.lib.princeton.edu`:

* Either [transfer the network registration](https://networkregistration.princeton.edu) for the FQDN of each existing VM, or create new VMs in the `.lib` domain. For example, we must transfer `mithril-staging1.princeton.edu` to `mithril-staging1.lib.princeton.edu`.
  * If you transferred existing VMs, change the VM names in vSphere.
  * If you created new VMs, run the application build playbook on your new application servers to set them up. Where applicable run capistrano to update your new application.
* Update the nginxplus config to point to the VMs in the .lib domain (transferred or new):
  ```conf
  upstream mithril-staging {
    zone mithril-staging 128k;
    least_conn;
    server mithril-staging1.lib.princeton.edu resolve;
    server mithril-staging2.lib.princeton.edu resolve;
  ```
* Run the nginxplus playbook to deploy the config changes.
* If you created new VMs, decommission the old one VMs.

### Migrating staging sites to the staging load balancers

To migrate a staging site to the new staging load balancers:

* The Operations team can modify the network registration to transfer the site FQDN `mithril-staging.princeton.edu` from the production loadbalancers to the dev loadbalancers
1. Use the [network record - modify form](https://networkregistration.princeton.edu)
2. Select lib-adc.princeton.edu for the Device
3. Select Wired static IP records for 'What would you like to modify'
4. Select the Host and check 'Add/Modify/Delete alias'
5. Scroll down to find the 'Transfer Aliases' section, and enter the site under 'Aliases to transfer to another Host' and select `adc-dev.lib.princeton.edu` under 'Transfer Aliases to'
6. Click Submit.
* Create SSL certificates on the dev loadbalancers by running the [Incommon Certificates](playbooks/incommon_certbot.yml) on the dev loadbalancers
  * Run `ansible-playbook -v -e domain_name=mithril-staging --limit adc-dev2.lib.princeton.edu playbooks/incommon_certbot.yml`
  * Repeat on adc-dev1.lib.princeton.edu
* Move the site's nginxplus config file from `roles/nginxplus/files/conf/http/mithril_staging.conf` to `roles/nginxplus/files/conf/http/dev/mithril_staging.conf`
* Run the nginxplus playbook on all four loadbalancers (one at a time), to remove the config from production and add it to staging.
* Revoke the old SSL certificates on the production loadbalancers.

## Princeton loadbalancer setup

Our private network setup consists of the following possible configurations.

```mermaid
  graph LR;
      S31[/"Production Loadbalancer [configuration file on lib-adc{1,2}]"/]-->SG1
      S32[/"QA Loadbalancer [configuration file on lib-adc{1,2}]"/]-->SG2
      S33[/"Staging Loadbalancer [configuration file on adc-dev{1,2}]"/]-->SG3
      subgraph project [" "]
      subgraph project_space [" "]
      style project fill:#fff,stroke:#000,stroke-width:4px,color:#000,stroke-dasharray: 5 5
      style project_space fill:#fff,stroke:#000,stroke-width:0px

            subgraph "PreCuration Globus Endpoint [pdc precuration]]"
               SG1[[" [pdc s3 storage gateway precuration]"]]-->B(["Pre Curation Collection (private) [Princeton Data Commons * Precuration]"])
            end

            subgraph "Postcuration Globus Endpoint [pdc postcuration]]"
               SG2[["Post Curation Storage Gateway [pdc s3 storage gateway postcuration]"]]-->D(["Curation Collection(curator only read/write) [Princeton Data Commons * Postcuration]"]);
            end
 
            subgraph "Deposit Globus Endpoint [pdc deposit]]"
               SG3[["Deposit Storage Gateway [pdc s3 storage gateway deposit]"]]-->DE(["Curation Collection(curator controlled read/write) [Princeton Data Commons Deposit]"]);
            end
         
         
      end
   end

   classDef ecclass fill:#00f,stroke:#00f,stroke-width:0px,color:#fff;
   class EC2,EC2a,EC2b,ec2_sp,ec2a_sp,ec2b_sp ecclass;

```
