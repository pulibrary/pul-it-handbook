# About Ansible Tower

Ansible Tower (aka Controller) is a GUI-based service for running Ansible playbooks. It stores playbook output for asynchronous debugging, is accessible from outside the VPN, and connects to both Slack and GitHub to support cross-team communication.

## Authenticating to Ansible Tower

You can log into the [PUL Tower installation](https://ansible-tower.princeton.edu) with your Princeton credentials. The system should automatically route you to the SSO login screen and then, once you authenticate, to the main dashboard. If you do not see any data in the dashboard, contact the Library IT Operations team (in the #operations channel on Slack) for enhanced access.

The idle timeout is currently set to 6 hours. When you log out (or get logged out), you will see the non-SSO login screen: https://ansible-tower.princeton.edu/#/login.  For the 'admin' login instead of SSO, use this non-SSO login screen. To return to the SSO login screen, click on the avatar icon ('head and shoulders') at the bottom of the page.

## Ansible Tower Components

The main components of automation in Ansible Tower are:
  - an Organization
  - a Project (corresponding to a code repository)
  - an Inventory (corresponding to an inventory file or directory)
  - one or more Templates (each corresponding to a playbook)
  - one or more Credentials

### Organizations in PUL Tower

We only have one organization in Tower. It's called PUL. Every object we use in Tower MUST belong to the PUL organization.

The DevOps Organization contains all permissions for other Tower objects. Tower does not force you to select an Organization for every object (for example, you can create a template or inventory that does not belong to any organization). However, if you do not select the PUL Organization for your object, it will not be covered by the permissions of the Organization and no-one will be able to use it.

### Projects in PUL Tower

We only have one project in Tower. It's called Prancible and it is linked to the princeton_ansible repo on GitHub.

#### Updating the Prancible Project

The Prancible project automatically updates daily in the early morning hours, deleting the entire repository and cloning a fresh copy from GitHub. This automatic update is configured in Schedules.

If you are running a Template from a branch, Tower automatically pulls the latest commits on that branch before it executes. You can also update the project manually.

** You must sync the project manually to pull in any branch that has had a force-push to it.**

To update the Prancible project manually:
1. Select the Projects page
2. Click the 'Sync Project' button (a circular pair of arrows) on the right under 'Actions'. This starts a Source Control Update job.
3. Select Jobs from the left navigation and make sure the job succeeds.

### Inventories in PUL Tower

We only have one inventory in Tower. It's called Prancible Inventory and it is linked to the 'inventory' directory of the princeton_ansible repo on GitHub.

#### Updating the Prancible inventory

The Prancible inventory automatically updates daily in the early morning hours, after the Project update. When you add new machines or groups to the inventory directory on GitHub, you must first update the Prancible project, then separately update the Prancible inventory.

To update the Prancible inventory:
1. Make sure the Prancible project has already been updated.
2. Select Inventories from the left navigation.
3. Select the Prancible Inventory.
4. Select the Sources tab.
5. Click on the 'Start Sync Process' button (a circular pair of arrows) on the right under 'Actions'. This kicks off an Inventory Sync job.
6.  Select Jobs from the left navigation and make sure the job succeeds.

## Adding templates to Tower

You cannot build a template off a playbook until that playbook exists in the main branch. In other words, you cannot test a playbook in a Tower Template while it only exists in a PR or on a branch. If you want to test a playbook from Tower:
1. Merge a minimal version of the playbook into the main branch.
2. Update the Prancible project.
3. Update the Prancible inventory.
4. Create a Template based on the minimal playbook and set Source Control Branch to 'Prompt on launch'.
5. Create a new branch for changes to the playbook.
6. Launch the template and select the new branch to run with the latest changes to the branch.

All templates must include the Prancible Vault credential. Most templates also need the Tower's Own ed25519 credential. When you add credentials to a template, select the credential TYPE (Vault for the Vault cred, Machine for the SSH cred) first, then the specific credential. You can add more than one credential at once if you want to.

## Adding repos to the Deploy Rails template
To add a new code repository to the Deploy Rails template, log into ansible tower and [then update the survey](https://ansible-tower.princeton.edu/#/templates/job_template/13/survey)
  * Click on the `Edit Survey` pencil to the right of `What codebase do you want to deploy?`
  * Click into the last choice and hit `Enter` to add another choice
  * Add your choice to the list maintain alphabetical order.  You may have to move other choices down.
  * Entries are case-sensitive and must match the GitHub repository name exactly.
  * Click `Save`

## Execution environments (EEs) in Tower

Jobs in Tower run inside containers called execution environments, or EEs. In our old Tower environment, we ran everything on the default EE and installed the Ansible collections we needed into the EE at runtime. Now we can build custom EEs, building in the collections and other tools we need for each template ahead of time.

### Building a new EE

Our custom EEs are built from the YAML files in the ``tower_ees`` directory of the princeton_ansible repo. To build or rebuild an EE:

  * Log into an x86-architected machine (NOT a Mac laptop with an M-series chip) or have a solution for building x86-architected containers on your M-series Mac. If you build on an M-series chip without a solution, the resulting image will fail to load on Tower with the error ``image platform (linux/arm64) does not match the expected platform (linux/amd64)``.
  * Open the princeton_ansible repo and change into the tower_ees directory: ``cd tower_ees``
  * Create or Edit an EE definition file as needed: ``vim my-execution-environment.yml``
  * Run podman-desktop.
  * Run [ansible-builder](https://ansible.readthedocs.io/projects/builder/en/stable/index.html): ``ansible-builder build -v3 -f my-execution-environment.yml -t <TagOrNameOfEE> --squash all``
  * Note the hash of the built image in the output of the ansible-builder command.
  * Authenticate to quay.io. For easy authN, create a ~/.config/containers/auth.json file with the top level items ‘auths’ and an entry for each container registry you want to use. Each entry contains a key/value pair: the key is “auth” and the value is the output of “echo -n ‘username:password’ | openssl base64”. See [this PR](https://github.com/containers/image/pull/821/files) and [this superuser post](https://superuser.com/questions/120796/how-to-encode-base64-via-command-line) for more details. To authenticate from the command line: ``podman login quay.io``
  * Push the new image to quay.io: ``podman push <hash-of-image-ID> quay.io/pulibrary/<name-of-image>:<image-tag>``. This command also creates a new repository on quay.io if needed.
  * If the repository is new, log into quay.io and grant the pulibrary+ansibletower robot user `Read` permissions to it.
  * Create an EE in Tower, or update the existing EE to point to the new tag. For changes to existing EEs, test the Templates that use the EE. If anything fails, reset the EE to pull the previous tag.

## Managing the Ansible Tower VM/service:

Tower's GUI runs on 2 VMs: 'ansible-tower1' and 'ansible-tower2'.
The service is called 'automation-controller'.
The working directories are in '/var/lib/awx/'.
Tower jobs run on 2 additional VMs: 'ansible-exec1' and 'ansible-exec2'.

# How We Installed Tower 2.4

When we upgrade next time, we may not need to start from scratch, but this documentation records what we did when we upgraded to 2.4 from a much earlier version.

## Build the infrastructure

1. Create 4 RHEL9 VMs (two controller nodes, two exec nodes) in vSphere. When you install RHEL, make sure you do not install the GUI (installing the GUI is the default - if you make a mistake here, you can remove it by following https://www.redhat.com/sysadmin/removing-gui-rhel-8).
2. Register the new VMs with Red Hat (if you don’t pass the password, the command prompts you for it):
``sudo subscription-manager register --username <RH_username> --auto-attach``
3. Update packages with yum, accept the new keys, reboot.
4. Open firewall ports: 22 – SSH on all 4 boxes, 80/443 – HTTP/HTTPS on the two controller nodes, 27199/tcp – Automation Mesh traffic on the two exec nodes.
5. Create the database: Add the controller IPs to the pg_hba.conf for our Psql 13 server – in the end we allowed any IP from the libnet subnet. Then run the db migration playbook with a few temporary changes, so it loads the ansible-tower vars and only runs the create-db-user and create-db steps:
``ansible-playbook -e project_name=ansible_tower -e dest_host=lib-postgres-prod3.princeton.edu -e runtime_env=production --tags never playbooks/postgresql_db_migration.yml --limit lib-postgres-prod3.princeton.edu``
6. Prepare for the actual installation: The 2.4 installer came from https://access.redhat.com/downloads/content/480/ver=2.4/rhel---9/2.4/x86_64/product-software. Download 'Setup' installer onto your laptop or some other ‘third-party’ machine. You cannot run the installer from a Tower VM, because if the playbook uses ``hosts: localhost``, it fails to run against the other hosts in your inventory file, and the VMs do not have SSH access to themselves.
7. Edit the inventory file: In the inventory file, enter credentials and infrastructure information. Be sure to set Tower to look for execution environments at registry.redhat.io with service credentials, so it can find the default EE. By changing the inventory file to include this information, you put it into Tower config. It feels like you should be able to put a Credential within Tower for this after the installation is complete, but that doesn’t work - it has to be set in config. Also, enter the Tower Admin user’s password.
8. Run the installer: You must run the install script with become:
``ANSIBLE_BECOME=True ./setup.sh``
When the playbook finishes, the Tower UI should come up at ansible-tower.princeton.edu, and you can log in as ‘admin’ with the admin password.
9. Configure SSO: Log in as the Admin user and edit the Settings . . . SAML Settings page.
