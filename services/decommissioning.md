Checklist for decommissioning library machines:

For any server, first:

* Disconnect server from network for 30 days.

Note: This allows time for the unexpected - if someone really was using the server, they can tell us and we can bring it back.

If the 30 days go by and nobody complains, then decommission the server:

For Physical Servers:
1. Remove from rack, Store in Firestone rack for 6 months.
2. After 6 months, low-level format the disk or pull out all disk drives and send to Surplus for shredding.
3. Record and send hardware to Surplus.

For Virtual Servers:
1. Copy VM files to archival disk.
2. Delete from VM environment.

Once the server is decommissioned, remove all traces of it:
1. Remove Host database entry.
  * [https://princeton.service-now.com/service?id=sc_category&sys_id=0c0591f14f9d270c18ddd48e5210c79c](https://princeton.service-now.com/service?id=sc_category&sys_id=0c0591f14f9d270c18ddd48e5210c79c)
  * Select "Network Record - Delete"
2. Remove from any monitoring services(IE: Nagios, Datadog, etc).
3. Remove from firewall rules.
  * Send a note to lsupport@ 
  * Subject: Hardware Firewall Change - oldvm.princeton.edu
  * Body: Please delete all rules for
4. Remove from BigFix.
5. Remove from inventory spreadsheet.
6. Remove from backup solutions (Cohesity, Veeam).
7. Remove computer account from domain (if joined).
