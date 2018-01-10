## Allow access from a new box
Currently the solr boxes have local firewall
ssh in and do `sudo ufw allow proto tcp from XXX.XXX.XXX.XXX to any port 8983`
