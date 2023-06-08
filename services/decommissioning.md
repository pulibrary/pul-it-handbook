Checklist for decommissioning library machines:

Disconnect network for 30 days
Note: This allows time for the unexpected - if someone really was using the server, they can tell us and we can bring it back

If the 30 days go by and nobody complains, then decommssion the server:

For Physical Servers:
1. Remove from rack, Store in Firestone rack for 6 months
2. After 6 months, low-level format the disk or pull out all disk drives and send to surplus for shredding
3. Record and send to Surplus

For Virtual Servers:
1. Copy VM files to archival disk, then delete from VM environment.

Once the server is decommissioned, remove all traces of it:
1. Remove Host database entry.
2. Remove from any monitoring services(IE: Nagios, Datadog, etc).
3. Remove from firewall rules.
4. Remove from BigFix.
5. Remove from inventory spreadsheet.
6. Remove from TSM
7. Remove from VDP
8. Remove computer account from domain (If joined)
