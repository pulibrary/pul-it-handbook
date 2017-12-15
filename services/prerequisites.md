# Prerequisites

## Network

All hardware *no exceptions* will be behind our Palo Alto firewall. Access to
hardware even within the libraries network will be by request. By default no
ingress is allowed.

Furthermore applications are encouraged to use Kemp Application Delivery Service
(generically referred to as a Load Balancer) The value of this is determined as
the project embarks.

## Operating System

All our *new* Operating Systems will run [Ubuntu Xenial
LTE](https://releases.ubuntu.com/16.04/) unless an upstream project insists on
another distro/version.

## Users

We use a sudo enabled user that uses keybased authentication. Place your keys on github to be added to the `authorized_keys` of this user.

## Software

The Operating System for virtual machines will be created using
[Packer](https://github.com/pulibrary/vmimages) and will ship with:

* [Filebeat](https://www.elastic.co/products/beats/filebeat)
* [Netdata](http://netdata.firehol.org)
* [Logrotate](https://packages.ubuntu.com/xenial/logrotate)
