### Creating a TLS Certificate

1. Certicate Signing Request with no Subject Alternative Name (SAN)

* create a file named `new_hostname.cnf` with the following

```ini
[req]
default_bits = 2048
distinguished_name = dn
prompt             = no
[dn]
C="US"
ST="New Jersey"
L="Princeton"
O="The Trustees of Princeton University"
OU="OIT"
emailAddress="lsupport@princeton.edu"
CN="($new_hostname).princeton.edu"
```

* generate the certificate you will provide to
  [OIT](https://princeton.service-now.com/snap?sys_id=c85dafbd4f752e0018ddd48e5210c7e4&id=sc_cat_item&table=sc_cat_item)
  with the following command

```bash
openssl req -out ($new_hostname)_princeton_edu.csr -newkey rsa:2048 -nodes -keyout
($new_hostname)_princeton_edu_priv.key -config new_hostname.cnf
```

The step :point_up_2: above will create `($new_hostname)_princeton_edu.csr` and
`($new_hostname)_princeton_edu_priv.key` in your current directory.

* You will need to submit a cat'ed copy of `($new_hostname)_princeton_edu.csr` to OIT at
  the link above.


  1a. Creating a CSR with SAN

  * create a file named `new_hostname_san.cnf` with the following

  ```ini
  [ req ]
  default_bits       = 4096
  distinguished_name = dn
  req_extensions     = req_ext
  prompt             = no
  [ dn ]
  C="US"
  ST="New Jersey"
  L="Princeton"
  O="The Trustees of Princeton University"
  OU="OIT"
  [ req_ext ]
  subjectAltName = @alt_names
  [alt_names]
  DNS.1   = libservice.princeton.edu
  DNS.2   = service.princeton.edu
  DNS.3   = other.service.princeton.edu
  ```

  * generate the certificate you will provide to
    [OIT](https://princeton.service-now.com/snap?sys_id=c85dafbd4f752e0018ddd48e5210c7e4&id=sc_cat_item&table=sc_cat_item)
    with the following command

  ```bash
  openssl req -out ($new_hostname)_princeton_edu.csr -newkey rsa:4096 -nodes -keyout
  ($new_hostname)_princeton_edu_priv.key -config new_hostname_san.cnf
  ```

  The step :point_up_2: above will create `($new_hostname)_princeton_edu.csr` and
  `($new_hostname)_princeton_edu_priv.key` in your current directory.

  * You will need to submit a cat'ed copy of `new_hostname_edu.csr` to OIT at
    the link above.

  * Before submitting it you can check to see if your CSR contains the SAN you
    specified in the `new_hostname_san.cnf` file by doing.

  ```bash
  openssl req -noout -text -in ($new_hostname)_princeton_edu.csr | grep DNS
  ```

2. Adding generated certificates

* Add the private key to `nginxplus/files/ssl/($new_hostname)_princeton_edu_priv.key`
(remembering to vault it)

* Also add the private key to Shared-SSLCerts directory of LastPass Enterprise

* You will receive a confirmation email from OIT with the certificates and
  intermediate files.

* Concatenate the certificate and the intermediate to create a chained file with
  the contents of the cert and interm following:

```bash
cat ($new_hostname)_princeton_edu_cert.cer ($new_hostname)_princeton_edu_interm.cer >
($new_hostname)_princeton_edu_chained.pem
```

* add the resulting concatenated file to `nginxplus/files/ssl/`

3. Verify the certificates

* Make sure the certificates match by running the following. (remembering to
  unencypt the private key)

```bash
echo “--Certificate:” && openssl x509 -noout -modulus -in ($new_hostname)_princeton_edu_chained.pem && echo “--Key:” && openssl rsa -noout -modulus -in ($new_hostname)_princeton_edu_priv.key
```

* Make sure the CN name matches ($new_hostname)_princeton_edu by running the
  following

```bash
openssl x509 -in ($new_hostname)_princeton_edu_chained.pem -text
```
