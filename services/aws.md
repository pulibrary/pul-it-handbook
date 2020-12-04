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
