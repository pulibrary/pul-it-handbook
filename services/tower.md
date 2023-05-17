# About Ansible Tower

Ansible Tower is a GUI-based service for running Ansible playbooks. It stores playbook output for asynchronous debugging, is accessible from outside the VPN, and connects to both Slack and GitHub to support cross-team communication.

## Authenticating to Ansible Tower

You can log into the [PUL Tower installation](https://ansible-tower.princeton.edu) with your Princeton credentials. The system should automatically route you to the SSO login screen and then, once you authenticate, to the main dashboard. If you do not see any data in the dashboard, contact the Library IT Operations team (in the #operations channel on Slack) for enhanced access.

The idle timeout is currently set to 6 hours. When you log out (or get logged out), you will see the non-SSO login screen: https://ansible-tower.princeton.edu/#/login.  For the 'admin' login instead of SSO, use this non-SSO login screen. To return to the SSO login screen, click on the avatar icon ('head and shoulders') at the bottom of the page.

## Ansible Tower Components

To run automation in Ansible Tower you need:
  - an Organization
  - a Project (corresponding to a code repository)
  - an Inventory (corresponding to an inventory file or directory)
  - a Template (corresponding to a playbook)
  - one or more Credentials

### Organizations in PUL Tower

We only have one organization in Tower. It's called Default. Every object we use in Tower MUST belong to the Default organization.

The Organization contains all permissions for other Tower objects. Tower does not force you to select an Organization for every object (for example, Templates or Inventories) but if you do not select the Default Organization for your object, it will not be covered by the permissions of the Organization and no-one will be able to use it.

### Projects in PUL Tower

We only have one project in Tower. It's called Princeton Ansible and it is linked to the princeton_ansible repo on GitHub.

The Princeton Ansible project automatically updates daily overnight, deleting the entire repository and cloning a fresh copy from GitHub. If you are running a Template from a branch, Tower automatically pulls the latest commits on that branch before it executes. You can also update the project manually by going to the Projects page and clicking the 'Sync Project' buttons (a circular pair of arrows) to the right of the Princeton Ansible project listing. This starts a Source Control Update job. You must sync the project if you need to pull in a branch with a force-push on it.

### Inventories in PUL Tower

We only have one inventory in Tower. It's called Princeton Ansible and it is 

## Managing the Ansible Tower service:

The VM for Tower is 'ansible-tower1'.
The service is called 'automation-controller'.
The working directories are in '/var/lib/awx/'.

## Adding templates to tower

When adding an inventory, you can set the “Source” to be a directory, but Tower really tries to make you select a file from the drop-down. I had to hand-enter the path, followed by a space, then click on “Set the source to <path/you/entered>”.
To allow jobs to use any branch:
1.	In the Project config:
a.	Check “Allow branch override”
2.	In the Job Template config:
a.	set “Prompt on launch” for the Source Control Branch
b.	you can enter a branch name as well – if you do, it becomes the default branch for the template, and the “prompt” gives users the ability to override it


You cannot build a template off a playbook until that playbook exists in the main branch – in other words, you can’t test a playbook AS A template while it’s in a PR.

All templates should include the Vault credential. Remember that you have to select the credential TYPE first, then the specific credential.
