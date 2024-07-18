# Don't Panic

Our virtual machines are backed up automatically using Veeam. The restoration process will come by making a request from OIT. On the day that you need a restore. The following steps can be used.


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
