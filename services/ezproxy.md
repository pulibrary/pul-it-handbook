## Don't Panic
### Cert management
The ezproxy application depends on ACME certificates.

The certificates will automatically renew every year and will need to be added into the ezproxy application. The following steps allow one to add the certificate. 

  * Log into the ezproxy VM with `ssh pulsys@ezproxy`
  * Go to the new certificate path of `/etc/letsencrypt/live/ezproxy/`
  * Login into the ezproxy URL
  * Import Existing SSL Certificate
  * Copy the contents of `cert.pem` into the certificate
  * Copy the contents of `privkey.pem` into the key and Import Certificate
  * Copy the contents of `fullchain.pem` into the next page and Save Certificate Authority Chain
  * 
