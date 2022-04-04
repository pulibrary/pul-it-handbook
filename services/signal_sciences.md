# Signal Sciences

We use Signal Sciences to monitor and limit traffic to the load balancer.

## Access the UI

[Signal Sciences load balancer overview](https://dashboard.signalsciences.net/corps/pu_library/sites/adc?dashboardId=5d93700e24dfc501917be84c)
[View events](https://dashboard.signalsciences.net/corps/pu_library/sites/adc/events)
[Enabled rules](https://dashboard.signalsciences.net/corps/pu_library/sites/adc/rules?enabled=true)

## Rate limit and Bot traffic
Sometimes a site gets hit with a lot of traffic from a bot that isn't respecting
our robots.txt files. In this case you will likely see a big jump in requests to
the machine (i.e. in Datadog) and you will see their user agent repeatedly in
logs.

We have an active rule to disallow traffic automatically from any IP that makes > 200 requests
in 1 minute. The traffic is disallowed for 10 minutes and then allowed again.
The number of requests here was set just high enough to catch a specific bad bot we observed on DPUL.

If a bot is slowing down a service despite that rate limit, you can make a rule
that looks for that bot specifically. See [this user agent match
example](https://dashboard.signalsciences.net/corps/pu_library/sites/adc/rules/61e877705e2e4e01e6d2d404).

You can allow specific IPs to get around the automatic rate limiting. See [this figgy example](https://dashboard.signalsciences.net/corps/pu_library/sites/adc/rules/61e9d4bc455dd201e6238905).
