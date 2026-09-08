## RabbitMQ

Many of our applications need data updates from Figgy as records are changed.

### Overview

When figgy records are saved or deleted, figgy sends a message to the rabbitmq figgy_events fanout exchange. Every message sent to the exchange is copied to every queue attached to that exchange. The queues correspond to different subscriber applications, which run listeners that kick off jobs. Figgy configures the exchange and other applications configure the queues.

Subscriber applications use sneakers to listen to the queues. Capistrano worker restart commands run tasks for both sidekiq and sneakers workers.

### Configuration

  * In Figgy, exchanges are configured in `app/services/messaging_client.rb`. It uses a gem called `bunny`. The exchanges are durable. This means they will come back after a rabbitmq crash. (note that the messages aren't created as "persistent" which means they would be lost in a rabbitmq crash.)
  * In applications running sneakers, general configuration is in `config/initializers/sneakers.rb`. The exchange here has to match the one configured in figgy.
  * Subscriber applications have event handlers; e.g. in DPUL it's at `app/workers/figgy_event_handler.rb`.

### Implementation

RabbitMQ is run as a three node cluster in [Nomad](https://github.com/pulibrary/princeton_ansible/tree/main/nomad/figgy-infrastructure).

Applications in Nomad can reference it from its consul service (e.g `figgy-rabbitmq-staging.service.consul:6379`), applications outside of Nomad can reference it from a load-balanced proxy (`nomad-ingress-staging.lib.princeton.edu:10000` for staging, `nomad-ingress-production.lib.princeton.edu:10001` for production.)

### User Interface

You must be on VPN to access the following:

**Staging**: https://figgy-rabbitmq-staging.lib.princeton.edu
**Production**: https://figgy-rabbitmq-production.lib.princeton.edu

You can get authentication credentials from ansible vault.

If you need to look at a message from the queue, you can pull it out and set it to nack / requeue, that way it will go back on the queue after you have retrieved it
  * Go to queues > select queue > click "get message" (ack mode should be "Nack
message requeue true")

