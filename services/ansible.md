# About Ansible

Ansible is a configuration management and remote orchestration tool. It can get the managed endpoint to a desired state, but it can also run shell commands (avoid this and look for modules).

Command-line Ansible is broken down into three major parts. Inventory, Playbooks, and Roles. Our Ansible inventory, playbooks, roles, and conventions live in our [princeton_ansible repository](https://github.com/pulibrary/princeton_ansible).

You can run an Ansible playbook at the command line or in the PUL installation of [Ansible Tower](https://ansible-tower.princeton.edu). For more details on working in our Ansible Tower instance, see [our Tower documentation](./tower.md).

## Inventory

Inventory describes all of the hosts you want to manage, and how they are grouped. Take a look at our [master inventory directory](https://github.com/pulibrary/princeton_ansible/blob/master/inventory) to get a sense of the structure we use.

Using inventory, groups, and other patterns, we can manage anything from an individual box to a group of machines related to a single project to all machines in an environment (staging, production).

## Roles

From the ansible glossary, "Roles are units of organization in Ansible". This can be everything from an nginx role to make sure that nginx is setup and configured, to a role that will make sure a service gets deployed on a box and restarted.

## Playbooks

Playbooks bind it all together. A playbook defines the tasks and/or roles to run and the host or group to run against. Most of the time you are running playbooks to actually make things happen.

## Vars

Variables define the values that change from one machine to another (for example, hostnames, ports, or versions. Our ansible repository organizes vars roughly by

- Common vars
- Application (global)
- Environment
- Application (Per-Env)
- Role

## Vault

Some of our vars are stored in files encrypted via ansible vault. The vault password is stored in a shared lastpass location and instructions for its use are on the princeton_ansible readme.

Process to rekey the vault password:
- copy the old key into the old vault passwords note in lastpass
- generate a new key, you can use the lastpass generator
- save the new key in lastpass shared dir
- Find all the files that need to be rekeyed by grepping for the header that ansible puts at the top of each encrypted file `$ANSIBLE_VAULT;1.1;AES256`
- rekey the files using `ansible-vault rekey`, passing the list of files
- update Tower with the new key
- let everyone know on the #infrastructure channel

# How we use Ansible
If you need to make a change to how ansible works, you commit changes to the [ansible](https://github.com/pulibrary/princeton_ansible) repo, and after a review it is merged for general use.
