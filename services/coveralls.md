# Coveralls

A platform to tell you how much of your code is covered by tests

## Integration with Circle CI

You can utilize the gem coveralls-reborn to upload coverage reports from your tests in circle-ci
  The instructions here are complete for a basic integration: https://github.com/tagliala/coveralls-ruby-reborn

### Parallel Tests
If you have paralleism in your circle-ci config.

1. You need to add `COVERALLS_PARALLEL: true` to the environment variables in your `.circleci/config.yml`

1. You need an additional step after your parallel tests to finish the coverage report:
   ```
    finish:
      executor: basic-executor
      steps:
        - attach_workspace:
            at: '~/orangelight'
        - run:
            name: finish up coverage
            command: curl -k https://coveralls.io/webhook?repo_token=$COVERALLS_REPO_TOKEN -d "payload[build_num]=$CIRCLE_WORKFLOW_ID&payload[status]=done"
   ```
   For an example see: https://github.com/pulibrary/orangelight/pull/2922/files
1. Finally you need to add an Evironment variable `COVERALLS_REPO_TOKEN` to your Circle CI Project Settings 
     * for example https://app.circleci.com/settings/project/github/pulibrary/orangelight/environment-variables?return-to=https%3A%2F%2Fapp.circleci.com%2Fpipelines%2Fgithub%2Fpulibrary%2Forangelight%3Ffilter%3Dall
     * The value of the token can be found on the project page in coveralls for example https://coveralls.io/github/pulibrary/orangelight **(You must be logged in to see it)**
