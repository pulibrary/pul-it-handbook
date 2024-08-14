# Goal of this Documentation

Audience for this document: This is an internal document for Princeton University Library IT Developer teams to use in developing and maintaining applications.

Below is a list of expectations that we have for the systems that we run in production. Together the goal is to make our applications easy to maintain, simple to respond to incidents for, enable experience maintaining applications to be portable between teams, and increase work satisfaction for developers. These are collective requirements \- no individual is expected to implement all of these themselves, but by working together we can implement these for our applications.

Our experience has been that the time it takes to implement these practices is exceeded in the long run by the time and stress we save in doing so. It should be possible for all team members to have low stress, take vacations when they want, and feel comfortable in the environment our department builds.

How we use this document

* As a roadmap when starting new projects  
* As a guide for improving existing applications

# Checklist

There are some examples of technologies in a few of these requirements, but they are only there for illustrative purposes. It doesn’t particularly matter how these practices are implemented, just that they are.

## Infrastructure

### Infrastructure as Code

#### Reasoning

Defining our infrastructure as code lets us easily reproduce an environment if it needs to be replaced or upgraded. Manual intervention on machines makes them more fragile, so we avoid that with infrastructure as code technology. An example is Ansible. If there is no way to define the infrastructure as code, then the steps to get to the desired state should be documented as a run book.

### One Application Per Server

#### Reasoning

Having multiple applications in a single environment requires them to share system dependencies (e.g ruby, NodeJS, postgres client versions, etc), thus making dependency changes for one application unable to be done without the other.

### Staging Environment

#### Reasoning

A staging environment lets us test infrastructure and code changes before deploying them to production to ensure they work as expected. This reduces the chance of a negative experience by our users, reduces stress for developers, and incentivizes small changes at a time because it’s less scary to deploy to production after testing in staging.

### Minimum 2 Servers Per Environment

#### Reasoning

Having two servers allows us to take one down in order to upgrade the infrastructure without it affecting the uptime of the application and provide high availability in the case of a system going down generally. Having two servers requires sharing state between those two servers, so there must also be two in staging to let us test sharing that state. Staging servers may have less available resources than production to reduce overhead.

### Load Balanced

#### Reasoning

Having multiple servers allows us to take one down in order to upgrade the infrastructure and having a load balancer gives us a tool to do that swap in a single place. It also gives us the capability to scale horizontally by adding new servers that will serve the same web address. An example of a load balancer is nginx+.

### Low Barrier to Deployment

#### Reasoning

By making it easier to deploy we can do it more often, which results in smaller changes that are easier to diagnose and fix if a bug arises. One way we accomplish this is by having a single command to deploy an application. By having a continuous integration pipeline checking the code practices below we’re also able to deploy with more confidence. An example of single command deployment is using capistrano.

### Backup & Restore

It’s important that the data that we depend on is backed up and easily restorable. We should practice our documentation for restoring these backups so that we know how, we know that it works, and it’s not stressful to do it when we’re forced to.

#### Reasoning

If our data was lost it would result in a lot of staff time being used up. By backing up our stateful storage and having the ability to restore it we can save that time in the future. It also provides a steady last resort fallback for any incident.

### Index Replication

Applications that use Solr indices should use replication factor 3\.

#### Reasoning

This allows one machine to come down, e.g. for maintenance, while retaining resilience for the application.

## Security

### Use Dependencies Under Support

#### Reasoning

We use a lot of dependencies which increase the level of vulnerability for our applications. Therefore, we should ensure that those dependencies are receiving security patches and responding to vulnerabilities on a regular basis. To support this we should have a system to automatically check and update vulnerable dependencies. An example of a tool that does this is Dependabot on Github.

### Firewall

#### Reasoning

The more accessible our applications and servers are to the world, the easier they are to infiltrate. We should limit the availability of our servers to the world to mitigate risk as much as possible. For example, web ports on server boxes should not be generally accessible, but the load balancer should have access to them.

## Secrets Management

#### Reasoning

