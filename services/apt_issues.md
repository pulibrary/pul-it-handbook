# About Apt

A lot of the software we use on our machines is installed using the Advanced Packaging Tool or Apt, the OS package manager Ubuntu uses. Apt maintains a list of repositories (servers that host packages), available packages, and package versions. The local version of this list is `/etc/apt/sources.list`, and updated with the command `apt-get update` (in Ansible, this happens when an apt-related task sets `update_cache: true`). You generally want to update the sources list before you upgrade packages, so you can install the latest versions available. However, updating the `apt` sources list / cache fails fairly often, for a variety of reasons.

## Common Apt errors and their fixes

### Apt public key failures

Expired or changed public keys often cause `apt` updates to fail. Apt packages are verified using signing keys. These keys sometimes expire, move, or otherwise become unavailable.

If you run `apt-get update` on a machine with a useless key, you will see an error message. In Ansible the error is `Failed to update apt cache: unknown reason`. If you SSH to the machine and run `sudo apt-get update`, the full error message includes this warning: `The following signatures couldn't be verified because the public key is not available: NO_PUBKEY <key-hash>`. For example: `The following signatures couldn't be verified because the public key is not available: NO_PUBKEY 7FCC7D46ACCC4CF8`.  

### Fixing apt public key failures

To update the key and upgrade apt packages:
1. run `playbooks/fix_apt_issues.yml` on the affected machines, passing `-e recv_key=<key-hash>`
2. run `playbooks/os_updates.yml` (in Tower the Template is called Patch Tuesday) on the affected machines to confirm the fix, update the cache, and upgrade all packages

### Apt repository failures

An apt repository that moves or disappears can also cause `apt` updates to fail.

If you run `apt-get update` on a machine with a outdated repository in the sources list, you will see an error message. In Ansible the error is `The repository <repo-url-and-details> no longer has a Release file."`.

### Fixing apt repository failures

To remove an apt repository from the sources list:
1. run `playbooks/fix_apt_issues.yml` on the affected machines, passing `-e useless_apt_repo='<repo-details>'` (include the full repository definition, for example 'deb https://oss-binaries.phusionpassenger.com/apt/passenger bionic main')
2. run `playbooks/os_updates.yml` (in Tower the Template is called Patch Tuesday) on the affected machines to confirm the fix, update the cache, and upgrade all packages
