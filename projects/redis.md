# Redis

## Listing jobs

You can use redis-cli to list jobs in Redis, to get more detailed info than shows up in the Sidekiq dashboard (e.g., error messages that aren't truncated).  To dump the complete info for all jobs in the default queue:

`$ redis-cli -h figgy1 lrange queue:default 0 -1`

This can be filtered to just show a summary of how many of each type of job are queued:

`$ redis-cli -h figgy1 lrange queue:default 0 -1 | cut -d\" -f8 | grep -vx "" | sort | uniq -c`

To check the length of the default queue:

`$ redis-cli -h figgy1 llen queue:default`
