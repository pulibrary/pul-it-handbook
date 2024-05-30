# CheckMK

[CheckMK docs](https://docs.checkmk.com/latest/en/). CheckMK is a tool we use for basic monitoring, including uptime, memory/CPU/disk usage, and more. 

The staging VM for CheckMK is `pulcheck-staging1`. The production VM for CheckMK is `pulcheck-prod1`.

## Useful commands
On a monitored host: 
* Run `sudo cmk-agent-ctl status` to check the agent status on the host.
* Run `sudo cmk-agent-ctl dump > cmk-dump.txt`
to verify that the agent is running successfully and see its parameters.



On the CheckMK server:
* Switch from the 'pulsys' user to the 'pulmonitor' user (`sudo su - pulmonitor` to run in the new user's environment), then execute `cmk --debug -vvn hostname` to look at the connection to a specific host. 
* As the 'pulsys' user, do `sudo nc -vz hostname.princeton.edu 6556` to confirm that the agent port is accessible on that host.

## Logs
On the host:
* The agent seems to log to `/var/log/syslog`.

On the CheckMK server:
* The server logs to `/opt/omd/sites/pulmonitor/var/log/` and to `/opt/omd/sites/pulmonitor/var/nagios/`. The `/opt/omd/sites/pulmonitor/var/log/notify.log` includes records of Slack (and presumably other) notifications; `/opt/omd/sites/pulmonitor/var/nagios/nagios.log` logs host and service state messages. All logs are owned by the 'pulmonitor' user, but it's probably easier to view them with `sudo less /path/to/log` as the 'pulsys' user.

## Changing the Timezone for CheckMK

We wanted to be able to update the CheckMK timezone to be 'America/NY' so that the times can better coordinate between Slack and CheckMK 

The steps to complete this is the following: 
* Edited `/opt/omd/sites/pulmonitor/etc/environment`, added ‘TZ=America/New_York’

* Restarted the service with `sudo omd restart pulmonitor`

## Checking the CheckMK server status

*  You are able to check the server status with `sudo omd status pulmonitor`