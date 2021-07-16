## Admin UI
To connect to the admin ui you must create an SSH tunnel from your machine
```
ssh -L 8080:localhost:8080 pulsys@lib-adc1
```
Then you can open up a web browse to the link http://localhost:8080

## Determine active machine

To figure out which machine is active:
- ssh to one of them
- `$ip a`
- look for inet `inet 128.112.203.146/32 scope global eno1` in `eno1`. If you see it that's the active machine.
