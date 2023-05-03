
## This is here for historic purposes.  We no longer utilize pulbot for deployment
## See [deployment.md](https://github.com/pulibrary/pul-it-handbook/blob/main/services/deployment.md) for our latest deployment practices

# Pulbot Deployment


## Sequence of deployment events
* ask [pulbot](https://github.com/pulibrary/pulbot) to deploy
* it sends a [deployment event to github](https://docs.github.com/en/rest/deployments/deployments)
* github POSTs that event to [heaven](https://github.com/pulibrary/heaven) via a hook set up in the pulibrary organization
* heaven catches the event and runs the deployment using [capistrano](https://capistranorb.com/)

### Troubleshooting

#### When pulbot is unresponsive

Attempting to (re)deploy a service using pulbot does not always succeed, but in
all cases where pulbot deployments fail, one should observe that pulbot logs
these errors:

![An example of a pulbot deployment failure](./images/pulbot_failure.png "An example of a pulbot deployment failure")

However, when pulbot simply does not respond, one of two issues may be affecting infrastructure:

- There are delays for the GitHub deployment API (please inspect [https://status.github.com/](https://status.github.com) in order to eliminate this possibility)
- pulbot itself is not running or accessible over the HTTP
- Heaven is not running or accessible over the network

##### Troubleshooting pulbot

* troubleshoot: `pulbot ping` it should pong
* pulbot is on appdeploy1
* to restart pulbot, please invoke `killall -HUP node` on appdeploy1
* to deploy pulbot you can't invoke `bundle exec cap deploy`; you just need `cap` installed locally

##### Troubleshooting the GitHub Deployments API configuration

* go to [gh pulibrary org > webhooks](https://github.com/organizations/pulibrary/settings/hooks/309731714?tab=deliveries); you can see all the events that have been fired recently.
  * you can redeliver these events through that UI in github

##### Troubleshooting Heaven

* heaven service could be down
  * you can try to hit the heaven box via the browser; it redirects to the github page
  * heaven is on [appdeploy](https://appdeploy.princeton.edu/)
* heaven heavily relies upon [redis](https://redis.io/) to enqueue deployment jobs for pulbot
  * please invoke `sudo systemctl restart appdeploy-workers.service` to restart
    the `redis` worker processes
  * also please attempt to monitor the activity for these jobs using
    `tail -f /opt/pulbot/current/log/hubot.log` and `sudo journalctl -xfu appdeploy-workers.service`

## Heaven and automatic deployment

[heaven](https://github.com/pulibrary/heaven) is a Rails app that we run locally to receive webhooks from
Github (with an organization-wide webhook). Each app is configured with a Github auto-deployment integration
that sends a webhook call to heaven when there is a CI success on new commits to master.

## pulbot and on-demand deployment

[pulbot](https://github.com/pulibrary/pulbot) is our instance of [hubot](https://hubot.github.com/), a robot
that listens in slack for deployment commands.  Our deployable apps are configured in pulbot's. Note the [open ticket for fixing the README](https://github.com/pulibrary/pulbot/issues/15)
[apps.json](https://github.com/pulibrary/pulbot/blob/master/apps.json).  Once an app is configured, you can
deploy it in slack with the command:

```
$ pulbot deploy my_app to staging
```

Custom branches can be deployed:

```
$ pulbot deploy my_app/my_branch to staging
```

You can also deploy to other environments (like `production`) or deploy branches with CI failures by using `deploy!`.

### Updating pulbot

When you update pulbot's configuration, it needs to be redeployed, which you can do using pulbot:

```
$ pulbot deploy pulbot
```

### Deploy troubleshooting

#### public key problems

If deploying to a pre-ansible box, you must add heaven's public key to the deploy user's authorized_keys on the box that will be deployed to.

`curl https://raw.githubusercontent.com/pulibrary/princeton_ansible/master/keys/heaven.pub >> authorized_keys`

Ensure that your app's capfile deploys via https, not the git protocol. If switching from the git protocol, you'll need to delete the `./repo` directory or you'll get an error that looks like a problem with a public key.
