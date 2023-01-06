# AWS

We have some lambdas and stuff up on AWS, including:
* IIIF serverless
* Alma Webhook Monitor

In general we have created these services manually, and then configured and
deployed them via aws-sam-cli. Documentation should live in each relevant
codebase. In some cases monitoring is set up in datadog.

Each application using AWS should have its own AIM profile.

Use tags where possible (e.g. for AIM profiles and lambdas) for `environment` and `project` with the appropriate
values.

## SSH Into a EC2 Instance
EC2 Instance can be found by logging into [aws](https://princeton.edu/aws)
* Click on Services and choose EC2
* Click on instaces link
* Copy the public ip address for the machine you would like to ssh to
* ssh pulsys@<public ip address>
### Trouble shooting
  * You must be on VPN
  * The VPN IP must be in pul-acdc-ssh-princeton-network
     * On Left Panel choose Security groups (from the EC2 service on aws)
     * Click on `aws-princeton`
     * Click on `Edit Inbound Rules`
     * Click on `Add Rule` in bottom left
     * Add VPN IP Address which is found by:
        * clicking the hamberger menu on global protect
        * choosing settings
        * Choose `Connection` tab
        * Gateway IP is the IP address to add
     * Add Gateway Name to the rule
     * click on `Save rules`
