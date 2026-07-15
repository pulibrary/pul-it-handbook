## Don't Panic

### ACME Cert management

The ezproxy application depends on certificates that are generated through the [CertiNext](us.certinext.io) certificate management platform. There is no automatic way to add these to the ezproxy application.

**The certificates will automatically renew every year and will need to be added into the ezproxy application. The following steps allow one to add the certificate.**

  * Log into the ezproxy VM with `ssh pulsys@ezproxy`
  * Go to the newly renewed certificate path of
    ```bash
    sudo su
    cd /etc/letsencrypt/live/*.ezproxy/
    ls -al
    ...
    ...
    lrwxrwxrwx 1 root root   31 Mar 27 18:58 cert.pem -> ../../archive/*.ezproxy/cert2.pem
    lrwxrwxrwx 1 root root   32 Mar 27 18:58 chain.pem -> ../../archive/*.ezproxy/chain2.pem
    lrwxrwxrwx 1 root root   36 Mar 27 18:58 fullchain.pem -> ../../archive/*.ezproxy/fullchain2.pem
    lrwxrwxrwx 1 root root   34 Mar 27 18:58 privkey.pem -> ../../archive/*.ezproxy/privkey2.pem
    ```
  * Login into the ezproxy [URL](https://login.ezproxy.princeton.edu/admin)
  * Select Manage SSL Certificates
  * Import Existing SSL Certificate
  * Copy the contents of `cert.pem` above into the certificate
  * Copy the contents of `privkey.pem` above into the key and Import Certificate
  * To make the new certificate active type *ACTIVE* in the check box and press `activate`
  * Browsers will also require the Certificate Authority Chain. Copy the contents of `chain.pem` above into the box and click `Save Certificate Authority Chain`
  * To make the new certificate active type *ACTIVE* in the check box and press `activate`
  * Then return to the Administation home page and find the *Restart EzProxy* Link to restart the EzProxy application

  ### Manual Cert management

If for some reason the above ACME steps do not work, the following method can be used to manually generate certificates from CertiNext and import them into the ezproxy application. 

For ezproxy admins: 
  * Login into the ezproxy [URL](https://login.ezproxy.princeton.edu/admin)
  * Select Manage SSL Certificates
  * Create New SSL Certificate
  * Fill out the information under **Key size** (Country: US; Organization: Princeton University; Administrator email: lsupport@princeton.edu)
  * For Certificate name, choose the radio button for `*.ezproxy-test.princeton.edu (fewest to no browser warnings proxying https web sites; more expensive)`
  * For Subject Alernate Name, check off BOTH boxes: `ezproxy-test.princeton.edu` and `*.ezproxy-test.princeton.edu`
  * Expiration should be left as 1 year. 
  * Click the button that says `Certificate Signing Request`. This will generate a cert that you will copy to your clipboard. 

For Operations team:
  * Go to [CertiNext](us.certinext.io)
  * Click `New Certificate` in the upper left 
  * Choose the following options: CA Source=emSign; Certificate Type=SSL/TLS Certificates; Product=InCommon DV SSL Certificate Wildcard. Click Next. 
  * Paste the Certificate Signing Request that you copied from ezproxy above into the box that says `Paste CSR`. Click Next. 
  * Proceed through the next screens and Submit the request. You will receive an email to download the certificate zip files. An ezproxy admin will need these files to proceed. 

For ezproxy admins:
  * Unzip the certificate files from CertiNext (see above step).
  * `cat` the file called `01_EndEntity_wc.ezproxy-test.princeton.edu.cer` and copy its contents
  * Paste the contents of the file above into the ezproxy admin UI in the box underneath the Certificate Signing Request you copied into CertiNext earlier. Hit the button to `Save Certificate.` 
  * `cat` the file that starts with a multi-digit number and ends in `_fullchain.pem` and copy its contents into the same (and now empty) box in the ezproxy admin UI and click `Save Certificate.`
  * To make the new certificate active type *ACTIVE* in the check box and press `activate`
  * Then return to the Administation home page and find the *Restart EzProxy* Link to restart the EzProxy application.
