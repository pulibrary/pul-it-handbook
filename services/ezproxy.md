## Don't Panic
### Cert management
The ezproxy application depends on ACME certificates.

The certificates will automatically renew every year and will need to be added into the ezproxy application. The following steps allow one to add the certificate. 

  * Log into the ezproxy VM with `ssh pulsys@ezproxy`
  * Go to the newly renewed certificate path of
    ```bash
    sudo su
    cd /etc/letsencrypt/live/ezproxy/
    ls -al
    ...
    ...
    lrwxrwxrwx 1 root root   31 Mar 27 18:58 cert.pem -> ../../archive/ezproxy/cert1.pem
    lrwxrwxrwx 1 root root   32 Mar 27 18:58 chain.pem -> ../../archive/ezproxy/chain1.pem
    lrwxrwxrwx 1 root root   36 Mar 27 18:58 fullchain.pem -> ../../archive/ezproxy/fullchain1.pem
    lrwxrwxrwx 1 root root   34 Mar 27 18:58 privkey.pem -> ../../archive/ezproxy/privkey1.pem
    ```
  * Login into the ezproxy [URL](https://login.ezproxy.princeton.edu/admin)
  * Select Manage SSL Certificates
  * Import Existing SSL Certificate
  * Copy the contents of `cert.pem` above into the certificate
  * Copy the contents of `privkey.pem` above into the key and Import Certificate
  * To make the new certificate active type *ACTIVE* in the check box and press `activate`
  * Then return to the Administation home page and find the *Restart EzProxy* Link to restart the EzProxy application
