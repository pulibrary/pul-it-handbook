## Create A Service Account

You can find complete documentation [on creating a service account](https://cloud.google.com/iam/docs/service-accounts-create#console). 

  1.  In the Google Cloud Console [Go to Create service account](https://console.cloud.google.com/projectselector/iam-admin/serviceaccounts/create?walkthrough_id=iam--create-service-account&_ga=2.13125367.1703540495.1707229976-289047190.1707229976#step_index=1) page
  1. Select the *pul-gcdc* project if you have access to more than one
  1. Enter a service account name to display in the Google Cloud console. The Google Cloud console generates a service account ID based on this name. Edit the ID if necessary. You cannot change the ID later.
  1. Enter a description of the service account
  1. Choose one or more [IAM roles](https://cloud.google.com/iam/docs/understanding-roles) to grant to the service account on the project.
  1. When you are done adding roles, click *Continue*.
  1. Click *Done* to finish creating the service account.

### Create service account keys

You can find complete documentation [on creating and deleting service account keys](https://cloud.google.com/iam/docs/keys-create-delete)

You will almost certainly want to create keys for this account. Use the following steps

  1. In the Google Cloud console, [Go to Service accounts](https://console.cloud.google.com/iam-admin/serviceaccounts?walkthrough_id=iam--create-service-account-keys&start_index=1&_ga=2.88213339.1703540495.1707229976-289047190.1707229976#step_index=1)
  2. Select the *pul-gcdc* project if you have access to more than one
  3. Click the email address of the service account that you want to create a key for.
  4. Click the *Keys* tab.
  5. Click the *Add key* drop-down menu, then select *Create new key.*
  6. Select *JSON* as the *Key type* and click *Create.*
  8. Add this Lastpass and/or Princeton Ansible’s vault

Clicking *Create* downloads a service account key file. After you download the key file, you cannot download it again.