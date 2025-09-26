# CheckMK

[CheckMK docs](https://docs.checkmk.com/latest/en/). CheckMK is a tool we use for basic monitoring, including uptime, memory/CPU/disk usage, and more. 

Our CheckMK monitoring platform is distributed across six sites (for performance reasons). You can see monitoring data from all six sites, as well as administrative data for production services, on the default site at https://pulmonitor.princeton.edu.

The six CheckMK sites all run on production-level systems. They are:
- [production](https://pulmonitor.princeton.edu)
  - runs on `pulmonitor-prod1`
  - monitors on-prem production systems and services
  - shows the consolidated view of all monitoring data
  - grants access to Setup for production systems and services
- [staging](https://pulmonitor.princeton.edu/staging/)
  - runs on `pulmonitor-prod2`
  - monitors on-prem staging systems and services
  - shows only staging monitoring data
  - grants access to Setup for staging systems and services
- [Forrestal OOBM](https://pulmonitor.princeton.edu/forrestal/)
  - runs on the `pulmonitor` VM on physical host lib-vmserv001m
  - monitors hardware in the Forrestal data center
  - shows only Forrestal monitoring data
  - grants access to Setup for Forrestal infrastructure
- [New South OOBM](https://pulmonitor.princeton.edu/new_south/)
  - runs on the `pulmonitor` VM on physical host lib-vmserv002m
  - monitors hardware in the New South data center
  - shows only New South monitoring data
  - grants access to Setup for New South infrastructure
- [AWS](https://pulmonitor-aws.pulcloud.net/aws/)
  - runs on an [EC2 instance](pulmonitor-aws.pulcloud.net)
  - monitors AWS resources
  - shows only AWS monitoring data
  - grants access to Setup for AWS resources
- [GCP](https://pulmonitor-gcp.pulcloud.io/gcp/)
  - runs on a [GCP instance](pulmonitor-gcp.pulcloud.io)
  - monitors GCP resources
  - shows only GCP monitoring data
  - grants access to Setup for GCP resources

## Useful GUI pointers
* To log into the GUI:
  - on production and staging, enter your NetID and password, then confirm with 2FA (the webpage will not prompt you to look at DUO)
  - on AWS and GCP, select `Login with Microsoft Azure`
* To check the version of CheckMK: in the left nav bar, select `Help` - the version is displayed at the top of the popup
* If you do not see the left nav bar, open the `Display` menu and toggle `Show page navigation`

## Useful CLI commands

### On a monitored host: 
* Run `sudo cmk-agent-ctl status` to check the agent status on the host.
* Run `sudo cmk-agent-ctl dump > cmk-dump.txt`
to verify that the agent is running successfully and see its parameters.

### On the CheckMK server:
* To check the server status: `sudo omd status <sitename>`.
* To check the connection to a specific host: switch from the 'pulsys' user to the site user (site user names match the site names - `production` for the prod site, `staging` for the staging site, etc., so, for example, `sudo su - production` to run in the production environment), then execute `cmk --debug -vvn hostname`.
* To confirm that the agent port is accessible on a host: as the 'pulsys' user, do `sudo nc -vz hostname.princeton.edu 6556`.
* To restart CheckMK:
  * as the site user, run `cmk -R` to restart the CheckMK service.
  * as the site user, run `omd restart` to restart the Apache webserver.
  * if the site is still down, reboot the VM (Apache may refuse to shut down, in which case you may need to log into vSphere to yank the power)

## Adding a host to CheckMK

1. Add CheckMK to the host `ansible-playbook playbooks/utils/checkmk_agent.yml --ask-vault-pass --limit <host or host group> -e checkmk_folder=linux/<team name>`
   1. Change the host or host group to your host or group (for example `orcid_production`)
   1. Change the team name, choose one: `cdh`, `dacs`, `dls`, or `rdss` (note the lowercase)
1. Add CheckMK local rules `ansible-playbook playbooks/utils/checkmk_add_local_checks.yml --ask-vault-pass --limit <host or host group> -e checkmk_folder=linux/<team name>`
   1. Rule group by defailt is `rails` if this is not a rails project `-e rule_group=group_name`
      1. At the moment no other local check besides rails have been written 

## Source control for CheckMK with git

Our CheckMK servers are set to record all changes as git commits.

* The setting is in Settings . . . General . . . Global Settings in the CheckMK UI.
* The git repo is in the `/omd/sites/<sitename>/etc/check_mk` directory on the server. Note that `/omd/sites/<sitename>` is the home directory of the site-specific user.
* To check the git history on the server and see what changes have been made:
  - `sudo su <site-user>`
  - `cd /omd/sites/<sitename>/etc/check_mk`
  - `git log`

## Logs
On the host:
* The agent seems to log to `/var/log/syslog`.

On the CheckMK server:
* The server logs to `/opt/omd/sites/<sitename>/var/log/` and to `/opt/omd/sites/<sitename>/var/nagios/`. The `/opt/omd/sites/<sitename>/var/log/notify.log` includes records of Slack (and presumably other) notifications; `/opt/omd/sites/<sitename>/var/nagios/nagios.log` logs host and service state messages. All logs are owned by the site user, but it's probably easier to view them with `sudo less /path/to/log` as the 'pulsys' user.

## Changing the Timezone for CheckMK

We tried updating the CheckMK timezone to be 'America/NY' to coordinate between Slack and CheckMK. We edited `/opt/omd/sites/<sitename>/etc/environment` and added `TZ=America/New_York`, then restarted the service. However, this caused a lot of problems. For now, we are leaving the CheckMK timezone as UTC. 

## Setting up SSO AuthN/AuthZ

Authentication for CheckMK is connected to the Princeton single sign-on. Authorization is controlled by two Grouper groups in Active Directory.

To set up AuthN and AuthZ on a new CheckMK server: 
* Log in as the 'cmkadmin' user
* In the CheckMK UI, go to Setup > Users (use the search if Users does not appear as an option under Setup).
* In the Related menu, select LDAP & ActiveDirectory.
* Click on 'Add connection'
* In the 'General Properties' section:
  * Add an 'ID' and 'Description' (in staging we used the name 'pu_ldap' and the Description Princeton LDAP)
* In the 'LDAP Connection' section, set:
    - 'Directory type' to 'Active Directory'
    - 'Connect to' to 'Manually specify list of LDAP servers'
    - 'LDAP Server' to 'ldapproxy.princeton.edu'
  * Check the 'Bind credentials' box and enter the Bind DN, which is stored in our password manager (pattern is CN=name,OU=department,OU=People,DC=pu,DC=win,DC=princeton,DC=edu)
  * Set 'Bind password' to 'Explicit' and enter the password (also stored in our password manager) in the box - this is a read-only password for LDAP
  * Check 'TCP port' and set the value to 636
  * Check 'Use SSL'
  * Check 'Response timeout' and set the value to 5 seconds
* In the 'Users' section: 
  * For the 'User Base DN', enter 'dc=pu,dc=win,dc=princeton,dc=edu'
  * For the 'Search scope', select 'Search whole subtree below the base DN'
  * Check 'Search filter' and enter '(&(objectCategory=Person)(sAMAccountName=*))'
  * Check 'UserID-attribute' and enter 'sAMAccountName'
  * Check 'Create users only on login'
* In the 'Groups' section: 
  * For the 'Group Base DN', enter 'ou=grouper,dc=pu,dc=win,dc=princeton,dc=edu'
  * For the 'Search scope', select 'Search whole subtree below the base DN'
  * Check 'Search filter' and enter '(objectclass=group)'
  * Check 'Member attribute' and enter 'member'
* In the Attribute Sync Plugins section:
  * Check 'Alias'
  * Check 'Authentication Expiration'
  * Check 'Email address'
  * Check 'Roles', and in the new section that opens:
    - check 'Normal monitoring user'
    - click 'Add new element'
    - set the Group DN to 'cn=pu:lib:devops:users,ou=grouper,dc=pu,dc=win,dc=princeton,dc=edu'
    - set 'Search in' to 'This connection'
    - check 'Administrator'
    - click 'Add new element'
    - set the Group DN to 'cn=pu:lib:devops:admins,ou=grouper,dc=pu,dc=win,dc=princeton,dc=edu'
    - set 'Search in' to 'This connection'
* In the 'Other' section, at the very bottom, set the 'Sync interval' to '1 days 0 hours 0 mins'
* Click 'Save and test' at the top
* Note that new users logging in for the first time must log in twice, and it may take some time before new users who should be admins will get the correct permissions. Once the permissions are assigned, the new admin user can (and someone must) activate the User change that made them an admin.

## Setup slack notifications on a particular slack channel

[Documentation from Checkmk](https://docs.checkmk.com/latest/en/notifications_slack.html)

1. Make sure that you are listed as a collaborator on the slack app.
1. Go to [the slack API page for the app](https://api.slack.com/apps/A062SDE2WA2)
1. Press Features > Incoming Webhooks
1. Press the Add New Webhook to Workspace button
1. Choose the channel that should receive the notifications.
1. Copy the webhook url.
1. In the checkmk UI, go to Setup > Events > Notifications
1. Add a new rule
1. Notification method should be: Slack or Mattermost
1. Add the Webhook URL that you got from slack.
1. Under conditions, select the appropriate criteria:
   * "Match folder": this should be the folder of VMs that you want alerts for (for example Linux > DACS)
   * "Match only during time period": this should be Active-Monitoring-2, so you don't get overwhelmed during patch tuesday
