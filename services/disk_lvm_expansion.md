# Managing disk size on VMs

We generally build new VMs with a 30GB main drive. However, we generally "thin provision" all disks, so we need to manage the disk size on new VMs and any time we add a disk to an existing VM.

If a box needs more than the standard 30GB of storage, either when it's first built or later, we attach an additional disk or disks. You can incorporate this additional storage space on an existing virtual machine without shutting it down by expanding the existing logical volume to include the new space.

When building a new VM, you need to expand the size of the main disk and also expand the logical volume to incorporate any secondary disks you added to the VM.

## Expand the size of the main disk

On the main disk, you just need to make the logical volume (LV) take up all the space it has available.

```bash
sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
sudo resize2fs /dev/ubuntu-vg/ubuntu-lv
```

Note that ``/dev/ubuntu-vg/ubuntu-lv`` is the correct name for the LV on our Jammy Jellyfish VMs, but different VMs may use a different name for the LV. See the `Diagnostics and confirmation` section for details on finding the correct name.

## Expand a logical volume with an additional disk

When you add a second (or third, etc.) disk to a VM, you must incorporate it into the logical volume so that all available space is accessible. This process involves 6 steps:

1. Discover the new disk
2. Partition the new disk - this involves an interactive script, where you must supply responses
3. Create the physical volume
4. Extend the volume group
5. Extend the logical volume
6. Resize the disk space

Confirm the available space both before and after these six steps.

### Cheatsheet

These commands match the steps above, using the current default values for the disk, physical volume, volume group, and logical volume:

```bash
df -h
for host in /sys/class/scsi_host/*; do echo "- - -" | sudo tee $host/scan; ls /dev/sd* ; done
sudo fdisk /dev/sdb
```

This is where the interactive script kicks off. Responses to the `fdisk` interactive script in order (press <Enter> to accept the default response):
`n, p, <accept_default>, <accept_default>, <accept_default>, t, 8e, w`
When the interactive script is done, complete the expansion with these commands:

```bash
sudo pvcreate /dev/sdb1
sudo vgextend ubuntu-vg /dev/sdb1
sudo lvextend /dev/ubuntu-vg/ubuntu-lv /dev/sdb1
sudo resize2fs /dev/ubuntu-vg/ubuntu-lv
df -h
```

When expanding a RHEL based VM you may get the following error.

```bash
resize2fs: Bad magic number in super-block while trying to open /dev/rl/root
Couldn't find valid filesystem superblock.
```

When you encounter this expand the volume using

```bash
sudo xfs_growfs /dev/rl/root
```

### Diagnostics and confirmation

The disk size should change between the first time you run `df -h` and the last time you run it. If the disk size has not changed, or if something goes wrong, try these diagnostic tools to troubleshoot:

To view all disks and devices on the VM:

```bash
sudo fdisk -l
```

To view the name of the Volume Group (VG):

```bash
sudo vgdisplay
```

To list the Physical Volumes (PVs):

```bash
sudo pvscan
```

To view the name of the Logical Volume (LV):

```bash
sudo lvdisplay
```

To view disk size and usage:

```bash
df -h
```

## Expanding the logical volume, the hard way

This section covers the same steps as the Cheatsheet, but with a lot more detail.

### Create a new disk in vSphere

Before you can expand the logical volume, the VM must have one or more additional disks attached in vSphere. In the vSphere UI, select the VM and use `Edit settings` to confirm the number of disks and the amount of storage available. If necessary, add a new disk of the desired size.

### Confirm that a logical volume exists

The existing partition must be a logical volume (LVM) for these steps to work. Identify the partition type with `sudo fdisk -l` (or run the command as the root user). Notice that each attached disk has both a `Disk` entry and a `Device` entry. You should see a device with the ID (hex code) `8e` and the Type `Linux LVM`, which denotes a logical volume.

```bash
sudo fdisk -l
```

You will see output similar to this:

