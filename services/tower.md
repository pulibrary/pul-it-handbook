# About Ansible Tower

Ansible Tower (aka Controller) is a GUI-based service for running Ansible playbooks. It stores playbook output for asynchronous debugging, is accessible from outside the VPN, and connects to both Slack and GitHub to support cross-team communication.

## Authenticating to Ansible Tower

You can log into the [PUL Tower installation](https://ansible-tower.princeton.edu) with your Princeton credentials. The system should automatically route you to the SSO login screen and then, once you authenticate, to the main dashboard. If you do not see any data in the dashboard, contact the Library IT Operations team (in the #operations channel on Slack) for enhanced access.

The idle timeout is currently set to 6 hours. When you log out (or get logged out), you will see the non-SSO login screen: <https://ansible-tower.princeton.edu/#/login>.  For the 'admin' login instead of SSO, use this non-SSO login screen. To return to the SSO login screen, click on the avatar icon ('head and shoulders') at the bottom of the page.

## Ansible Tower Components

The main components of automation in Ansible Tower are:

* an Organization
* a Project (corresponding to a code repository)
* an Inventory (corresponding to an inventory file or directory)
* one or more Templates (each corresponding to a playbook)
* one or more Credentials

### Organizations in PUL Tower

We only have one organization in Tower. It's called PUL. Every object we use in Tower MUST belong to the PUL organization.

The DevOps Organization contains all permissions for other Tower objects. Tower does not force you to select an Organization for every object (for example, you can create a template or inventory that does not belong to any organization). However, if you do not select the PUL Organization for your object, it will not be covered by the permissions of the Organization and no-one will be able to use it.

### Projects in PUL Tower

We only have one project in Tower. It's called Prancible and it is linked to the princeton_ansible repo on GitHub.

#### Updating the Prancible Project

The Prancible project automatically updates daily in the early morning hours, deleting the entire repository and cloning a fresh copy from GitHub. This automatic update is configured in Schedules.

If you are running a Template from a branch, Tower automatically pulls the latest commits on that branch before it executes. You can also update the project manually.

**You must sync the project manually to pull in any branch that has had a force-push to it.**

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
6. Select Jobs from the left navigation and make sure the job succeeds.

## Adding templates to Tower

If the playbook you want to run in Tower already exists in the princeton_ansible repository, you can easily create a template for it.

If you are working on a new playbook, and you want to test it in Tower, skip down to the section on `Creating a template for a new playbook`.

### Creating a template for an existing playbook

If your playbook already exists in the princeton_ansible repo, you can copy an existing template in Tower, then edit it to do what you need. Copying gives you the correct Inventory, Project, Execution Environment, and likely also the credentials you need.

1. In the Templates view, next to the template you want to copy, select `Copy template` on the far right (a pair of pages). Your copy will show up just below the existing record, with a timestamp to differentiate it from the original template.
2. Edit your copied template by selecting `Edit Template`.
3. Change at least these attributes:

  a. name
  b. description
  c. playbook

4. If you want to allow the user to provide standard Ansible parameters (for example, `Limit` or `Source Control Branch` or `Verbosity`), select the `Prompt on launch` box above those entries.
5. Click `Save` to save your changes.

#### Adding or changing credentials

All templates must include the Prancible Vault credential, which supports decrypting vaulted variables at runtime. Most templates also need the Tower's Own ed25519 credential, which allows SSH access to our VMs. If you did not copy an existing template, you need to add the basic credentials. Depending on what your playbook does, it may need other credentials as well.

To add or change credentials:

1. Edit the Template.
2. In the `Credentials` section, delete any existing credentials you do not want or need.
3. To add credentials, click on the magnifying glass. By default you will see `Machine` credentials (usually Tower's Own ed25519).
4. Select the credential TYPE (Vault for the Vault cred, Machine for the SSH cred, etc.),then select the specific credential.
5. Repeat until you have all the credentials you want or need, then click on `Select` to add them all.

The `Edit Details` screen shows you all the Credentials that are associated with the template. If they are correct, click on `Save` to save your changes to the template.

#### Adding or changing surveys

If you want to pass variable values at runtime (for example, `runtime_env`), add one or more Surveys to your Template. If your new template is a copy of an existing template, it will include the surveys from the original template.

To add or change surveys:

1. If you have been editing your template, save your changes. Otherwise, click on the name of the template you want to add surveys to.
2. Switch from the `Details` tab to the `Survey` tab.
3. If you are changing a survey (for example, in a template you created by copying), click on any survey to edit it.
4. If you are adding one or more surveys to a new template (or if the template you copied had no surveys), click on `Add`.
5. Fill in the fields. The `Question` is what the user will see in Tower when running the template. The `Answer variable name` must match a variable in the playbook itself. Choose the type of answer, whether the question is required, whether there is a default value. When everything is ready, click on `Save`.
6. Repeat for every variable value you want users to provide at runtime.
7. Once your surveys are all configured, make sure the `Survey Enabled` button is turned on.

### Adding schedules

If you want to run the template on a regular cadence, automatically, add a Schedule to your template. A scheduled job runs the selected template with defined variables at a defined, recurring time. Each template can have multiple Schedules.

Note: Please set scheduled jobs to run in the evening or overnight so they do not interfere with morning maintenance or with urgent activity (for example, deploying a bugfix) on Tower during regular working hours. You can see a list of existing scheduled jobs ordered by start time by selecting `Schedules` from the main left nav.

To add a schedule:

1. If you have been editing your template, save your changes. Otherwise, click on the name of the template you want to add surveys to.
2. Switch from the `Details` tab to the `Schedules` tab.
3. Click `Add` and fill in the parameters.

  a. Provide a descriptive name - for example "Thursday TigerData production build" or "Daily catalog staging deployment".
  b. If your template has Surveys or Prompt on Launch options, the Schedule will pick up default values for those. If you want to use non-default values, click on `Prompt` and fill in the values you want for the particular recurring job.

#### Adding notifications

If you want a slack message when the template starts to run, succeeds, or fails, add one or more notifications to your template. Notifications can only be created globally, but each one can be turned on or off for each template in Tower.

To enable an existing notification:

1. If you have been editing your template, save your changes. Otherwise, click on the name of the template you want to add surveys to.
2. Switch from the `Details` tab to the `Notifications` tab.
3. Turn on the conditions you want for your notification.
4. To create a new notification type, select `Notifications` in the main left nav (in the Administration section). Note that all templates have access to all notification types.

### Creating a template for a new playbook

You cannot build a template off a playbook until that playbook exists in the main branch. In other words, you cannot test a playbook in a Tower Template while it only exists in a PR or on a branch. If you want to test a playbook from Tower:

1. Merge a minimal version of the playbook into the main branch.
2. Update the Prancible project.
3. Update the Prancible inventory.
4. Create a Template based on the minimal playbook and set Source Control Branch to 'Prompt on launch'.
5. Create a new branch for changes to the playbook.
6. Launch the template and select the new branch to run with the latest changes to the branch.

## Adding repos to the Deploy Rails template

To add a new code repository to the Deploy Rails template, log into ansible tower and [then update the survey](https://ansible-tower.princeton.edu/#/templates/job_template/13/survey)

* Click on the `Edit Survey` pencil to the right of `What codebase do you want to deploy?`
* Click into the last choice and hit `Enter` to add another choice
* Add your choice to the list maintain alphabetical order.  You may have to move other choices down.
* Be careful to avoid adding trailing whitespace as you edit!
* Entries are case-sensitive and must match the GitHub repository name exactly.
* Click `Save`

## Automate continuous deployment

1. First add the `Tower Continuous Deployment Token` from lastpass into your circleci project settings as an environment variable.
1. Go to [Continuous Delivery Deployment](https://ansible-tower.princeton.edu/#/templates/job_template/57/details)
1. Select `Survey`
1. Click on the `Edit Survey` pencil to the right of `What codebase do you want to deploy?`
1. Click on the last entry and press `enter` to add a new entry.
1. Add your choice to the list maintain alphabetical order.  You may have to move other choices down.
1. Be careful to avoid adding trailing whitespace as you edit!
1. Entries are case-sensitive and must match the GitHub repository name exactly.
1. Click `Save`
1. Go to [ansible tower templates](https://ansible-tower.princeton.edu/#/templates)

### Template exists

1. Go to [Continuous Delivery Deployment](https://ansible-tower.princeton.edu/#/templates/job_template/57/details)
2. Select tab `Schedules`
3. Click on `Add` to schedule a new job for this template.
4. Provide a `Name` and a `Description` and select the `Start date/time`.
5. Click on `Prompt` and select the desired environment staging, production or qa.
6. Select `What codebase do you want to deploy?` and select the application.
7. Click `Next`
8. Click `Save`
9. Select `Repeat frequency`. Example: Select `Day` to run the job daily.
10. If needed, update section `Frequency Details`.
11. If needed, update section `Exceptions`. Example: Select `Add exceptions` and select option `Week`. This will display a new section to select the days of the week you don't want the job to run. If you don't want the job to run on the weekend, select `Sun` and `Sat`.
12. Click `Save`

### Template does not exist

* Following the steps in `Adding templates to Tower` Create a template for the application and follow the above steps in `Template exists`.

## Execution environments (EEs) in Tower

[Moved to Prancible](https://github.com/pulibrary/princeton_ansible/blob/f23e0025d42819c484a51f8fc99bae6d1ce97ffb/tower_ees/README.md)

## Managing the Ansible Tower VM/service

Tower's GUI runs on 2 VMs: 'ansible-tower1' and 'ansible-tower2'.
The service is called 'automation-controller'.
The working directories are in '/var/lib/awx/'.
Tower jobs run on 2 additional VMs: 'ansible-exec1' and 'ansible-exec2'.

## How We Installed Tower 2.4

When we upgrade next time, we may not need to start from scratch, but this documentation records what we did when we upgraded to 2.4 from a much earlier version.

## Build the infrastructure

1. Create 4 RHEL9 VMs (two controller nodes, two exec nodes) in vSphere. When you install RHEL, make sure you do not install the GUI (installing the GUI is the default - if you make a mistake here, you can remove it by following <https://www.redhat.com/sysadmin/removing-gui-rhel-8>).
2. Register the new VMs with Red Hat (if you don’t pass the password, the command prompts you for it):
``sudo subscription-manager register --username <RH_username> --auto-attach``
3. Update packages with yum, accept the new keys, reboot.
4. Open firewall ports: 22 – SSH on all 4 boxes, 80/443 – HTTP/HTTPS on the two controller nodes, 27199/tcp – Automation Mesh traffic on the two exec nodes.
5. Create the database: Add the controller IPs to the pg_hba.conf for our Psql 13 server – in the end we allowed any IP from the libnet subnet. Then run the db migration playbook with a few temporary changes, so it loads the ansible-tower vars and only runs the create-db-user and create-db steps:
``ansible-playbook -e project_name=ansible_tower -e dest_host=lib-postgres-prod3.princeton.edu -e runtime_env=production --tags never playbooks/postgresql_db_migration.yml --limit lib-postgres-prod3.princeton.edu``
6. Prepare for the actual installation: The 2.4 installer came from <https://access.redhat.com/downloads/content/480/ver=2.4/rhel---9/2.4/x86_64/product-software>. Download 'Setup' installer onto your laptop or some other ‘third-party’ machine. You cannot run the installer from a Tower VM, because if the playbook uses ``hosts: localhost``, it fails to run against the other hosts in your inventory file, and the VMs do not have SSH access to themselves.
7. Edit the inventory file: In the inventory file, enter credentials and infrastructure information. Be sure to set Tower to look for execution environments at registry.redhat.io with service credentials, so it can find the default EE. By changing the inventory file to include this information, you put it into Tower config. It feels like you should be able to put a Credential within Tower for this after the installation is complete, but that doesn’t work - it has to be set in config. Also, enter the Tower Admin user’s password.
8. Run the installer: You must run the install script with become:
``ANSIBLE_BECOME=True ./setup.sh``
When the playbook finishes, the Tower UI should come up at ansible-tower.princeton.edu, and you can log in as ‘admin’ with the admin password.
9. Configure SSO: Log in as the Admin user and edit the Settings . . . SAML Settings page.

## Troubleshooting

Ansible Tower writes logs at `/var/log/tower/tower.log`
