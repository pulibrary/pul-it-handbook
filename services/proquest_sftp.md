# proquest sftp drop

We have an [OpenBSD](http://openbsd.org) server that is a drop for our theses.
It uses public keys from ProQuest staffers on the user `proquest`

The dns for the service is `proquestdrop.pulcloud.io`

Things you will need to remember about managing this service:

* Your keys will allow you to connect as `pulsys`
* SFTP users home is `/pultheses/proquest`. This is the only service here
* OpenBSD uses `doas` instead of `sudo` but the syntax for most commands is the
  same
* The default shell is not bash