```bash
Disk /dev/sda: 40 GiB, 42949672960 bytes, 83886080 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x6c13532e

Device     Boot Start      End  Sectors Size Id Type
/dev/sda1  *     2048 83884031 83881984  40G 8e Linux LVM

Disk /dev/sdc: 100 GiB, 107374182400 bytes, 209715200 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xc9339a9f

Device     Boot Start       End   Sectors  Size Id Type
/dev/sdc1        2048 209715199 209713152  100G 8e Linux LVM

Disk /dev/sdb: 200 GiB, 214748364800 bytes, 419430400 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x3f9e73ac

Device     Boot Start       End   Sectors  Size Id Type
/dev/sdb1        2048 419430399 419428352  200G 8e Linux LVM

Disk /dev/mapper/lib--vg-root: 339 GiB, 364032032768 bytes, 711000064 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

Disk /dev/mapper/lib--vg-swap_1: 980 MiB, 1027604480 bytes, 2007040 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
```

In the example output above, `/dev/sda1` is a Linux logical volume. Once you confirm that you are working with a logical volume, you can continue.

### Connect to the VM and become the root user

SSH into the VM and do `sudo su root` to change users to the root user. You cannot execute the commands in this procedure just using `sudo`.

### Detect and connect the new disk

Once the physical disk has been added at the hardware level, you must connect the new disk to the operating system and create a new partition that makes use of this additional space. The operating system does this for you if you power cycle the VM.

