# Rapid7 notes

We are installing Rapid7 InsightVM, a security auditing service, on our virtual servers in accordance with OIT requirements. Here is what we know about the Rapid7 agent. 

* We install the Rapid7 agent using [the security](https://github.com/pulibrary/princeton_ansible/blob/main/playbooks/utils/security_theater.yml) playbook.
* The token for running the install script is dynamically generated. If it stops working, reach out to vulnr_mgmnt@princeton.edu for a new one, then update the `group_vars/all/vault.yml` file with the new token.
*	The service name is `ir_agent`, as in `sudo service ir_agent status`.
*	The agent can run many components, we are running only the `insight_agent`, which looks for security vulnerabilities.
*	Best diagnostic tool is `./ir_agent -diagnose` which must be run from the specific version directory – for example: `/opt/rapid7/ir_agent/components/insight_agent/3.1.5.15`
*	Happy output looks like this:

```
root@lib-confluence-staging1:/opt/rapid7/ir_agent/components/insight_agent/3.1.5.15# ./ir_agent -diagnose
-- Starting linux agent --
------------------ TEST STARTED ------------------
Running connectivity test for the insight agent in region: us-east-1, using proxy: None. 
Using SSL certificates under: /opt/rapid7/ir_agent/components/bootstrap/common/ssl.
[proxy.Provider.readConfigFileProxy]: proxy configuration file not present: /opt/rapid7/ir_agent/components/bootstrap/common/proxy.config
Couldn't discover proxy since No proxy found, runcmd returned value 1.
[Direct endpoint.ingress.rapid7.com:443] [Socket Connect] ... PASSED
[Direct endpoint.ingress.rapid7.com:443] [Agent Ping] ... PASSED
[Direct endpoint.ingress.rapid7.com:443] [TLSv1.2 Handshake] ... PASSED
[Direct endpoint.ingress.rapid7.com:443] [Agent Message] ... PASSED
```

*	We did not capture unhappy output, but presumably it would not say `PASSED` - if you are looking at this documentation because Rapid7 has gone down, please add the output of this diagnostic test for Future Us.
*	The agent updates itself over time, installing new versions in the directory above.
*	When it updates, it does not remove old version directories.
*	Updates may not happen in sync across all our machines, and the script does not always install the latest version, so you can’t count on finding the same version on all machines on any given day.
*	We add the tag “library” to all our machines using the `--attributes="library"` flag in the install script run. This enables OIT to send us reports on only our servers.
*	For now, OIT will send a condensed report to lsupport@princeton.edu. If we decide we want a more comprehensive report, we can request one.
