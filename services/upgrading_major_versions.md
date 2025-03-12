# Upgrading major versions of dependencies
According to [semver (Semantic Versioning)](https://www.geeksforgeeks.org/introduction-semantic-versioning/), a major version change is by definition a breaking change.

There is a high likelihood that major version changes for dependencies like Ruby will require not only a change in the version of the language on the server, but also a change in the application code, and these changes need to be coordinated in order to avoid production downtime.

Our applications should all have multiple servers in each environment, allowing us to follow a [blue green deployment pattern](https://www.redhat.com/en/topics/devops/what-is-blue-green-deployment). In addition, all of our Rails applications have health check endpoints that are checked by the load balancer, meaning that if a server is not in a good state, all traffic will be sent to the other server.

In order to update a major version of a dependency with breaking changes, follow this pattern:
1. Update the application code to use the updated version (e.g. CircleCI, .tool-versions), ensure tests still pass. If not, make changes to the code on a branch. Keep these changes unmerged until all environments are upgraded.
2. Update the version of the dependency in Princeton Ansible and update a single server using `--limit`, starting with the staging environment.
```zsh
ansible-playbook playbooks/orangelight.yml --limit catalog-staging1.princeton.edu
```
3. Using Capistrano, deploy only to that server (may need to comment out the server you are not deploying to in `config/deploy[environment].rb`)
```zsh
BRANCH=upgrade_ruby bundle exec cap staging deploy
```
4. Tunnel into that server and ensure it is performing as expected (for the example below you would go to http://localhost:1234/)
```zsh
ssh -L 1234:localhost:8080 pulsys@catalog-staging1.princeton.edu
```
5. Update another server following the same steps, going up through the environments one by one
6. Once all environments have been upgraded, merge code PRs (one for the application, one for Princeton Ansible).
