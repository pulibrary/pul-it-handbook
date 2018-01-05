# Deployment

## Heaven and automatic deployment

[heaven](https://github.com/pulibrary/heaven) is a Rails app that we run locally to receive webhooks from
Github (with an organization-wide webhook).  Each app is configured with a Github auto-deployment integration
that sends a webhook call to heaven when there is a CI success on new commits to master.

## pulbot and on-demand deployment

[pulbot](https://github.com/pulibrary/pulbot) is our instance of [hubot](https://hubot.github.com/), a robot
that listens in slack for deployment commands.  Our deployable apps are configured in pulbot's
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
