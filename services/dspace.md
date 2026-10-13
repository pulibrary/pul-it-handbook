# DataSpace

## Authentication for EZProxy

In order to authenticate over the SSH into the DataSpace, OAR, and Theses
servers, one must request and obtain separate, privileged \*NIX accounts from
the Office of Information Technology using a ServiceNow @ Princeton (SN@P)
request. Further, RSA SecureID soft tokens for this separate account with must
also be requested.

Once these are in place, one should have set a PIN for the RSA soft token, along
with properly configured the mobile app. which randomly generates temporary
access codes.

One should attempt to authenticate into the server using
`ssh [my_privileged_account]@epoxy@princeton.edu`. When attempting to
authenticate, one will receive a prompt `Enter PASSCODE:`. Please enter the RSA
PIN followed immediately by your current temporary access code in order to gain
access to the server.

## Authentication for DSpace Servers

Once on the GCP proxy server, one should be granted access to multiple servers for
the following:

- DataSpace
  - `gcp-dataspace-staging1`
  - `gcp-dataspace-prod1`
- Open Access Repository (OAR)
  - `gcp-oar-staging1`
  - `gcp-oar-prod1`

Each one of these servers can only be accessed as `pulsys` using GCP proxy `bastion` servers as `jump` hosts over `ssh`: (`ssh -J pulsys@bastion-prod.pulcloud.io` for the production environment, `ssh -J pulsys@bastion-staging.pulcloud.io`, for the staging environment).

- DataSpace
  - `ssh -t -J pulsys@bastion-staging.pulcloud.io gcp-dataspace-staging1`
  - `ssh -t -J pulsys@bastion-prod.pulcloud.io gcp-dataspace-prod1`
- Open Access Repository (OAR)
  - `ssh -t -J pulsys@bastion-staging.pulcloud.io gcp-oar-staging1`
  - `ssh -t -J pulsys@bastion-prod.pulcloud.io gcp-oar-prod1`

## Common DSpace maintenance tasks

When we update packages, the dspace servers sometimes have trouble coping with network traffic. Please check dataspace.princeton.edu after running maintenance. If you see issues, please attempt to restart the following services:

_In one terminal session, please run the following:_

```bash
sudo systemctl stop nginx
sudo systemctl stop apache2
```

_In a second terminal session, please run the following:_

```bash
sudo su - dspace
dsstop
dsstart
curl http://localhost:8080/
```

_In the first terminal session, please run the following:_

```bash
sudo systemctl start nginx
sudo systemctl start apache2
```

The production dspace machine connects to PostgreSQL on a GCP box. Local IP for that is `10.64.16.3`. You can use Cloud Shell access from Google Cloud's platform to restart the database if needed:

```
sudo service postgresql restart
```
