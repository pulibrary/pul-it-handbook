# CheckMK

[CheckMK docs](https://docs.checkmk.com/latest/en/). CheckMK is a tool we use for basic monitoring, including uptime, memory/CPU/disk usage, and more. 

Our CheckMK monitoring platform is distributed across six sites (for performance reasons). You can see monitoring data from all six sites, as well as administrative data for production services, on the default site at https://pulmonitor.princeton.edu.

The six CheckMK sites all run on production-level systems. They are:
- [production](https://pulmonitor.princeton.edu)
  - runs on `pulmonitor-prod1` (48 vCPUs and 96 GB of memory)
  - monitors on-prem production systems and services
  - shows the consolidated view of all monitoring data
  - grants access to Setup for production systems and services
- [staging](https://pulmonitor.princeton.edu/staging/)
  - runs on `pulmonitor-prod2` (32 vCPUs and 96 GB of memory)
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

## CheckMK site performance metrics
* There are three main ways to view CheckMK site performance:
  - add performance widgets to your sidebar (for the site you are logged into)
    - enable the sidebar by clicking on `Sidebar` at the bottom of the left nav bar
    - add one of several widgets by clicking on the `+` at the bottom of the sidebar (at right) - widgets include
      - `Server performance`
      - `Service Speed-O-Meter`
      - `Core statistics`
  - view the `livestatus proxy` services for a monitoring host (for all sites if you are logged into production; otherwise for the site you are logged into)
    - in the Monitor menu, search for `livestatus`
  - view the Analyze configuration page (for the site you are logged into)
    - log into the site you want information about with the `Login with Microsoft Azure` button
    - in the Setup menu, under Maintenance select Analyze configuration
    
## Useful GUI pointers
* To log into the GUI, select `Login with Microsoft Azure`
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
   1. Rule group by default is `rails` if this is not a rails project `-e rule_group=group_name`
      1. At the moment no other local check besides rails have been written 

## Configuring recurring notifications

CheckMK is optimized for checking status in the GUI. However, it can also notify us of problems and recoveries. Our current approach uses Periodic Notifications to enable alerts when a host or service goes down and recurring alerts if it stays down.

There are three parts to a successful recurring alert:

1. the host or service check defines what a problem looks like
1. the rule for periodic notification of problems (host or service problems) defines how often CheckMK looks at the current status
1. the notification event defines where alerts are sent and how often

To set up a recurring alert:

1. Decide what you want to know and how often.
  1. For example, we want a warning if Solr's JVM memory usage rises above 90%. We want a critical alert if it rises above 95%. And we want those alerts to keep coming if the usage remains above those levels.
1. Configure the service check with the correct thresholds.
  1. Many of our checks use CheckMK's reasonable defaults. To check the applicable settings:
    1. Make sure you are logged into the correct site (see above for links). You can see all monitoring data in the production site, but you can only edit hosts and rules in the source site - staging for staging VMs, etc.
    1. Click on `Monitor` and search for the host(s) (for example, type `solr` and hit enter for a view of all the Solr boxes).
    1. Select a single host to see all its services.
    1. Find the service you're working with - for example, JVM Solr Memory. You can click on the service name to see the current status. 
    1. Click on `Setup` and search for the service. It may not match exactly - for example, the JVM Solr Memory service is governed by the JVM memory levels rule. If the rule is using default settings, you will see the message "There are no rules defined in this set." 
    1. Click on "Add rule", enter a Description and Comment, set the Values, use the Conditions to apply the rule to the correct hosts. Save the rule.
1. Check the rule for periodic notification of problems.
  1. Go to `Setup` and type "periodic" in the search bar. Select 'Periodic notifications during service problems'. 
  1. In staging today we have a single rule that applies to everything (by setting the condition to `Main` folder). This rule is called "When a thing stays down, notify us once per minute that it's still down". Don't panic! We're not going to send an alert every minute.
  1. In production today we do not have a default setting. You can create specific rules for your specific use case, with conditions that apply only to your folder, host, or service. Check the box for "Enable periodic notifications" and set your preferred Interval in minutes.
1. Create a notification event.
  1. Click on `Setup` and select `Notifications` under `Events`. If you don't see an `Events` heading, type "notification" in the search bar. If you search this way, the result you want shows up as `Notifications` under `Setup`.
  1. Check the existing notifications for one that already does what you need.
  1. Assuming one doesn't already exist, click on "Add notification rule".
  1. Our current approach is to narrow the scope - we may change this in future. But for now, for service notifications, uncheck `Host events` so the notification only applies to services. Then select the events you want to know about. For example, "State change from Any to WARN" and "State change from Any to CRITICAL". Click on "Next step" to open the next section of the page.
  1. In the "Filter for hosts/services" section, check `Services`. Copy the Service name **from the host monitoring screen, NOT from any of the rule definitons**. Click on "Next step" again.
  1. In the "Notification method" section, select Slack or Mattermost. Click on "Next step" again.
  1. In the "Recipient" section, leave the default setting of `All contacts of the affected object`. Click on "Next step" again.
  1. In the "Sending conditions" section, check both "Limit notifications by count to" and "Throttling of 'Periodic notifications'". Get ready to do some simple math.
    1. Set the "Limit by count" feature first. This defines the first and last notification that CheckMK will pay attention to. By default it's set to between 5 and 100, meaning CheckMK will ignore the first 4 checks (with frequency as set in the Periodic service check definition). Configure these numbers to 6 and 9999. If you have the Periodic check set to 1 minute, these settings mean CheckMK will process this rule at 6 minutes into an outage, and continue until 9,999 minutes in. 
    1. Set the "Throttling" feature next. By default this is set to start with notification 10 and send every 5th notification thereafter. Configure the first number to the same number as the start of the "Limit by count" feature. In our example, set "Starting with notification number 6". Configure the second number in multiples of the Periodic service check interval to match your desired frequency of alerts. For example, to get an alert every hour, assuming the Periodic service check interval is set to 1 minute, set "Send every 60" notifications.
  1. Click "Apply and test notification rule".
1. Test your notification rule.
  1. 

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

We set the CheckMK timezone to be 'America/NY' to coordinate between Slack and CheckMK. Specifically, we changed the Timezone on the VMs that run CheckMK. A few online posts recommend editing `/opt/omd/sites/<sitename>/etc/environment` to change the Timezone - don't do this. We tried it this way and it caused a lot of problems.

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
