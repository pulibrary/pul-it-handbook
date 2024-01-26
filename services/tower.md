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

We only have one organization in Tower. It's called DevOps. Every object we use in Tower MUST belong to the DevOps organization.

The DevOps Organization contains all permissions for other Tower objects. Tower does not force you to select an Organization for every object (for example, you can create a template or inventory that does not belong to any organization). However, if you do not select the DevOps Organization for your object, it will not be covered by the permissions of the Organization and no-one will be able to use it.

### Projects in PUL Tower

We only have one project in Tower. It's called Princeton Ansible Project and it is linked to the princeton_ansible repo on GitHub.

#### Updating the Princeton Ansible Project

The Princeton Ansible project automatically updates daily in the early morning hours, deleting the entire repository and cloning a fresh copy from GitHub. This automatic update is configured in Schedules.

If you are running a Template from a branch, Tower automatically pulls the latest commits on that branch before it executes. You can also update the project manually.

** You must sync the project manually to pull in any branch that has had a force-push to it.**

To update the Princeton Ansible project manually:
1. Select the Projects page
2. Click the 'Sync Project' button (a circular pair of arrows) on the right under 'Actions'. This starts a Source Control Update job.
3. Select Jobs from the left navigation and make sure the job succeeds.

### Inventories in PUL Tower

We only have one inventory in Tower. It's called Princeton Ansible Inventory and it is linked to the 'inventory' directory of the princeton_ansible repo on GitHub.

#### Updating the Princeton Ansible inventory

The Princeton Ansible inventory does not automatically update. When you add new machines or groups to the inventory directory on GitHub, you must first update the Princeton Ansible project, then separately update the Princeton Ansible inventory.

To update the Princeton Ansible inventory:
1. Make sure the Princeton Ansible project has already been updated.
2. Select Inventories from the left navigation.
3. Select the Princeton Ansible Inventory.
4. Select the Sources tab.
5. Click on the 'Start Sync Process' button (a circular pair of arrows) on the right under 'Actions'. This kicks off an Inventory Sync job.
6.  Select Jobs from the left navigation and make sure the job succeeds.

## Adding templates to tower

You cannot build a template off a playbook until that playbook exists in the main branch. In other words, you cannot test a playbook in a Tower Template while it only exists in a PR or on a branch. If you want to test a playbook from Tower:
1. Merge a minimal version of the playbook into the main branch.
2. Update the Princeton Ansible project.
3. Update the Princeton Ansible inventory.
4. Create a Template based on the minimal playbook and set Source Control Branch to 'Prompt on launch'.
5. Create a new branch for changes to the playbook.
6. Launch the template and select the new branch to run with the latest changes to the branch.

All templates must include the Princeton Ansible Vault credential. Most templates also need the VM SSH Connections credential. When you add credentials to a template, you must add them one at a time. Select the credential TYPE (Vault for the Vault cred, Machine for the SSH cred) first, then the specific credential.

## Managing the Ansible Tower VM/service:

The VM for Tower is 'ansible-tower1'.
The service is called 'automation-controller'.
The working directories are in '/var/lib/awx/'.

## Deploy Rails Template
  To add a project to the deploy rails project login into ansible tower and [then update the survey](https://ansible-tower.princeton.edu/#/templates/job_template/13/survey)
  * Click on the `Edit Survey` pencil to the right of `What codebase do you want to deploy?`
  * Click into the last choice and hit `Enter` to add another choice
  * Add you choice to the list maintain alphabetical order.  You may have to move other choices down
  * Click `Save`
