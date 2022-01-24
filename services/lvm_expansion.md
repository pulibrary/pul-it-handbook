### Identifying partition

confirm the partition type with

```bash
pulsys@issuetracker-prod1:~$ sudo fdisk -l
Disk /dev/sda: 40 GiB, 42949672960 bytes, 83886080 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x6c13532e

Device     Boot Start      End  Sectors Size Id Type
/dev/sda1  *     2048 83884031 83881984  40G 8e Linux LVM

Disk /dev/mapper/lib--vg-root: 39.4 GiB, 41917874176 bytes, 81870848 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

Disk /dev/mapper/lib--vg-swap_1: 980 MiB, 1027604480 bytes, 2007040 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
```

As you can see from the output /dev/sda1 is listed as "Linux LVM" and it has the ID of 8e. The 8e hex code shows that it is a Linux LVM. Now that we have confirmed we are working with an LVM we can continue.

**This document does not include how to expand the disk size on VMWare.** Once you have completed this step proceed below.

### Detect the new disk

Once the physical disk has been increased at the hardware level, we need to get into the operating system and create a new partition that makes use of this space to proceed.

Before we can do this we need to check that the new unallocated disk space is detected by the server, you can re-run `fdisk -l` to list all the disks. You will most likely see that the disk space is still showing as the same original size, we will rescan our devices to avoid rebooting by running the command below as root. Note you may need to change host1 depending on your setup.

```bash
echo "- - -" > /sys/class/scsi_host/host1/scan
```

### Partition the new disk

When you run `fdisk -l` after the command above you will notice a new partition. We will stick with our original result above. You will now notice a new partition `/dev/sdb` (YMMV).

Run

```bash
fdisk /dev/sdb
```

`fdisk` will be used to create a new partition, with the inputs shown below in bold. Note that you can press ‘m’ to get a full listing of the fdisk commands.

select *'n'* for a new partition.

```bash
WARNING: DOS-compatible mode is deprecated. It's strongly recommended to
 switch off the mode (command 'c') and change display units to
 sectors (command 'u').

Command (m for help): *n*
```

select *'p'* for a primary partition.

```bash
Command action
   l   logical (5 or over)
   p   primary partition (1-4)
*p*
```

Select the *(default)* for the next partition number (YMMV)

Press enter twice above as by default the first and last cylinders of the unallocated space should be correct. (YMMV)

Enter '8e' for a Linux LVM which is what we want this partition to be, as we will be joining it with the original /dev/sda1 Linux LVM.

Select `w` and it should write the new partition table and get you out of this shell.

### Increase the logical volume

The `pvcreate` command which creates a physical volume for later use by the logical volume manager (LVM). In this case the physical volume will be our new /dev/sdb1 partition.

```bash
root@issuetracker-prod1:~$:~# pvcreate /dev/sdb1
  Physical volume "/dev/sdb1" successfully created
```

In order to confirm the name of the current volume group we use the `vgdisplay` command. `vgdisplay` provides information close to this below.

```bash
root@issuetracker-prod1:/home/pulsys# vgdisplay
  --- Volume group ---
  VG Name               lib-vg
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  3
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                2
  Open LV               2
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <40.00 GiB
  PE Size               4.00 MiB
  Total PE              10239
  Alloc PE / Size       10239 / <40.00 GiB
  Free  PE / Size       0 / 0
  VG UUID               hbeBYx-treH-UAUZ-0MZE-vBxN-FvFv-3zqHjx
  ```

  Now we extend the 'lib-vg' volume group above by adding in the physical volume of /dev/sdb1 which we created using the `pvcreate` command earlier.

```bash
root@issuetracker-prod1:/home/pulsys# vgextend lib-vg /dev/sdb1
  Volume group "lib-vg" successfully extended
```

Using the `pvscan` command we scan all disks for physical volumes, this should confirm the original /dev/sdb1 partition and the newly created physical volume /dev/sdb1

```bash
root@issuetracker-prod1:/home/pulsys# pvscan
  PV /dev/sda1   VG lib-vg          lvm2 [<40.00 GiB / 0    free]
  PV /dev/sdb1   VG lib-vg          lvm2 [<40.00 GiB / 0    free]
  Total: 2 [<80.00 GiB] / in use: 2 [<80.00 GiB] / in no VG: 0 [0   ]
  ...
```

Next we need to increase the logical volume (we already did the physical volume) which basically means we will be taking our original logical volume and extending it over our new partition/physical volume of /dev/sdb1.

Firstly confirm the path of the logical volume using `lvdisplay` (YMMV)

```bash
root@figgy1:~# lvdisplay
  --- Logical volume ---
  LV Path                /dev/lib-vg/root
  LV Name                root
  VG Name                lib-vg
  LV UUID                kccyDY-a9GB-VoV4-MwUi-SHcO-ScwJ-eVIrPR
  LV Write Access        read/write
  LV Creation host, time lib, 2018-11-19 16:58:25 +0000
  LV Status              available
  # open                 1
  LV Size                <99.04 GiB
  Current LE             25353
  Segments               2
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0

  --- Logical volume ---
  LV Path                /dev/lib-vg/swap_1
  LV Name                swap_1
  VG Name                lib-vg
  LV UUID                c8RAPC-TCbR-lQff-tPIN-DxZN-XQZa-Nn4fgv
  LV Write Access        read/write
  LV Creation host, time lib, 2018-11-19 16:58:25 +0000
  LV Status              available
  # open                 2
  LV Size                980.00 MiB
  Current LE             245
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:1
```

The logical volume is then extended using the `lvextend` command.

```bash
root@figgy1:~# lvextend /dev/lib-vg/root /dev/sdb1
Extending logical volume root to 39.90 GiB
  Logical volume root successfully resized
```

The final step is to resize the file system which is is done using the `resize2fs` command for ext based file systems.

```bash
root@figgy1:~# resize2fs /dev/lib-vg/root
Filesystem at /dev/lib-vg/root is mounted on /; on-line resizing required
old desc_blocks = 2, new_desc_blocks = 2
Performing an on-line resize of /dev/lib-vg/root to 7576576 (4k) blocks.
The filesystem on /dev/lib-vg/root is now 7576576 blocks long.
```

