# Deployment

Once a pull request is merged that change is now part of the main codebase. However, it isn't running live on the actual application until it's deployed. Most PUL projects use [Capistrano](https://capistranorb.com/) for deployment. Capistrano uses SSH to pull the latest code onto an application server, prep a fresh version of the application (by, for example, building a new javascript deliverable, and clearing the cache), and then restarting the application web server (usually passenger) and any other services running the application, like sidekiq workers or queue-subscribing processes.

Capistrano can be run on a command line from within a project on your local machine. But we prefer to run it via ansible-tower to ensure greater visibility of deploys (via standardized slack integrations) and easier pairing to troubleshoot when deploys fail.

## Sequence of deployment events
* ask ansible-tower to deploy your code
* ansible-tower runs the deployment appdeploy.princeton.edu
* You are notifed via slack when the deployment completes

## Detailed ansible tower instructions
1. To deploy code using Ansible Tower:
Go to https://ansible-tower.princeton.edu/ and log in using CAS.
1. Go to Resources -> Templates in the left sidebar.
1. To the right of "Capistrano deploy", click on the little rocket ship to Launch the template. (Alternatively, click on “Capistrano deploy” and then click the "Launch" button at the bottom of the page.)
1. On the next screen, pick the verbosity you want (it defaults to ‘normal’ but you can use this to debug).
1. On the next screen, select your options:
    1. use the dropdown to pick the repository you want to deploy
    1. (optional) if you are not deploying the “main” branch, replace “main” with the name of your branch
    1. (optional) if you are not deploying to the “staging” environment, use the dropdown to pick the environment you want
    1. (optional) if you want slack alerts for this job to go to a channel other than “ansible-alerts”, use the dropdown to pick the slack channel 
1. Click Next to reach the review screen.
1. Click Launch to launch the job.
1. Refresh the page periodically to watch progress or click on `Back to jobs` (or on `Jobs` in the left sidebar) , click on a job to see details.

## To add a new slack channel to the options for slack alerts
1. In Slack, add the TowerNotifications bot to the channel
    1. in the channel, type `@TowerNotifications` - if the bot is not in that channel yet, it should show a ‘Not in channel’ message to the right of the bot name
    1. enter your message to the bot to invite the bot into the channel
1. In Ansible Tower, add the slack channel to the Capistrano deploy template’s Survey question 
   1. Go to `Resources => Templates` and select `Capistrano deploy`
   1. Select the Survey pane on the far right
   1. Click on the question ‘What slack channel do you want alerts to go to?’ to edit it
   1. Click at the end of the last entry under ‘Multiple Choice Options’ and hit ‘Enter’ to open a new line
   1. Click on the new line and enter the value you want to add - every slack channel must begin with ‘#’

## To add a new repository to the options for deploying
  1. In Ansible Tower, add the new repository to the Capistrano deploy template’s Survey question
     1. Go to `Resources => Templates` and select `Capistrano deploy`
     1. Select the Survey pane on the far right
     1. Click on the question ‘Which repo do you want to deploy?’ to edit it
     1. Click at the end of the last entry under ‘Multiple Choice Options’ and hit ‘Enter’ to open a new line
     1. Click on the new line and enter the value you want to add - the repository name here must match the repository name in GitHub

## Maintaining the slack app

The connection from Tower to Slack (including the auth token) is configured in the PUL slack org: https://api.slack.com/apps.

## Troubleshooting

### When the deploy fails

#### You may need to add a gem your capistrano deployment depends on to the towerdeploy role
  1. Add the gem to the list of gems [here](https://github.com/pulibrary/princeton_ansible/blob/main/roles/towerdeploy/tasks/main.yml#L16)
  1. Generate a PR for your change in priceton ansible
  1. Run the towerdeploy playbook from princeton ansible `ansible-playbook playbooks/towerdeploy`
  1. verify the PR fixed your issue and request for it to be merged

#### Document other reasons for failure here as we see them

### Having issues logging into ansible-tower
  Ping the `#infrastructure` channel to be added to the ansible tower group
