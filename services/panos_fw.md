### don't panic!

You will need to do a remote connection to the restricted computers allowed to connect to the PanOS web UI.

Using your browser (best results with Microsoft Edge) connect to the home of the [webUI](https://lib-pan-vm.princeton.edu) and enter your credentials.

#### Add the Object to the Firewall
  * Go to *Objects* Tab (middle of the screen)
  * *Add* the new IP address using the '+' at the bottom left
    * Give it the name ideally same name as first part of DNS like "figgy1"
    * Check the *Shared* box so it is on both sites
    * Add the IP address in the right panel
    * Using a filter by search for the name you just created above and proceed to create a policy for it

#### Add a policy for the Object

  * Go to the *Policies* Tab (also middle of screen)
    * Make sure the drop down has *Device Group* as Shared
  * Go to the bottom of the *Shared_Rules* after all the *Deny Rules*
  * *Clone* a recently created rule with similar ports to the one you are about to create
    * Make sure the *Rule Order* says "After Rule"
    * Change the resulting rule's name to your new one. If you cloned the "orangelight_rule1" the resulting rule will be "orangelight_rule1-1"
    * Rename that to "yourvm_rule1"
  * Go the the *Source* Tab and make sure these are the networks you want. (It is rare that you will need to modify this)
  * Go to the *Destination* and since you cloned a rule modify the destination to be the Object you created in the first section
  * Go to the *Application* Tab and select the applications you would like. This selects the signature of an application like SSH, PostgreSQL etc., (rule definition can be found on [applepedia](https://applepedia.com))
  * You will sometimes need ports not available from Palo Alto. Add and name the new port you want to open.

## Follow Template below for Service Portal:

Find the Service Portal Ticket that needs to be worked on. Add the examples below in the internal work notes.

### Check Hardware Firewall Change most recent closed ticket

Example Ticket Template:
Subject: Hardware Firewall Change – Lib-ServerName
Description: Content of email from requestor. Or simply the reason for the change.

Resolution Format: 

Rules:

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

Rule "Shared_Lib-ServerName_Rule#" deleted:
Reason for deletion: Rule was no longer needed or server has been decommissioned or redundant to rule xyz
Was configured as:
Location: Forrestal
Source: Any
Destination: Lib-ServerName
Application: ssl, web-browsing
Ports: HTTP (TCP 80), HTTPS (TCP 443)
Action: Allow

Rule "Rule ID 250" renamed: "Shared_DSS_Rule6"
Rule "Rule ID 250" moved to device group: “Shared”

Addresses:

Address “Lib-ServerName” created:
Name: Lib-ServerName
Shared: Yes
Description: Aliases or See Ticket# ABC123456
IP Address: 128.112.###.###/32

Address “Lib-ServerName” edited:
Original IP Address: 123.123.123.123
New IP Address: 789.789.789.789

Address “Lib-ServerName” deleted:
Reason for deletion: Ex: The archaic piece of junk finally died. Server has been replaced by lib-ShinyNewServer.
Was configured as:
Name: Lib-ServerName
Shared: Yes
Description: Aliases
IP Address: 128.112.###.###/32

Services:

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

Security Profiles:

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

External Dynamic Lists

External Dynamic List “Some Block List” created:
Name: Some Block List
Shared: Yes
Description: URL to page describing the block list.
Source: URL to text file containing list of IPs
Frequency: Weekly on Monday at 00:00

Committing the changes:
After making the appropriate changes to the FW, they must be committed to go into effect. 
1.	In the upper right click the “Commit” link
2.	In the Commit window, select the “Panorama” radio button
3.	Click “Commit” to save changes to Panorama
4.	After it is complete, click the “Commit” link once again
5.	This time select the “Device Group” radio button
6.	Select “Forrestal” and “New-South” 
7.	Click “Commit” to save changes to each si



## Firewall Steps

* create IP address of host
* objects Tab 
    * Add (plus sign) # bottom left
	  * get name and add to shared
	  * add IP address 
* open policies tab
    * Shared Policies (rules are sequential)
	* Highlight Rule and Clone
	* give the name to new policy
	* In order of importance (Source, Destination, Application Service)
	* Change to new destination if cloned
	* add application rules (applipedia for rules definition)
	
Upon Completion DO

* Commit to Panorama
* Push to Devices (make sure it has pushed before)


