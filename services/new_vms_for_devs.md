This documentation is for developers to understand the lifecycle of requesting and using a new Virtual Machine (VM).

### Requesting a new VM for an existing application
- Create a ticket on [Prancible](https://github.com/pulibrary/princeton_ansible/issues/new?assignees=&labels=&projects=&template=new_vm.md&title=). This ticket should include:
  - The fully qualified domain name (FQDN) of any hosts (e.g. `static-tables-staging1.princeton.edu`). In order to facilitate blue-green deployments, these should be new, unused names.
  - Resources needed - Memory, Storage, CPUs
  - Ports for firewall rules - What connections does the application need to be able to make? Examples include
    - SSH = port 22
    - http = port 80 
    - https = port 443
    - Shared postgres = port 5432
    - Shared Solr = port 8983
    - Shared Redis = port 6379
  - Mounts - are there any mounts needed for this application?
  - Level of urgency - how soon is this needed? If there is a specific date, include it.

#### Next steps
- Make sure the FQDN is in the [inventories by environment](https://github.com/pulibrary/princeton_ansible/tree/main/inventory/by_environment) on the main branch of Princeton Ansible. Once it is, you can go to Ansible Tower and sync the inventory there, so that you can run playbooks against the new machines.
  - Go to [Ansible Tower](https://ansible-tower.princeton.edu/)
  - Under "Resources" select "Projects" and click the "refresh" icon so you can be sure you are using the latest code, which includes your VM.
  - Under "Resources" select "Inventories"
  - Select the Prancible Inventory
  - In the tabs for that inventory, select "Sources"
  - You should see "Prancible Inventory Sync" listed, on the right side there is a "refresh" icon that you can use to re-sync the inventory from GitHub
- In Ansible Tower, under Resources you can go to Templates and launch the "Update pulsys user keys" playbook with a limit to the group name for your VMs (e.g. `static_tables_staging`). This should add your keys to the VMs so that you can ssh onto them, or run Ansible playbook on them locally.
- Once these playbooks have been run, you should be able to ssh onto them as the pulsys user (as with all our servers, you will need to be on the VM in order to ssh onto them)
- In order to ssh to the machine as the deploy user, you will need to run the deploy_user playbook, limited to your new VMs, from your local machine. This playbook will also install basic utilities for your servers.
```bash
ansible-playbook playbooks/deploy_user.yml --limit your_vm_group
e.g.
ansible-playbook playbooks/deploy_user.yml --limit static_tables_staging
```
- You will probably want to write an Ansible Playbook to prepare the VM to run your app specifically
- You will need to deploy your app separately in order to see it running
- If you want to see it running on a single VM, tunnel into it first
```bash
ssh -L 1082:localhost:80 pulsys@static-tables-staging1.princeton.edu
```
- Then go to [localhost:1082](http://localhost:1082/) (you can pick a different destination port if you want, just change the `1082` in both places to a different number)
- In order to see the app as you might want a user to, you will need to put it on the load balancer.
  - If the app does not have a pre-existing domain, Ops will need to register one for you.
  - Ensure there is an nginxplus config for your app, or add the servers to an existing config 
    - A more standard setup looks like [roles/nginxplus/files/conf/http/allsearch-api_prod.conf](https://github.com/pulibrary/princeton_ansible/blob/main/roles/nginxplus/files/conf/http/allsearch-api_prod.conf)
    - For an example of a more complex setup, see the library website templates - [roles/nginxplus/files/conf/http/templates/libwww-proxy-pass.conf](https://github.com/pulibrary/princeton_ansible/blob/main/roles/nginxplus/files/conf/http/templates/libwww-proxy-pass.conf)
  - First run the incommon_certbot.yml playbook to add certificates for the site to both load balancers, one at a time, e.g.
  ```
  ansible-playbook playbooks/incommon_certbot.yml --limit lib-adc1.princeton.edu -e domain_name=daviesproject-staging
  ```
  - Next run the nginxplus playbook, following the directions in [services/nginxplus.md](https://github.com/pulibrary/pul-it-handbook/blob/main/services/nginxplus.md)
- You should now be able to see your app in a browser without tunnelling! 
