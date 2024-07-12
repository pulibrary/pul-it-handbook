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
* As the 'pulmonitor' user, run `cmk -R` to restart the checkmk service.

## Logs
On the host:
* The agent seems to log to `/var/log/syslog`.

On the CheckMK server:
* The server logs to `/opt/omd/sites/pulmonitor/var/log/` and to `/opt/omd/sites/pulmonitor/var/nagios/`. The `/opt/omd/sites/pulmonitor/var/log/notify.log` includes records of Slack (and presumably other) notifications; `/opt/omd/sites/pulmonitor/var/nagios/nagios.log` logs host and service state messages. All logs are owned by the 'pulmonitor' user, but it's probably easier to view them with `sudo less /path/to/log` as the 'pulsys' user.

## Changing the Timezone for CheckMK

We wanted to be able to update the CheckMK timezone to be 'America/NY' so that the times can better coordinate between Slack and CheckMK.

To set the timezone for CheckMK: 
* Edit `/opt/omd/sites/pulmonitor/etc/environment`, added `TZ=America/New_York`
* Restart the service with `sudo omd restart pulmonitor`

## Setting up SSO AuthN/AuthZ

Authentication for CheckMK is connected to the Princeton single sign-on. Authorization is controlled by two Grouper groups in Active Directory.

To set up AuthN and AuthZ on a new CheckMK server: 
* In the CheckMK UI, go to Setup > Users (use the search if Users does not appear as an option under Setup). In the Related menu, select LDAP & ActiveDirectory.
* Click on 'Add a connection'
* In the 'General Properties' section:
  * Add an 'ID' and 'Description' (in staging we used the name 'pu_ldap' and the Description Princeton LDAP)
* In the 'LDAP Connection' section, set:
    - 'Directory type' to 'Active Directory'
    - 'Connect' to to 'Manually specify list of LDAP servers'
    - 'LDAP Server' to 'ldapproxy.princeton.edu'
  * Check the 'Bind credentials' box and enter the Bind DN, which is stored in our password manager (pattern is CN=name,OU=department,OU=People,DC=pu,DC=win,DC=princeton,DC=edu)
  * Set 'Bind password' to 'Explicit' and enter the password (also stored in our password manager) in the box - this is a read-only password for LDAP
  * Check 'TCP port' and set the value to 636
  * Check 'Use SSL'
  * Check 'Response timeout' and set the value to 5 seconds
* In the 'Users' section: 
  * For the 'Group Base DN', enter 'ou=grouper,dc=pu,dc=win,dc=princeton,dc=edu'
  * For the 'Search scope', select 'Search whole subtree below the base DN'
  * Check 'Search filter' and enter '(objectclass=group)'
  * Check 'Member attribute' and enter 'member'
* In the Attribute Sync Plugins section:
  * Check 'Alias'
  * Check 'Authentication Expiration'
  * Check 'Email address'
  * Check 'Roles' and add two entries:
    - Set the 'Normal monitoring user' Group DN to 'cn=pu:lib:devops:users,ou=grouper,dc=pu,dc=win,dc=princeton,dc=edu'
    - Set the 'Administrator' Group DN to 'cn=pu:lib:devops:admins,ou=grouper,dc=pu,dc=win,dc=princeton,dc=edu'
    - For both roles, set 'Search in' to 'This connection'
* In the 'Other' section, set the 'Sync interval' to '1 days 0 hours 0 mins'
  
## Checking the CheckMK server status

*  You are able to check the server status with `sudo omd status pulmonitor`
