# Passenger in Nginx
We mostly run passenger on the servers from within NGINX.

## Logs
Logs for passenger can be found in /var/log/nginx/error.log and /var/log/nginx/access.log

## Troubleshooting
### can't find gem bundler (= x.x.x) with executable bundle (Gem::GemNotFoundException)
  Passenger requires a specific version of bundler.  
  1. Try running a `gem list bundler` to see what versions you have installed
  1. Update ansible to have the correct version `bundler_version` in your project app
  1. Run your playbook
  1. stop here if passenger comes back up
  1.  If passenger is still down check that only one version of bundler is in `gem list bundler`
  1.  If there is more than one remove the unwanted version from `sudo rm /usr/local/lib/ruby/gems/y.y.y/specifications/default/bundler-x.x.2x.gemspec`
  1. You might also need to delete other gems, like `base64`: `sudo rm /usr/local/lib/ruby/gems/3.2.0/specifications/default/base64-0.1.1.gemspec`

