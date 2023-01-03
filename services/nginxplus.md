We have 2 load balancer machines running nginxplus, lib-adc1 and lib-adc2. At all times, one is active and one is a hot backup.

## Finding the active load balancer

Only one of the load balancer machines is active at any given time. A special IP address (128.112.203.146) is always assigned to the active box - it moves between the two boxes depending on which is active.

The active machine has two IPs assigned, including the special IP address ending in `146`. To check which machine is active, open an SSH connection to one and look at the IP addresses. On the active machine, the two IP addresses show up when you first log in:

```
IPv4 address for eno1: 128.112.203.144
IPv4 address for eno1: 128.112.203.146
```

Or you can run a command to check:

```
ip a | grep 146
```

This command returns an `inet` line if the machine is active, or nothing if it is not active.

## Using the Admin UI

On the Admin UI you can turn traffic on and off or view the status of any of the webservers the load balancer knows about.

To connect to the Admin UI, create an SSH tunnel from your machine:
```
ssh -L 8080:localhost:8080 pulsys@lib-adc1
```

Make sure it's the active box.
```
ip a | grep 146
```

You will see an `inet` line if `lib-adc1` is the active box. If it's not exit and tunnel to `lib-adc2` instead.

Once you have a tunnel open to the active load balancer, you can open up a web browser to http://localhost:8080 and access the Admin UI dashboard. From there, click on `HTTP Upstreams` to view sites, VMs, health checks, and more.

## Running the nginx playbook

1. Check which load balancer is active (see above).
2. Run the nginx playbook against the non-active load balancer. For example, if `lib-adc1` is active, run the `nginxplus.yml` playbook against `lib-adc2`: `ansible-playbook playbooks/nginxplus.yml --limit lib-adc2.princeton.edu`.
3. If the playbook fails, fix the failures and run it against the non-active load balancer again, until it succeeds.
4. SSH to the active load balancer and restart nginx to change which box is active. For example, if  `lib-adc1` is active: `ssh pulsys@lib-adc1.princeton.edu` and from there `$ sudo systemctl restart nginx`. When nginx goes down for the restart, the other box should become active, and the special IP address will be reassigned to it. This may take some time (and possibly a few tries), so check the status before moving on to the next step.
5. Run the nginx playbook against the second load balancer, the one that was active when you started, and is now non-active.

## Updating the load balancers manually

Sometimes you need to update nginx configuration manually on the load balancers. Usually this means something is already broken in production. Here's what you need to know:

- Start on the active load balancer - things are already broken.
- The nginx config files are in `/etc/nginx/conf.d`.
- Use `sudo [your editor]` to edit them.
- Run `sudo nginx -t` to confirm that the changed config files are valid.
- Reload nginx to pick up the config changes. Restart if that doesn’t work.
  - Reload: `$ sudo service nginx reload`
  - Restart: `$ sudo systemctl restart nginx`
- Check the site you updated to be sure your changes fixed the problem.
  - If the problem isn't fixed, check that the load balancer you updated is still active.
- Once the site is working correctly on the active load balancer, SSH into the inactive load balancer and repeat the edit and syntax check there. You don't need to reload or restart on this machine. The config files should be identical on both load balancers when you are done.
- When everything is working correctly, update the `princeton_ansible` repo with the changes you made manually, so the next time we run the nginx playbook, your changes will be retained on the load balancers.
