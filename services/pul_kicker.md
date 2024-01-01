## File System Locks

Occasionally servers will be locked down and we will need to kick them with a hard reboot. 

The following steps will need a VPN connection

* Using your preferred RDP Client ([Microsoft ships a good one](https://docs.microsoft.com/en-us/windows-server/remote/remote-desktop-services/clients/remote-desktop-mac)) connect to `lib-staff998` - You will be prompted for you Active Directory netid and password.
* On the resulting Desktop is a shortcut to the VMWare VCenter Application - Credentials are on lastpass - (search for VSphereKickerAccount)
  * Clicking on this link will lead you to a [URL only accessible from this VM](https://lib-vmctr.princeton.edu) that says `This site is not secure` (accept the risk)
* You will need to search for the VM you are trying to fix. Find the VM and restart or otherwise correct the mistake.
  * To restart a VM `Select Actions` --> `Power Off`
  * Then wait for the VM to power off. Then Select `Power On`
* Logout - this is a shared machine so this step is also important.

