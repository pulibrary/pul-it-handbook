# don't panic!

Take a deep breath and follow these 4 steps to update our firewall:
1. Open a remote connection and access the firewall front end
2. Update the firewall (add/edit/change/delete objects and rules)
3. Commit and push your firewall changes
4. Update the Service Portal ticket

## 1. Open a remote connection and access the firewall front end

The firewall is only accessible from computers in our restricted network.

1. Open a remote connection to the restricted computers allowed to connect to the PanOS web UI.
2. Using your browser (best results with Microsoft Edge) connect to the home of the [webUI](https://lib-pan-vm.princeton.edu) and enter your credentials.

## 2. Update the Firewall

Make the necessary changes to the firewall. The most common task is creating a new object and new rules for a new VM.

### For new VMs

#### Add the Object to the Firewall
  * Go to `Objects` Tab (middle of the screen)
    * make sure `addresses` is selected in the left panel
  * Add the new IP address using the '+' at the bottom left
    * Give it the name ideally same name as first part of DNS like `figgy-db-staging1`
    * Check the `Shared` box so it is available in both data centers
    * Add the IP (use CIDR notation with a `/32`) address in the right panel
    * Optionally add a description; all other fields can be left blank
    * Save the object

#### Add policies (firewall rules) for the new Object

  * Go to the `Policies` Tab (also middle of screen)
  * In the `Device Group` dropdown, make sure you have selected `Shared`
  * Search for a similar rule to clone
    * You can search for VM names (`figgy-db-staging1`) or services (`ssh`) to find a similar rule
    * Alternatively, go to the bottom of the `Shared_Rules` after all the `Deny Rules`
  * Clone a rule
    * Find a rule that is similar to the one you want to create - one with the same service, or one for a similar VM (another database VM, for example) usually works well
    * Highlight it by clicking in the row (but not on the rule name, which opens the edit screen) - you can CTRL-click to select multiple rules to clone
    * At the bottom of the window, click on the `Clone` button
    * Put the new rule under the rule you just cloned: make sure the `Rule Order` says "After Rule" and the rule listed is the one you cloned
    * Click `OK`, the new rule appears in the list of rules with a name like `Shared_vm-name-from-cloned-rule_Rule#-1`. For example, if you cloned `Shared_orangelight-prod2_Rule1` the resulting rule will be `Shared_orangelight-prod2_Rule1-1`
  * Edit the cloned rule
    * Click on the title of the cloned rule to open the edit screen
    * Change the name of the cloned rule - usually you just need to change the VM name and remove the `-1` from the end of the name. 
    * In the `Source` tab, make sure these are the networks you want. (It is rare that you will need to modify this)
    * In the `Destination` tab, delete the object (VM) from the cloned rule and add the new VM (the Object you created in the first section)
    * In the `Application` Tab, select the applications you would like. This selects the signature of an application like SSH, PostgreSQL etc., (rule definition can be found on [applepedia](https://applepedia.com)). If you have cloned a similar rule, you probably won't need to change this.
    * Click `Save` to save the changes to the rule

## 3. Commit and push firewall changes

After saving all your changes and additions, you must commit and push your changes - otherwise they will not go into effect. When you have saved all of your changes:

1.	Commit your changes to Panorama
    * In the upper right, click the `Commit` link
    * In the Commit dropdown, select `Commit to Panorama`
    * In the popup, click `Commit` to save changes to Panorama, then wait for the process to finish - ignore warnings about "Disabled applications"
    * When `Status` changes to `Completed` and `Result` to `Successful`, click `Close` to close out the Commit popup
2.	Push your committed changes to the firewall Devices
    * In the upper right, click the `Commit` link
    * This time select `Push to Devices`, you should see both Forrestal and New South in the popup
    *	Click `Push` to propagate your committed changes to the firewalls.
    * If the process is slow, you can close the popup window; the push process will continue. To open the window again and check the status, click on `Tasks` at the bottom right

## 4. Update the Service Portal Ticket

All firewall changes must be logged in the Service Portal. You must describe every action you do in the firewall interface in your notes in the Service Portal ticket. If you create an Object, add a note describing the new object. If you create new rules, add a note describing each new rule. If you rename anything or update anything, add a note for each change showing the old state and the new state. If you delete anything, add a note describing the thing you deleted.

  * Find the ticket that requested the changes
  * Update that ticket by adding detailed notes in the `Work notes (internal only)` section describing the changes you made (see examples below)
    * Optionally search closed tickets for similar changes, so you can copy/paste/modify the notes from those
  * Optionally add a message in the `Comments (Customer visible)` section to send an email to the person who opened the ticket
  * Change the `State` of the ticket to `Closed Complete`
  * Click on `Update` to save your changes, close the ticket, and return to the list of tickets

### Searching for examples among closed tickets

Most firewall-change tickets in the Service Portal have the title `Hardware Firewall Change – <vm-name>`. To find a closed ticket that can give you a useful example:
  * Click on the funnel icon above your list of tickets
  * Change the default `Active - is - true` to `Active - is -false`
  * Make any other changes you need (for example, if you know the ticket was assigned to Alicia, set `Assigned to - is - Alicia Cozine`)
  * Click on the `Run` button to apply your new filters
  * Search through the results for a useful example

## Sample notes for the Service Portal

### Adding a new VM: what to add to the Service Portal ticket

Note the new Object and each new Rule. For example:

Address “Lib-ServerName” created:
Name: Lib-ServerName
Shared: Yes
Description: (optional - if the VM has aliases, etc.)
IP Address: 128.112.###.###/32

Rule "Forrestal_Lib-ServerName_Rule#" created:
Source: Any
Destination: Lib-ServerName
Application: ssl, web-browsing
Ports: HTTP (TCP 80), HTTPS (TCP 443)
Action: Allow

Rule "Shared_Lib-ServerName_Rule#" edited:
Removed Source: Princeton Wired
Added Source: Any
Removed Application: ssl, web-browsing
Added Ports: HTTP (TCP 80), HTTPS (TCP 443)

### Deleting a rule: what to add to the Service Portal ticket

Rule "Shared_Lib-ServerName_Rule#" deleted:
Reason for deletion: Rule was no longer needed or server has been decommissioned or redundant to rule xyz
Was configured as:
Location: Forrestal
Source: Any
Destination: Lib-ServerName
Application: ssl, web-browsing
Ports: HTTP (TCP 80), HTTPS (TCP 443)
Action: Allow

### Changes: what to add to the Service Portal ticket

Renaming a rule:

Rule "Rule ID 250" renamed: "Shared_DSS_Rule6"
Rule "Rule ID 250" moved to device group: “Shared”

Changing an IP address:

Address “Lib-ServerName” edited:
Original IP Address: 123.123.123.123
New IP Address: 789.789.789.789

### Deleting things: what to add to the Service Portal ticket

Address “Lib-ServerName” deleted:
Reason for deletion: Ex: The archaic piece of junk finally died. Server has been replaced by lib-ShinyNewServer.
Was configured as:
Name: Lib-ServerName
Shared: Yes
Description: Aliases
IP Address: 128.112.###.###/32

## Advanced use cases

These changes go beyond creating new VMs and opening them to standard traffic. 

### Adding Ports

You will sometimes need ports not available as "services" from Palo Alto. Add and name the new port you want to open.

### Adding services

If we need access to a new service (for example, if we changed from Redis to a different noSQL option, or if we added proprietary software), you may need to add a service on the firewall so it can recognize that traffic.

#### Adding a new service: what to add to the Service Portal ticket

Service “ServiceName” created:
Name: ServiceName
Description: See Ticket # ABC123456
Shared: Yes
Protocol: TCP (or UDP)
Destination Port: #####
Source Port: 0-65535

Service “ServiceName” deleted:
Reason for deletion:
Was configured as:
Name: ServiceName
Description: See Ticket # ABC123456
Shared: Yes
Protocol: TCP (or UDP)
Destination Port: #####
Source Port: 0-65535
Service “ServiceName” renamed: “NewServiceName”

#### Adding Security Profiles: what to add to the Service Portal ticket

Anti-Spyware Security Profile "AS-ResetC-AlertHML" created:
Location: Shared
DNS Action: alert
DNS Packet Capture: disable
Rule Name: simple-critical
- Threat Name : any
- Severity: critical
- Action: reset-both
- Packet Capture: disable
Rule Name: simple-high
- Threat Name : any
- Severity: high
- Action: alert
- Packet Capture: disable
Rule Name: simple-medium
- Threat Name : any
- Severity: medium
- Action: alert
- Packet Capture: disable
Rule Name: simple-low
- Threat Name : any
- Severity: low
- Action: alert
- Packet Capture: disable

Vulnerability Protection Security Profile "Vuln-ResetC-AlertHM" created:
Location: Shared
Rule Name: simple-client-critical
- Threat Name : any
- Host Type: client
- Severity: critical
- Action: reset-both
- Packet Capture: disable
Rule Name: simple-client-high
- Threat Name : any
- Host Type: client
- Severity: high
- Action: alert
- Packet Capture: disable
Rule Name: simple-client-medium
- Threat Name : any
- Host Type: client
- Severity: medium
- Action: alert
- Packet Capture: disable
Rule Name: simple-server-critical
- Threat Name : any
- Host Type: server
- Severity: critical
- Action: reset-both
- Packet Capture: disable
Rule Name: simple-server-high
- Threat Name : any
- Host Type: server
- Severity: high
- Action: alert
- Packet Capture: disable
Rule Name: simple-server-medium
- Threat Name : any
- Host Type: server
- Severity: medium
- Action: alert
- Packet Capture: disable

Security Profile Group "SP-Alert-Only" renamed "SP-ResetC-AlertHML"

Security Profile Group "SP-Alert-Only" edited:
Changed Anti-Spyware Profile: AS-ResetC-AlertHML
Changed Vuln Protection Profile: Vuln-ResetC-AlertHM

#### Adding External Dynamic Lists: what to add to the Service Portal ticket

External Dynamic List “Some Block List” created:
Name: Some Block List
Shared: Yes
Description: URL to page describing the block list.
Source: URL to text file containing list of IPs
Frequency: Weekly on Monday at 00:00

#### Denying IP Addresses

1. Open a ticket to lsupport@princeton.edu with the subject line: “Hardware Firewall Change - DenyList.” In the body, write: 
	“The IP address xxxxxx is brute forcing SSH on Library servers. This IP and associated range should be blocked.”

2. Log into Panorama. Go to the Objects tab and search for “deny.” This should bring up a list of all the deny rules, sorted numerically. 

3. Scroll down to the last numbered rule and click the Add button. Create a new rule with the next number (e.g. if the last one is Deny069, create “Deny070”).

4. Click the box for Shared. In the Description field, add “See Ticket #[Service Portal ticket # from step 1].”

5. Fill in the IP address of the offending address (include /32 at the end if needed). Hit Ok. 

6. Click on Address Groups in the left-hand navigation menu and search for “Deny.” 

7. Open the "DenyList" address group and scroll down to the latest rule you’ve added. Check the box next to it and click Add. Do this step for each rule. 

8. Commit/push the changes to Panorama.

9. To close the Service Portal ticket, add the following to the internal notes and then close the ticket: 

  Address "Deny[xxx]" created:
  Name: Deny[xxx]
  Shared: Yes
  Description: See Ticket# [current ticket #]
  IP Address: xxxxx/32

  Address Group "DenyList" edited:
  Added address: Deny[xxx]

#### Moving Entries from PanOS DenyList to AWS DenyList through princeton_ansible

1. Log into Panorama. Go to the Objects tab and search for “deny.” This should bring up a list of all the deny rules, sorted numerically (e.g. Deny0xx). If you don't have access to Panorama, you can view the deny rules from the exported [Google Sheet](https://docs.google.com/spreadsheets/d/1K3kZ2_tbynl62S7StJKjIIAmus9xBWXmYbDEHYDsRaA/edit?usp=sharing).

2. Open a rule to note and/or copy its IP address* (note: if the IP has a [CIDR range](https://www.ipaddressguide.com/cidr), don't copy the range at this point; you will need the range later). 

    *Before proceeding, double-check the contents of the [vars file](https://github.com/pulibrary/princeton_ansible/blob/main/roles/denyhost/vars/main.yml) to make sure that the IP address you're adding doesn't already exist in there. If it does, you can skip from this step to step 7 to remove the rule(s) from PanOS. 

3. In a browser, navigate to IPinfo (https://ipinfo.io/). Paste the IP address you just copied into the search portal. This will give you information about the IP address; make note of or copy the organization name, listed as "org: example." Note that you may need to nagivate to other IP lookup sites in case you reach the limits of the "free" (no-login) IPinfo above (another you can use is [DNS Checker](https://dnschecker.org/ip-whois-lookup.php)).

4. Check out a new branch in princeton_ansible to modify the main.yml file located in /roles/denyhost/vars (file here: https://github.com/pulibrary/princeton_ansible/blob/main/roles/denyhost/vars/main.yml).

5. The file will tell you how to add an entry; you will need the name of the organization that you noted above and the IP address (and now the range, if there is a range). An example would look like (make sure to follow YAML formatting!): 

  - name: Test Organization | (Description [comments from PanOS])
  - ip_range: 38.49.xx.xx/32

6. Once you have pushed your PR, run the [denyhost playbook](https://github.com/pulibrary/princeton_ansible/blob/main/playbooks/denyhost.yml) for these changes to take effect. See the [README.md](https://github.com/pulibrary/princeton_ansible/blob/main/README.md) for configuring your environment to run Ansible playbooks from the CLI. 

7. Open a ServiceNow ticket by emailing lsupport@princeton.edu. The subject should read: "Hardware Firewall Change - Remove Denyxxx through Denyxxx" 

      and the body should read something like this: 

      "From the DenyList address group in Panorama, we have added Denyxxx through Denyxxx to the new denylist on AWS via this PR on princeton_ansible: (link to your PR). Please remove Denyxxx-Denyxxx from Panorama." 

