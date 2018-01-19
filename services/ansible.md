# About Ansible

Ansible is configuration management tool and remote orchestration tool. It can get the managed endpoint to a desired state, but it can also run shell commands (avoid this and look for modules).

Ansible is broken down into three major parts. Inventory, Playbooks, and Roles. More information is available running `ansible-doc` command or checkout [the docs](http://docs.ansible.com/modules.html).

## Inventory

An inventory is a document that describes all of the hosts you want to manage, and how they are grouped. Take a look at our [master inventory](https://github.com/pulibrary/princeton_ansible/blob/master/hosts) to get a sense of the structure.

This allows us to manage individual groups or all boxes. This allows us to address each group of machines separately.

## Roles

From the ansible glossary, "Roles are units of organization in Ansible". This can be everything from an nginx role to make sure that nginx is setup and configured, to a role that will make sure a service gets deployed on a box and restarted.

## Playbooks

Playbook bind it all together. In a playbooks you assign a number of roles to an inventory group, or host. Most of the time you are running playbooks to actually make things happen.

## Vars

We organize vars roughly by

- Common vars
- Application (global)
- Environment
- Application (Per-Env)
- Role

So, if you need to define vars, try and think about them be organized that way.

# How we use Ansible
If you need to make a change to how ansible works, you commit changes to the [ansible](https://github.com/pulibrary/princeton_ansible) repo, and after a review it is merged for general use
