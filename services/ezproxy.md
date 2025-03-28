## Don't Panic
### Cert management
The ezproxy application depends on ACME certificates. There is no automatic way to add these to the ezproxy application.

**The certificates will automatically renew every year and will need to be added into the ezproxy application. The following steps allow one to add the certificate.**


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

### Registering certificates with OIT for Shibboleth integration
 
When a new cert is added and made active in the application, there is a manual registration process to ensure that the campus IDP is using the new certificate that has been made active. 

  * Login into the ezproxy [URL](https://login.ezproxy.princeton.edu/admin)
  * Select Manage SSL Certificates
  * View the active certificate by clicking on the number in the left column
  * Click the link to "View Shibboleth metadata for this certificate without Single Logout enabled"
  * Copy the contents of this link into a .xml file
  * Create a [Single Sign-on Intregration request via the form](https://princeton.service-now.com/nav_to.do?uri=%2Fcom.glideapp.servicecatalog_cat_item_view.do%3Fv%3D1%26sysparm_id%3Dedd831664f2c3340f56c0ad14210c7df%26sysparm_link_parent%3Dee785ce84f5f120022a859dd0210c778%26sysparm_catalog%3De0d08b13c3330100c8b837659bba8fb4%26sysparm_catalog_view%3Dcatalog_default%26sysparm_view%3Dtext_search) with OIT and add a note to update the certificate on the form by pasting in the contents of the .xml file you created. NOTE: In the request, advise OIT that a time should be scheduled for them to make the new certificate active concurrently with us updating the cert value variable in the ezproxy environment (see next step for where that is located).
  * Once OIT has confirmed that the certificate has been registered, update the {{ cert_value }} number in the group_vars (group_vars/ezproxy/testing.yml and/or 
  group_vars/ezproxy/production.yml) to match the number that the active certificate has on the application's Manage SSL Certificates page. 
