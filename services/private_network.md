# Don't Panic

This guide helps us to move a fictional brownfield application from our publicly routed network to our private network. When you complete this your application servers will be on our [RFC 1918](https://www.rfc-editor.org/rfc/rfc1918). 

### Host names
Our Application Delivery Controllers (loadbalancers) are multihomed on both the private and public networks. We take advantage of this by registering the DNS application to live wherever you want this to live. This is unrelated to guide but is a key point to keep in mind. As a developer you may have `mithril-staging.princeton.edu` (if your users have memorized this name probably not worth bothering to make them learn a new name of `mithril-staging.lib.princeton.edu`) The DNS name of the application can remain.

We will still want to move your DNS application name of `mithril-staging.princeton.edu` to the staging the staging load balancer (more below).
#### Application Assumptions

  * Two application servers named mithril-staging{1,2}.princeton.edu
  * DNS name configured on production loadbalancer as mithril-staging.princeton.edu
    * upstream configuration includes
    ```conf
    upstream mithril-staging {
    zone mithril-staging 128k;
    least_conn;
    server mithril-staging1.princeton.edu resolve;
    server mithril-staging2.princeton.edu resolve;
    ```
  * Ansible configuration path on production loadbalancers is `roles/nginxplus/files/conf/http/mithril_staging.conf`


#### Migration Path


##### Keep the current name
 
If you have chosen to keep the name `mithril-staging.princeton.edu` these are your steps. (we want to have minimized downtime)

  * Working with the [Ops team](https://networkregistration.princeton.edu) transfer the DNS of `mithril-staging1.staging.princeton.edu` to `mithril-staging1.lib.princeton.edu`
    * Path with the least surprises is to create two new VMs
    * Run the playbook on your new application servers to set them up. Where applicable run capistrano to update your new application
    * Update the configuration file to point to the new VMS
      ```conf
      upstream mithril-staging {
        zone mithril-staging 128k;
        least_conn;
        server mithril-staging1.lib.princeton.edu resolve;
        server mithril-staging2.lib.princeton.edu resolve;
      ```
  * Working with the [Ops team](https://networkregistration.princeton.edu) transfer the DNS of `mithril-staging.staging.princeton.edu` to the dev loadbalancers # modify `adc-dev.lib.princeton.edu`
    * Run the [Incommon Certificates](playbooks/incommon_certbot.yml)
      * Run `ansible-playbook -v -e domain_name=mithril-staging --limit adc-dev2.lib.princeton.edu playbooks/incommon_certbot.yml`
    * Transfer `roles/nginxplus/files/conf/http/mithril_staging.conf` to `roles/nginxplus/files/conf/http/dev/mithril_staging.conf`

##### Register a new current name
If you have chosen to register a new name `mithril-staging.lib.princeton.edu` these are your steps. (you will have 0 downtime)

  * Working with the [Ops team](https://networkregistration.princeton.edu) transfer the DNS of `mithril-staging1.staging.princeton.edu` to `mithril-staging1.lib.princeton.edu`
    * Path with the least surprises is to create two new VMs
    * Run the playbook on your new application servers to set them up. Where applicable run capistrano to update your new application
    * Create a new configuration file to point to the new VMS
      ```conf
      upstream mithril-staging {
        zone mithril-staging 128k;
        least_conn;
        server mithril-staging1.lib.princeton.edu resolve;
        server mithril-staging2.lib.princeton.edu resolve;
      ```
      ```
  * Working with the [Ops team](https://networkregistration.princeton.edu) create a new the DNS of `mithril-staging.lib.staging.princeton.edu` to the dev loadbalancers # modify `adc-dev.lib.princeton.edu`
    * Create a new configuration file to point to the new VMS
      ```conf
      listen 443 ssl;
        http2 on;
        server_name mithril-staging.lib.princeton.edu;
    

        ssl_certificate            /etc/letsencrypt/live/mithril-staging.lib/fullchain.pem;
        ssl_certificate_key        /etc/letsencrypt/live/mithril-staging.lib/privkey.pem;
        ssl_session_cache          shared:SSL:1m;
        ssl_prefer_server_ciphers  on;
    * Run the [Incommon Certificates](playbooks/incommon_certbot.yml)
      * Run `ansible-playbook -v -e domain_name=mithril-staging.lib --limit adc-dev2.lib.princeton.edu playbooks/incommon_certbot.yml`
    * Create a new configuration on the dev loadbalancers `roles/nginxplus/files/conf/http/dev/mithril_staging.conf`

### ## Princeton Private Network Setup

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
