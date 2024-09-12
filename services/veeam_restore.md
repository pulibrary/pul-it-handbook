# Don't Panic

Virtual machines that have special tags in vSphere (they look like `LIB_<datacenter>_<day-of-week>_A` for Linux or `LIB_<datacenter>_<day-of-week>_B` for Windows - the datacenters are called `NS` for New South and `151` for Forrestal) are backed up automatically using Veeam. To restore from a Veeam backup, make a request using the [Generic Request form](https://princeton.service-now.com/service?id=sc_cat_item&sys_id=d93521720fcf820033f465ba32050ee5) from OIT.

We used to keep a spreadsheet of [VMs on the Veeam backup list](https://princetonu.sharepoint.com/:x:/r/sites/library/systems/Shared%20Documents/Server%20Documentation/Backup/Library%20Veeam%20Backup%20Schedules.xlsx?d=wc6e6edba4e224c6bbb8f0a1067b98801&csf=1&web=1&e=0gJi8U) in Sharepoint. Now we have a template in Ansible Tower called View VEEAM Backup List that shows which VMs have which tags. The intention is to balance the load of backups across days of the week and between data centers.


 * Open a new SN@P Incident 
 * Assign to storage
 * Give as much detail as possible as to where the files were located  and when they were deleted 

The example below is for a full Virtual Machine restore:

```
Veeam restore of VM: 

Good afternoon, 

We would like to have a VM restored from Veeam backup. Please restore the VM named “lib-myserver”. This VM is configured to use the backup schedule LIB_151_MON_A. Please restore the latest backup to the ESXi host Lib-VMServ04a and if possible name it “lib-myserver_YYYY-MM-DD” using the date of the restore. You can leave this VM powered off. If you have any questions or need additional information please let me know. 

Thank you, 

-MyName 
```

In the event that you want a specific file restored use the following example:

```bash
Veeam restore of file/directory: 

Note: For Linux files/dirs restore to Lib-vRestLin, for Windows restore to Lib-vRestWin. 

Good afternoon, 

We would like to restore the {latest|point in time} backup of the {file|dir} on the server “Lib-MyServer”. Please restore to the restoration host {Lib-vRestLin|Lib-vRestWin}. If you have any questions or need additional information please let me know. 

Thank you, 

-MyName
```
```
