# To enable backup to Google Cloud

## Install google platform gcsfuse (assumes ubuntu so your mileage will vary)

```bash
export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`
echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add 
sudo apt-get update
sudo apt-get install gcsfuse
```

(Not tested but Centos or RedHat will be)

```bash
sudo tee /etc/yum.repos.d/gcsfuse.repo > /dev/null <<EOF
[gcsfuse]
name=gcsfuse (packages.cloud.google.com)
baseurl=https://packages.cloud.google.com/yum/repos/gcsfuse-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
	   https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

sudo yum install gcsfuse
```

## Install the Google Cloud SDK

https://cloud.google.com/sdk/docs/install

## Create a service account. 

In the cloud console go to the service accounts page

https://console.cloud.google.com/iam-admin/serviceaccounts?_ga=2.193001130.663822382.1625585441-1480485404.1601406997

* Select the pul-gcdc project

* Click Create Service account
 * (Please provide a description of the service account to future proof ourselves)
* Create a service account key:

* In the Cloud Console, click the email address for the service account that you created.
* Click Keys.
* Click Add key, then click Create new key.
* Click Create. A JSON key file is downloaded to your computer.
* Click Close.

## Create a new bucket on the console 

For our documentation purposes it will be `demo-bucket` and we will be using `conanthedeployer` user

* On the VM where the backup process will happen

```bash
sudo mkdir -p /mount/point
sudo chown -R conanthedeployer:conanthedeployer /mount/point
```


```bash
export GOOGLE_APPLICATION_CREDENTIALS="/home/conanthedeployer/.hidden_directory/service-account-file.json"
```
This environment variable will need to persist so add it to the profile of the `conanthedeployer` user 

* Modify the /etc/fstab of the VM to have

```bash
demo-bucket /mount/point gcsfuse rw,noauto,conanthedeployer,key_file=/home/conanthedeployer/.hidden_directory/service-account-file.json
```

Mount the bucket with 

```bash
sudo mount -a
```

