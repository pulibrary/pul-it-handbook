# Let's Encrypt

Cicognara is behind our Kemp Application Delivery Controller. (loadbalancer)
Since all TLS traffic to [cicognara.org](https://cicognara.org) hits the
appliance first the following manual steps are required.

* on the appliance, disable the 302 redirect for http traffic.
* enable direct port 80 traffic to the end point
* On the virtual machine run 
```bash
systemctl stop nginx.service
systemctl start apache2.service
certbot certonly --webroot -w /var/www/html -d cicognara.org
systemctl stop apache2.service
systemctl start nginx.service
```
* copy the latest downloaded `cert.pem` and `privkey.pem` to a place you can
  retrieve them
* upload the certificate files onto the kemp appliance.
* re-enable to 302 redirect on the load balancer
