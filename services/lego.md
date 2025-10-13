## lego

OpenBSD includes a lego package. We will focus on dataspace and oar below

```bash
doas pkg_add -vi  -y lego
lego --version
# lego version v4.xx.x openbsd/amd64
```

### Prepare Directories
```bash
doas mkdir -p /var/lego
doas chown root:wheel /var/lego
doas chmod 750 /var/lego
doas mkdir -p /etc/nginx/conf.d
```

### ACME HTTP-01 webroot for nginx (no downtime)

```sh
doas mkdir -p /var/www/acme
doas chown root:wheel /var/www/acme
doas chmod 755 /var/www/acme

doas tee /etc/nginx/conf.d/acme-challenge.conf >/dev/null <<'EOF'
# Serve ACME HTTP-01 challenges from /var/www/acme
location ^~ /.well-known/acme-challenge/ {
  root /var/www/acme;
  default_type "text/plain";
  autoindex off;
  try_files $uri =404;
}
EOF
```

Add this include inside the existing port 80 server block (the one that redirects to HTTPS):

```sh
doas awk '
/server\s*{\s*$/ { inserver=1 }
inserver && /listen 80;/ { print; print "        include /etc/nginx/conf.d/acme-challenge.conf;"; next }
{ print }
' /etc/nginx/nginx.conf | doas tee /etc/nginx/nginx.conf.new >/dev/null && \
doas mv /etc/nginx/nginx.conf.new /etc/nginx/nginx.conf
```

Test and reload nginx:

```sh
doas nginx -t && doas rcctl reload nginx || doas rcctl restart nginx
```
###  Deploy hook (drops cert/key to the nginx paths and reloads)

```sh
doas tee /usr/local/sbin/deploy-ssl-nginx.sh >/dev/null <<'EOF'
#!/bin/sh
set -eu

: "${LEGO_CERT_DOMAIN:?missing}"
: "${LEGO_CERT_PATH:?missing}"
: "${LEGO_CERT_KEY_PATH:?missing}"

ISSUER_PATH="${LEGO_CERT_PATH%".crt"}.issuer.crt"

case "$LEGO_CERT_DOMAIN" in
  dataspace.princeton.edu)
    CERT_DST="/etc/ssl/dataspace.princeton.edu.chained.pem"
    KEY_DST="/etc/ssl/private/dataspace.princeton.edu.key"
    ;;
  oar.princeton.edu)
    CERT_DST="/etc/ssl/oar.princeton.edu.chained.pem"
    KEY_DST="/etc/ssl/private/oar.princeton.edu.key"
    ;;
  *)
    # not a managed hostname—skip quietly (useful if lego manages other names)
    exit 0
    ;;
esac

# nginx expects fullchain in one file: cert + issuer
umask 022
cat "$LEGO_CERT_PATH" "$ISSUER_PATH" > "$CERT_DST"
install -m 0600 -o root -g wheel "$LEGO_CERT_KEY_PATH" "$KEY_DST"

# sanity check & reload
nginx -t && rcctl reload nginx || rcctl restart nginx
EOF
doas chmod 0755 /usr/local/sbin/deploy-ssl-nginx.sh
```

### Issue certificates (Sectigo/InCommon, EAB, HTTP-01 webroot)

Replace the EAB values with real secrets from [Ansible Vault](https://github.com/pulibrary/princeton_ansible/blob/main/group_vars/all/vault.yml).

```sh
# dataspace.princeton.edu
doas /usr/local/bin/lego \
  --path /var/lego \
  --server "https://acme.sectigo.com/v2/InCommonRSAOV" \
  --email "lsupport@princeton.edu" \
  --accept-tos \
  --eab --kid "{{ vault_acme_eab_kid }}" --hmac "{{ vault_acme_eab_hmac_key }}" \
  -d dataspace.princeton.edu \
  --http --http.webroot "/var/www/acme" \
  run --run-hook /usr/local/sbin/deploy-ssl-nginx.sh

# oar.princeton.edu
doas /usr/local/bin/lego \
  --path /var/lego \
  --server "https://acme.sectigo.com/v2/InCommonRSAOV" \
  --email "lsupport@princeton.edu" \
  --accept-tos \
  --eab --kid "{{ vault_acme_eab_kid }}" --hmac "{{ vault_acme_eab_hmac_key }}" \
  -d oar.princeton.edu \
  --http --http.webroot "/var/www/acme" \
  run --run-hook /usr/local/sbin/deploy-ssl-nginx.sh
```

Expected resulting files (as the nginx config already references):

```swift
/etc/ssl/dataspace.princeton.edu.chained.pem
/etc/ssl/private/dataspace.princeton.edu.key
/etc/ssl/oar.princeton.edu.chained.pem
/etc/ssl/private/oar.princeton.edu.key
```

### Set up cron renewal (root)

```sh
( doas crontab -l 2>/dev/null | sed '/lego renew/d'
  echo '17 3 * * * /usr/local/bin/lego --path /var/lego --server "https://acme.sectigo.com/v2/InCommonRSAOV" --email "lsupport@princeton.edu" renew --days 30 --renew-hook /usr/local/sbin/deploy-ssl-nginx.sh >/var/log/lego-renew.log 2>&1'
) | doas crontab -
