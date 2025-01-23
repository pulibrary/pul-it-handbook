We have 4 load balancer machines running nginxplus, `adc-prod1` and `adc-prod2` for our production environment, and `adc-dev1.lib` and `adc-dev2.lib` for our staging environment. At all times, one is active and one is a hot backup.

## Finding the active load balancer

Only one of the load balancer machines is active at any given time. A special IP address (128.112.203.146 - for production) and (172.20.80.19 - for staging) is always assigned to the active box - it moves between the two boxes depending on which is active.

The active machine has two IPs assigned, including the special IP address ending in `146` (production) and `19` (staging). To check which machine is active, open an SSH connection to one and look at the IP addresses. On the active machine, the two IP addresses show up when you first log in:

```
IPv4 address for eno1: 128.112.203.144
IPv4 address for eno1: 128.112.203.146
```

for production or

```bash
IPv4 address for ens32: 172.20.80.14
IPv4 address for ens32: 172.20.80.19

```
for staging

Or you can run a command to check:

```
ip a | grep 146
```

for production or

```bash
ip a | grep 19
```

for staging

This command returns an `inet` line if the machine is active, or nothing if it is not active.

## Using the Admin UI

On the Admin UI you can turn traffic on and off or view the status of any of the webservers the load balancer knows about.

To connect to the Admin UI, create an SSH tunnel from your machine:
```
ssh -L 8080:localhost:8080 pulsys@adc-prod1
```

or

```bash
ssh -L 8080:localhost:8080 pulsys@adc-dev1.lib.princeton.edu
```

Make sure it's the active box.
```
ip a | grep 146
```

or

```bash
ip a | grep 19
```

You will see an `inet` line if `adc-prod1` (on production) or `adc-dev1.lib` is the active box. If it's not exit and tunnel to `adc-prod2` (on production) or `adc-dev2.lib` instead.

Once you have a tunnel open to the active load balancer, you can open up a web browser to http://localhost:8080 and access the Admin UI dashboard. From there, click on `HTTP Upstreams` to view sites, VMs, health checks, and more.

## Running the nginx playbook

1. Let folks know that you're running the playbook in the #infrastructure channel. Link to the branch or PR if you are running it against a branch.
1. Check which load balancer is active (see above).
2. Run the nginx playbook against the non-active load balancer. For example, if `adc-prod1` is active, run the `nginxplus.yml` playbook against `adc-prod2`: `ansible-playbook playbooks/nginxplus.yml --limit adc-prod2.princeton.edu`.
  * Run the nginx playbook against the non-active load balancer. For example, if `adc-dev1.lib` is active, run the `nginxplus_staging.yml` playbook against `adc-dev2.lib`: `ansible-playbook playbooks/nginxplus_staging.yml --limit adc-dev2.lib.princeton.edu`.
3. If the playbook fails, fix the failures and run it against the non-active load balancer again, until it succeeds. 
4. Run the nginx playbook against the second load balancer, the one that was active when you started which will now become the inactive load balancer.

### Only upload the new config files
1. Let folks know that you're running the playbook in the #infrastructure channel. Link to the branch or PR if you are running it against a branch.
1. Check which load balancer is active (see above).
2. Run the nginx playbook against the non-active load balancer. For example, if `adc-prod1` is active, run the `nginxplus.yml` playbook against `adc-prod2`: `ansible-playbook playbooks/nginxplus.yml --limit adc-prod2.princeton.edu -t update_conf`.
  * Run the nginx playbook against the non-active load balancer. For example, if `adc-dev1.lib` is active, run the `nginxplus_staging.yml` playbook against `adc-dev2.lib`: `ansible-playbook playbooks/nginxplus.yml --limit adc-dev2.lib.princeton.edu -t update_conf`.
3. If the playbook fails, fix the failures and run it against the non-active load balancer again, until it succeeds.
4. Run the nginx playbook against the second load balancer, the one that was active when you started which will now become the inactive load balancer.


## Updating the load balancers manually

Sometimes you need to update nginx configuration manually on the load balancers. Usually this means something is already broken in production. Here's what you need to know:

- Start on the active load balancer - things are already broken.
- The nginx config files are in `/etc/nginx/conf.d`.
- Use `sudo [your editor]` to edit them.
- Run `sudo nginx -t` to confirm that the changed config files are valid.
- Reload nginx to pick up the config changes. Restart if that doesn’t work.
  - Reload: `$ sudo service nginx reload`
  - Restart: `$ sudo service nginx restart`
- Check the site you updated to be sure your changes fixed the problem.
  - If the problem isn't fixed, check that the load balancer you updated is still active.
- Once the site is working correctly on the active load balancer, SSH into the inactive load balancer and repeat the edit and syntax check there. You don't need to reload or restart on this machine. The config files should be identical on both load balancers when you are done.
- When everything is working correctly, update the `princeton_ansible` repo with the changes you made manually, so the next time we run the nginx playbook, your changes will be retained on the load balancers.

## Initial HA Setup

### Configuring High Availability 

These steps are needed when setting up an active-passive pair of nginxplus load balancers the first time. We will need to run the `/usr/bin/nginx-ha-setup` script on both nodes as the root user. The script configures a highly available NGINX Plus environment with an active-passive pair of nodes acting as primary and backup. It prompts for the following data:

- IP address of the local and remote nodes (one of which will be configured and the primary (active), the other as the backup (passive))
- One additional free IP address to be used as the cluster endpoint's (floating) VIP

The configuration of the keepalived daemon is recorded in /etc/keepalived/keepalived.conf. The configuration blocks in the file control notification settings, the VIPs to manage, and the health checks to use to test the services that rely on VIPs. Our floating IP for the production environment is `128.112.203.146` and `172.20.80.19` for our dev environment.
