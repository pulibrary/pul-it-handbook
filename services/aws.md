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

## SSH Into a EC2 Instance
EC2 Instance can be found by logging into [aws](https://princeton.edu/aws)
* Click on Services and choose EC2
* Click on instances link
* Copy the public ip address for the machine you would like to ssh to
* ssh pulsys@<public ip address>

## Create an Elastic IP
For those EC2 Instances that cannot lose their fixed IP we can register one with [AWS](http://princeton.edu/aws) with the following steps
* From Management console navigate to Compute >> EC2 and under Network and Security select Elastic IPs
* Select *Allocate Elastic IP address*
* Once an IP is allocated you can associate it with the EC2 Instance by selecting the checkbox of your EC2 instance and click *Actions* and choose *Associate Elastic IP address.*

### Trouble shooting
  * You must be on VPN
  * The VPN IP must be in pul-acdc-ssh-princeton-network
     * On Left Panel choose Security groups (from the EC2 service on aws)
     * Click on `aws-princeton`
     * Click on `Edit Inbound Rules`
     * Click on `Add Rule` in bottom left
     * Add VPN IP Address which is found by:
        * clicking the hamburger menu on global protect
        * choosing settings
        * Choose `Connection` tab
        * Gateway IP is the IP address to add
     * Add Gateway Name to the rule
     * click on `Save rules`

## Replication
For replication you need to set up a role that allows access to your buckets. You will then need to configure the destination bucket to receive replicated objects.  And finally a replication rule on the source bucket.

### Creating the role
Create the IAM Role utilizing the trust relationship below and then add an inline permission like the one below after the Role is created.  Do not add additional built in AWS roles as this may cause issues with the replication assuming the role.

#### Trust Relationship
This relationship should work for allowing replication between buckets in our account and the first batch replication to replicate any existing files at the time replication is turned on.
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "s3.amazonaws.com",
                    "batchoperations.s3.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
```

#### Inline Permissions
The example below allows replication from `pdc-describe-staging-postcuration` to `pdc-describe-staging-preservation` and log to `pdc-describe-replication-logs`.  **Please modify the permission to have your desired buckets instead.**
```
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": [
				"s3:GetReplicationConfiguration",
				"s3:ListBucket",
				"s3:PutInventoryConfiguration"
			],
			"Resource": [
				"arn:aws:s3:::pdc-describe-staging-postcuration"
			]
		},
		{
			"Effect": "Allow",
			"Action": [
				"s3:GetObjectVersionForReplication",
				"s3:GetObjectVersionAcl",
				"s3:GetObjectVersionTagging"
			],
			"Resource": [
				"arn:aws:s3:::pdc-describe-staging-postcuration/*"
			]
		},
		{
			"Effect": "Allow",
			"Action": [
				"s3:ReplicateObject",
				"s3:ReplicateDelete",
				"s3:ReplicateTags"
			],
			"Resource": "arn:aws:s3:::pdc-describe-staging-preservation/*"
		},
		{
			"Effect": "Allow",
			"Action": [
				"s3:PutObject",
				"s3:GetObject"
			],
			"Resource": [
				"arn:aws:s3:::pdc-describe-replication-logs",
				"arn:aws:s3:::pdc-describe-replication-logs/*"
			]
		},
		{
			"Action": [
				"s3:InitiateReplication"
			],
			"Effect": "Allow",
			"Resource": [
				"arn:aws:s3:::pdc-describe-staging-postcuration/*"
			]
		}
	]
}
```
### Configure Receive Replicated Objects
On the destination bucket on the management tab you will need to select the Action dropdown and choose `receive replicated objects`.  This will generate permissions on the destination bucket to receive objects from the source bucket
![Screenshot 2023-11-22 at 10 56 39 AM](https://github.com/pulibrary/pul-it-handbook/assets/1599081/9052f278-ddf3-49ad-9179-29c8ca94a219)
I utilized my account id for the permissions, since I knew I had access to the buckets.
![Screenshot 2023-11-22 at 11 29 24 AM](https://github.com/pulibrary/pul-it-handbook/assets/1599081/cdb6c0e7-598e-44ef-9eae-db9c6847e48c)

### Create Replication Rule
On the source bucket you must create a replication role.  Under the management tab on the source bucket click on `Create Replication Rule`. Choose your replication options and then utilize the role created above as you IAM role.  After the rule is created you have the option to generate a batch job.  If you do, utilize the same IAM role to run your batch job.
