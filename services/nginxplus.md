We have 2 load balancer machines running nginxplus, lib-adc1 and lib-adc2. Only one is active at any given time.

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

On the Admin UI you can turn traffic on and off or view the status of any given machine.

To connect to the admin UI you must create an SSH tunnel from your machine
```
ssh -L 8080:localhost:8080 pulsys@lib-adc1
```

Make sure it's the active box.
```
ip a | grep 146
```

You will see an `inet` line if `lib-adc2` is the active box. If it's not exit and tunnel to `lib-adc2` instead.

Then you can open up a web browser to the link http://localhost:8080

## Running the nginx playbook

1. Check which load balancer is active (see above).
2. Run the nginx playbook against the non-active load balancer. For example, if `lib-adc1` is active, run the `nginxplus.yml` playbook against `lib-adc2`: `ansible-playbook playbooks/nginxplus.yml --limit lib-adc2.princeton.edu`.
3. If the playbook fails, fix the failures and run it against the non-active load balancer again, until it succeeds.
4. SSH to the active load balancer and restart nginx to change which box is active. For example, if  `lib-adc1` is active: `ssh pulsys@lib-adc1.princeton.edu` and from there `$ sudo systemctl restart nginx`. As soon as nginx goes down for the restart, the other box will become active, and the special IP address will be reassigned to it.
5. Run the nginx playbook against the second load balancer, the one that was active when you started, and is now non-active.

## Updating the live box

You may need to do this because the ansible scripts take a long time to run.

- config files are in /etc/nginx/conf.d
- sudo [your editor] to edit them.
- `sudo nginx -t` to test the config files are valid
- Reload nginx. (Restart if that doesn’t work)
  - Reload: `$ sudo service nginx reload`
  - Restart: `$ sudo systemctl restart nginx`
  - You may need to check again that the machine you're on is still active.
- Repeat the edit and syntax check on the other load balancer machine. You don't need to reload or restart on this machine.
