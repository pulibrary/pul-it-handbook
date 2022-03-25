We have 2 load balancer machines running nginxplus, lib-adc1 and lib-adc2

## Admin UI

On the Admin UI you can turn traffic on and off or view the status of any given machine.

To connect to the admin UI you must create an SSH tunnel from your machine
```
ssh -L 8080:localhost:8080 pulsys@lib-adc1
```

Make sure it's the active box.
```
ip a | grep 146
```

You will see an `inet` line if it's the active box. If it's not exit and tunnel to `lib-adc2` instead.

Then you can open up a web browse to the link http://localhost:8080

## The active machine (more details)

A specially assigned ip address is moved between the two boxes depending on
which is active.

On the active machine the output of `ip a` will have a line that reads
`inet 128.112.203.146/32 scope global eno1` in `eno1`.

## Update on live box

You may need to do this because the ansible scripts take a long time to run.

- config files are in /etc/nginx/conf.d
- sudo [your editor] to edit them.
- `sudo nginx -t` to test the config files are valid
- Reload nginx. (Restart if that doesn’t work)
  - Reload: `$ sudo service nginx reload`
  - Restart: `$ sudo systemctl restart nginx`
  - You may need to check again that the machine you're on is still active.
- Repeat the edit and syntax check on the other load balancer machine. You don't
  need to reload or restart on this machine.