First, check that the new unallocated disk space is detected by the server. Run `df -h` to view the available disk space. You will most likely see that the disk space is still showing as the original size. Re-run `sudo fdisk -l` to list all the disks. The new disk will be the last in the alphabetical list (for example, if the machine has `/dev/sda` through `/dev/sdd`, the new disk is `/dev/sdd`. Likewise, in `/sys/class/scsi_host/` the new disk will be the host with the largest number.
  
If the new disk is not listed, you must rescan all devices to connect the new disk with the operating system on the VM without rebooting the VM. Rescan all devices by running the command below as root. **Use the largest available `host#` on your specific VM.**

```bash
for host in /sys/class/scsi_host/*; do echo "- - -" | sudo tee $host/scan; ls /dev/sd* ; done
```

### Partition the new disk

Re-run `sudo fdisk -l` after the command above to confirm that you see a new disk. You will now notice a new entry (typically) `/dev/sdb` (YMMV). The new disk will have a `Disk` entry but no `Device` entry yet.

To partition this new disk, run:

```bash
fdisk /dev/sdb
```

The `fdisk` command kicks off an interactive script that creates a partition on the new disk. Use the inputs shown below to work through the script. You can press `m` at any time to get a full listing of `fdisk` commands. For a full example, see the output of the interactive script below the list of inputs.

- select **`n`** for a new partition.
- press enter to accept the default **`p`** for a primary partition.
- press enter again to accept the **(default)** for the partition number. (YMMV)
- press enter again to accept the **(default)** for the first sector of the unallocated space. (YMMV)
- press enter again to select the **(default)** for the last sector of the unallocated space. (YMMV)
- select **`t`** to set the type.
- optionally type **`L`** to list all available disk types.
- select **`8e`** for a Linux logical volume, so you can join the new disk space to the original `/dev/sda1` Linux LVM.
- select **`w`** to write the new partition table and get you out of this shell.

Here's what the interactive script looks like:

 ```bash
 Welcome to fdisk (util-linux 2.31.1).
 Changes will remain in memory only, until you decide to write them.
 Be careful before using the write command.

 Device does not contain a recognized partition table.
 Created a new DOS disklabel with disk identifier 0x86a6e447.

 Command (m for help): n
 Partition type
    p   primary (0 primary, 0 extended, 4 free)
    e   extended (container for logical partitions)
 Select (default p): p
 Partition number (1-4, default 1): 
 First sector (2048-209715199, default 2048): 
 Last sector, +sectors or +size{K,M,G,T,P} (2048-209715199, default 209715199): 

 Created a new partition 1 of type 'Linux' and of size 100 GiB.

 Command (m for help): t
 Selected partition 1
 Hex code (type L to list all codes): L

  0  Empty           24  NEC DOS         81  Minix / old Lin bf  Solaris        
  1  FAT12           27  Hidden NTFS Win 82  Linux swap / So c1  DRDOS/sec (FAT-
  2  XENIX root      39  Plan 9          83  Linux           c4  DRDOS/sec (FAT-
  3  XENIX usr       3c  PartitionMagic  84  OS/2 hidden or  c6  DRDOS/sec (FAT-
  4  FAT16 <32M      40  Venix 80286     85  Linux extended  c7  Syrinx         
  5  Extended        41  PPC PReP Boot   86  NTFS volume set da  Non-FS data    
  6  FAT16           42  SFS             87  NTFS volume set db  CP/M / CTOS / .
  7  HPFS/NTFS/exFAT 4d  QNX4.x          88  Linux plaintext de  Dell Utility   
  8  AIX             4e  QNX4.x 2nd part 8e  Linux LVM       df  BootIt         
  9  AIX bootable    4f  QNX4.x 3rd part 93  Amoeba          e1  DOS access     
  a  OS/2 Boot Manag 50  OnTrack DM      94  Amoeba BBT      e3  DOS R/O        
  b  W95 FAT32       51  OnTrack DM6 Aux 9f  BSD/OS          e4  SpeedStor      
  c  W95 FAT32 (LBA) 52  CP/M            a0  IBM Thinkpad hi ea  Rufus alignment
  e  W95 FAT16 (LBA) 53  OnTrack DM6 Aux a5  FreeBSD         eb  BeOS fs        
  f  W95 Ext'd (LBA) 54  OnTrackDM6      a6  OpenBSD         ee  GPT            
 10  OPUS            55  EZ-Drive        a7  NeXTSTEP        ef  EFI (FAT-12/16/
 11  Hidden FAT12    56  Golden Bow      a8  Darwin UFS      f0  Linux/PA-RISC b
 12  Compaq diagnost 5c  Priam Edisk     a9  NetBSD          f1  SpeedStor      
 14  Hidden FAT16 <3 61  SpeedStor       ab  Darwin boot     f4  SpeedStor      
 16  Hidden FAT16    63  GNU HURD or Sys af  HFS / HFS+      f2  DOS secondary  
 17  Hidden HPFS/NTF 64  Novell Netware  b7  BSDI fs         fb  VMware VMFS    
 18  AST SmartSleep  65  Novell Netware  b8  BSDI swap       fc  VMware VMKCORE 
 1b  Hidden W95 FAT3 70  DiskSecure Mult bb  Boot Wizard hid fd  Linux raid auto
 1c  Hidden W95 FAT3 75  PC/IX           bc  Acronis FAT32 L fe  LANstep        
 1e  Hidden W95 FAT1 80  Old Minix       be  Solaris boot    ff  BBT            
 Hex code (type L to list all codes): 8e
 Changed type of partition 'Linux' to 'Linux LVM'.

 Command (m for help): w
 The partition table has been altered.
 Calling ioctl() to re-read partition table.
 Syncing disks.
```

### Create a physical volume

The `pvcreate` command creates a physical volume for later use by the logical volume manager (LVM). In this example, the physical volume will be the new `/dev/sdb1` partition.

```bash
pvcreate /dev/sdb1
```

You will see output like this:

```bash
  Physical volume "/dev/sdb1" successfully created.
```

Now you should see a `Device` as well as a `Disk` in the output of `fdisk -l`.

### Extend the logical volume

Next, extend the existing logical volume to include the new device. First, confirm the name of the current volume group using the `vgdisplay` command:

```bash
vgdisplay
```

You will see output like this:

```bash
  --- Volume group ---
  VG Name               ubuntu-vg
  System ID             
  Format                lvm2
  Metadata Areas        3
  Metadata Sequence No  7
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                2
  Open LV               2
  Max PV                0
  Cur PV                3
  Act PV                3
  VG Size               <339.99 GiB
  PE Size               4.00 MiB
  Total PE              87037
  Alloc PE / Size       87037 / <339.99 GiB
  Free  PE / Size       0 / 0   
  VG UUID               hbeBYx-treH-UAUZ-0MZE-vBxN-FvFv-3zqHjx
```

Next, extend the volume group by adding in the physical volume `/dev/sdb1` which you created using the `pvcreate` command earlier. Pass the VG Name from the output above (in this example, `ubuntu-vg`) to the `vgextend` command:

```bash
vgextend ubuntu-vg /dev/sdb1
```

You will see output like this:

```bash
  Volume group "ubuntu-vg" successfully extended
```

Confirm these changes using the `pvscan` command to scan all disks for physical volumes. The output should confirm the original `/dev/sdb1` partition and the newly created physical volume `/dev/sdb1`:

```bash
pvscan
```

You will see output like this:

```bash
  PV /dev/sda1   VG ubuntu-vg          lvm2 [<40.00 GiB / 0    free]
  PV /dev/sdb1   VG ubuntu-vg          lvm2 [<200.00 GiB / 0    free]
  PV /dev/sdc1   VG ubuntu-vg          lvm2 [<100.00 GiB / 0    free]
  PV /dev/sdd1   VG ubuntu-vg          lvm2 [<100.00 GiB / <100.00 GiB free]
  Total: 4 [439.98 GiB] / in use: 4 [439.98 GiB] / in no VG: 0 [0   ]
```

Next, extend the logical volume (we already did the physical volume) which basically means we will be taking our original logical volume and extending it over our new partition/physical volume of `/dev/sdb1`.

Confirm the path of the logical volume using `lvdisplay` (YMMV)

```bash
lvdisplay
```

You will see output like this:

```bash
--- Logical volume ---
LV Path                /dev/ubuntu-vg/ubuntu-lv
LV Name                ubuntu-lv
VG Name                ubuntu-vg
LV UUID                A47cH0-Nktb-0fi3-4vdM-2N1K-uxBV-zq3G2Q
LV Write Access        read/write
LV Creation host, time ubuntu-server, 2023-11-09 12:53:44 +0000
LV Status              available
# open                 1
LV Size                <28.00 GiB
Current LE             7167
Segments               1
Allocation             inherit
Read ahead sectors     auto
- currently set to     256
Block device           253:0
```

Extend the logical volume using the `lvextend` command:

```bash
lvextend /dev/ubuntu-vg/ubuntu-lv /dev/sdb1
```

You will see output like this:

```bash
Size of logical volume ubuntu-vg/ubuntu-lv changed from <28.00 GiB (7167 extents) to 87.99 GiB (22526 extents).
Logical volume ubuntu-vg/ubuntu-lv successfully resized.
```

Finally, resize the overall `ext` based file system using the `resize2fs` command:

```bash
resize2fs /dev/ubuntu-vg/ubuntu-lv
```

You will see output like this:

```bash
resize2fs 1.46.5 (30-Dec-2021)
Filesystem at /dev/ubuntu-vg/ubuntu-lv is mounted on /; on-line resizing required
old_desc_blocks = 4, new_desc_blocks = 11
The filesystem on /dev/ubuntu-vg/ubuntu-lv is now 23066624 (4k) blocks long.
```

Confirm that the VM can now access the additional disk space using the `df` (disk free) command:

```bash
df -h
```

You will see output like this:

```bash
Filesystem                                 Size  Used Avail Use% Mounted on
udev                                        20G     0   20G   0% /dev
tmpfs                                      4.0G  904K  4.0G   1% /run
/dev/mapper/lib--vg-root                   432G  275G  140G  67% /
tmpfs                                       20G  264K   20G   1% /dev/shm
tmpfs                                      5.0M     0  5.0M   0% /run/lock
tmpfs                                       20G     0   20G   0% /sys/fs/cgroup
diglibdata1.princeton.edu:/ifs/solrbackup  1.5P  874T  549T  62% /mnt/solrbackup
//diglibdata1.princeton.edu/solrbackup     1.5P  893T  549T  62% /mnt/solr_backup
tmpfs                                      4.0G     0  4.0G   0% /run/user/1001
tmpfs                                      4.0G     0  4.0G   0% /run/user/1000
```

## Troubleshooting logical volume issues

If you find a machine where `df -h` does not show all available disk space, but the physical and logical volumes both exist, it's possible that a step got skipped. If you try `vgextend` and you get `Physical volume '/dev/sdb1' is already in volume group 'ubuntu-vg'`, and you try `lvextend` and get `WARNING: No free extents on physical volume "/dev/sdb1"`, then you can format any free space on the logical volume with `sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv`, after which you can do `sudo resize2fs /dev/ubuntu-vg/ubuntu-lv` and you should see the space available in `df -h`.
