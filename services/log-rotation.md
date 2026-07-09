# Logging: Rotation and Retention

Logs are an important source of information about our services and systems. However, we cannot keep all logs forever. Here's an outline of our goals and policies for log retention and rotation. 

## Log Rotation

We rotate log files on the VMs and other machines that generate them, to prevent the logs from using up all the available disk space. Log rotation happens on a schedule (usually daily, but sometimes more or less frequently) and also by size - if a log grows beyond a set size, it gets rotated sooner than the schedule would suggest. We monitor log rotation and sudden changes in log size to help manage log rotation and retention.

## Log Retention

We retain log files so we can find useful information when investigating problems on our systems. We have three streams for log retention:

1. Local storage, on the original VMs / machines
2. Centralized storage, on our consolidated logging and metrics system
3. Remote storage, in cold storage

### Local storage

We keep a maximum of [TODO: confirm number . . . 30 files] for each log locally. Because log rotation can happen frequently, we may have less than 30 days' worth of logs at any given time on each machine.  

### Centralized storage

We collect some logs in our consolidated logging and metrics system. We select logs that we are likely to want to review as part of debugging issues or analyzing performance trends. Typically we keep [TODO: confirm timeframe . . . 2 weeks] worth of logs for review and analysis in this centralized system.

### Remote storage

We keep compressed copies of certain logs for a longer period of time in "cold storage", making them available for forensic examination if needed.
