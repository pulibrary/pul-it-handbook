### Creating a CSR with SAN

* create a file named `new_hostname_san.cnf` with the following

```
[ req ]
default_bits       = 2048
distinguished_name = req_distinguished_name
req_extensions     = req_ext
[ req_distinguished_name ]
countryName                 = Country Name (2 letter code)
stateOrProvinceName         = State or Province Name (full name)
localityName               = Locality Name (eg, city)
organizationName           = Organization Name (eg, company)
commonName                 = Common Name (e.g. server FQDN or YOUR name)
[ req_ext ]
subjectAltName = @alt_names
[alt_names]
DNS.1   = alt.newhostname.edu
DNS.2   = alt.services.newhostname.edu
```

* generate the certificate you will provide to
  [OIT](https://princeton.service-now.com/snap?sys_id=c85dafbd4f752e0018ddd48e5210c7e4&id=sc_cat_item&table=sc_cat_item)
  with the following command

```
openssl req -out new_hostname_edu_cert.csr -newkey rsa:2048 -nodes -keyout
new_hostname_edu_priv.key -config new_hostname_san.cnf
```

The step :point_up_2: above will create `new_hostname_edu_cert.csr` and
`new_hostname_edu_priv.key` in your current directory.

* You will need to submit a cat'ed copy of `new_hostname_edu_cert.csr` to OIT at
  the link above.

* Before submitting it you can check to see if your CSR contains the SAN you
  specified in the `new_hostname_san.cnf` file by doing.

```
openssl req -noout -text -in new_hostname_edu_cert.csr | grep DNS
```