Secrets should be centrally and securely managed, such that no secret is known by only one person. This makes it easy for any developer on any team to rotate those secrets as needed, and if people leave we don’t lose access to secrets. Examples of tools we use for this are Ansible Vault and LastPass.

## Single Sign-on for Authentication / Authorization

Applications should use one of the Office of Information Technology (OIT) modern, supported Single Sign-on solutions for users to authenticate and are authorized for login.

## Monitoring

### Alerts Requiring Response

#### Reasoning

Alerts for our services allow us to be proactive rather than reactive to user reports. Alerts should not be so constant that they’re easily ignorable, and be resolvable via action from our staff. Examples of tools that do this include Datadog and CheckMK.

### Diagnostic Metrics

#### Reasoning

We should keep metrics about the current and past state of our systems so that when we are responding to incidents or evaluating the health of our systems we have all the information we need to be able to do so. Examples of metrics that we should keep are disk size, heap size, application logs, application performance monitoring, and application exceptions. Examples of tools that do this are Datadog, Honeybadger, and CheckMK.

## User Interfaces

### WCAG AA Compliance

#### Reasoning

The University requires us to meet the WCAG AA as a minimum requirement for our applications. In order to support our applications in meeting this requirement, and so that we don’t inadvertently introduce regressions, these requirements should be covered by automated tests when possible and when not, covered by a regular auditing or development practice. An example of tools that do this are Axe Devtools and DubBot.

### Web Analytics

Our applications should gather web analytics that effectively measure the goals and success criteria of that application. An example of a tool that does this is Plausible.io.

## Code Practices

### Main Branch Always Deployable

#### Reasoning

If an entire team is gone, another team should always know it’s safe to re-deploy the main branch. Differing practices around deployability leads to stress in the event of an incident.

### Automated Tests

#### Reasoning

Automated tests give us the ability to refactor and migrate systems with confidence, knowing that the functionality our users depend on continues to work \- including the edge cases. Without tests, code quickly becomes stale and fragile. An example of a unit test framework is RSpec.

### Automated Style Consistency & Checking

#### Reasoning

This reduces the cognitive overhead of jumping into and understanding a code base. Automating it means developers don’t have to spend energy implementing it. Examples of style checkers include Rubocop and ESLint.

### Code Coverage

#### Reasoning

We should measure the code coverage of our applications and recognize that the higher the coverage, the better, but also that 100% coverage does not mean you have all the tests you need. An example of a code coverage tool is Simplecov.

### Continuous Integration

There should be a service that runs before code is merged or reviewed which ensures that tests pass, style is correct, code coverage meets expectations, and anything we can automatically verify that matches our practices is done before that code reaches main.

#### Reasoning

It takes a lot of time for developers to individually ensure these things, so automating it with continuous integration allows reviewers to focus on the code and architecture, rather than the style or other requirements.  Examples of CI tools include CircleCI and Github Actions.

### Code Review Required for Merge to Main

Code should never be able to be pushed directly to the main branch, as it must always be deployable (see above) and meet our various standards. Thus, it should be reviewed by a peer and pass continuous integration.

#### Reasoning

As the maintenance of the code base is a shared responsibility on teams, it’s important to make sure that multiple members of the team understand the code that’s going to be deployed, can work together to make the code better, and know how it fits into the application as a whole. Code review is a simple process to enable this, and preventing pushes directly to main without passing continuous integration or code review helps incentivize this practice. An example of a way to implement this is branch protection on Github.

### Configuration via Environment Variables

#### Reasoning

It should be easy to add new environments or change the configuration of individual deployments of the application. Environment variables let us do that. See [https://12factor.net/config](https://12factor.net/config) for more information.

### Documentation 

Our applications should include a README with access to documentation that provides information on how to run the application, what it’s for, how to deploy it, how to run tests, and other activities that a developer might want to do or know about.

#### Reasoning

The more information we provide within the code base, the less we have to rely on the memory of individual developers. It also helps onboard new developers faster and provides a way for other teams to gain context on our portfolio.
