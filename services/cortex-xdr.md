# Cortex XDR notes

As of December 2025 we are adopting Cortex XDR (a Palo Alto product) on our virtual servers as part of our security suite in accordance with OIT requirements. Here is what we know about Cortex XDR:

* We install the Cortex XDR agent using [the security](https://github.com/pulibrary/princeton_ansible/blob/main/playbooks/utils/security_theater.yml) playbook.
*	The tool does not run as a service. There is no service name. You cannot use `sudo systemctl <command> <name>` or `sudo service <name> <command>` to manage it.
* To manage the tool, use `cytool` commands - see [the documentation](https://docs-cortex.paloaltonetworks.com/r/Cortex-XDR/8.9/Cortex-XDR-Agent-Administrator-Guide/Cytool-for-Linux) for a full list. The path to `cytool` is `/opt/traps/bin/cytool` and it requires `sudo`.
* Useful commands:
  * `sudo /opt/traps/bin/cytool connectivity_test` checks the connection
  * `sudo /opt/traps/bin/cytool runtime start all` starts the processes
  * `sudo /opt/traps/bin/cytool status` returns general status info, including the agent version
  * `sudo /opt/traps/bin/cytool health` checks the health of the agent
  * `sudo /opt/traps/bin/cytool reconnect [force <distribution_id>]` reconnects to Palo Alto
* Configuration is managed by `/etc/panw/cortex.conf`, which:
  * cannot have any comments in it
  * must be owned by root:root
  * must have 0744 perms
* Logs go to `/var/log/traps`
* The apt package name is `cortex-agent`
