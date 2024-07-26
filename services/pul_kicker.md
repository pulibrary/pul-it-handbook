## How to Reboot a VM (File System Locks)

Occasionally servers will be locked down and we will need to kick them with a hard reboot. 

In the dev/staging environment, we can reboot VMs from [this template](https://ansible-tower.princeton.edu/#/templates/job_template/47/details) in Tower. 

In the production environment, we must log into vSphere, following these steps:

* Open a VPN connection
* Using your preferred RDP Client ([Microsoft ships a good one](https://docs.microsoft.com/en-us/windows-server/remote/remote-desktop-services/clients/remote-desktop-mac)) connect to `lib-staff998` and authenticate using your Active Directory netid and password
* On the resulting Desktop is a shortcut to the VMWare VCenter Application - Credentials are on lastpass - (search for VSphereKickerAccount)
  * Clicking on this link will lead you to a [URL only accessible from this VM](https://lib-vmctr.princeton.edu) that says `This site is not secure` (accept the risk)
* Search for the VM you are trying to fix, then restart it or otherwise correct the mistake
  * To restart a VM `Select Actions` --> `Power Off`
  * Then wait for the VM to power off. Then Select `Power On`
* Log out of `lib-staff998` - this is a shared machine so this step is also important.
