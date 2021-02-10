### Creating a TLS Certificate

1. Certicate Signing Request 

   1. One with no Subject Alternative Name (SAN)

      * Export an environment variable with the host name for later commands
        ```
        export NEW_HOST_NAME=<new host name>
        ```
      * create a file named `$NEW_HOST_NAME.cnf` with the following

        ```ini
        echo "[req]
        default_bits = 2048
        distinguished_name = dn
        prompt             = no
        [dn]
        C=\"US\"
        ST=\"New Jersey\"
        L=\"Princeton\"
        O=\"The Trustees of Princeton University\"
        OU="OIT"
        emailAddress=\"lsupport@princeton.edu\"
        CN=\"$NEW_HOST_NAME.princeton.edu\"" > $NEW_HOST_NAME.cnf
        ```

      * generate the certificate you will provide to
        [OIT](https://princeton.service-now.com/snap?sys_id=c85dafbd4f752e0018ddd48e5210c7e4&id=sc_cat_item&table=sc_cat_item)
        with the following command

        ```bash
        openssl req -out ${NEW_HOST_NAME}_princeton_edu.csr -newkey rsa:2048 -nodes -keyout ${NEW_HOST_NAME}_princeton_edu_priv.key -config ${NEW_HOST_NAME}.cnf
        ```

      The step :point_up_2: above will create `${NEW_HOST_NAME}_princeton_edu.csr` and
      `${NEW_HOST_NAME}_princeton_edu_priv.key` in your current directory.


   1. One with a Subject Alternative Name (SAN)
     
      * Export an environment variable with the host name for later commands
        ```
        export NEW_HOST_NAME=<new host name>
        ```   

      * create a file named `${NEW_HOSTNAME}_san.cnf` with the following

        ```ini
        echo "[ req ]
        default_bits       = 4096
        distinguished_name = dn
        req_extensions     = req_ext
        prompt             = no
        [ dn ]
        C=\"US\"
        ST=\"New Jersey\"
        L=\"Princeton\"
        O=\"The Trustees of Princeton University\"
        OU=\"OIT\"
        [ req_ext ]
        subjectAltName = @alt_names
        [alt_names]
        DNS.1   = \"${NEW_HOST_NAME}.princeton.edu\"
        DNS.2   = \"\"" > ${NEW_HOST_NAME}_san.cnf
        ```
      * edit the file to add your additional Alternative name

      * generate the certificate you will provide to
        [OIT](https://princeton.service-now.com/snap?sys_id=c85dafbd4f752e0018ddd48e5210c7e4&id=sc_cat_item&table=sc_cat_item)
        with the following command

        ```bash
        openssl req -out ${NEW_HOST_NAME}_princeton_edu.csr -newkey rsa:4096 -nodes -keyout
        ${NEW_HOST_NAME}_princeton_edu_priv.key -config ${NEW_HOST_NAME}_san.cnf
        ```

      The step :point_up_2: above will create `${NEW_HOST_NAME}_princeton_edu.csr` and
      `${NEW_HOST_NAME}_princeton_edu_priv.key` in your current directory.


1. Submit the Certicate request to OIT
  
   * (SKIP if not SAN) Before submitting it you can check to see if your CSR contains the SAN you
     specified in the `${NEW_HOST_NAME}_san.cnf` file by doing.

      ```bash
      openssl req -noout -text -in ${NEW_HOST_NAME}_princeton_edu.csr | grep DNS
      ```

    * to get a certificate you will provide a cat'ed copy to
      [OIT](https://princeton.service-now.com/snap?sys_id=c85dafbd4f752e0018ddd48e5210c7e4&id=sc_cat_item&table=sc_cat_item)
      with the following command

      ```
      cat ${NEW_HOST_NAME}_princeton_edu.csr
      ```

   * you will recieve a response via email within 24 hours

   * The response should be in sparate files, but it also can be returned as comments in the ticket.  If this is the case copy the comments in the ticket into the files before proceding to the next step

      * `vi ${NEW_HOST_NAME}_princeton_edu_cert.cer` and copy and paste including `-----BEGIN CERTIFICATE-----` to `-----END CERTIFICATE-----`
      * `vi ${NEW_HOST_NAME}_princeton_edu_interm.cer` and copy and paste the rest of the certificates marked as `X.509 Root/Intermediate(s)`.  This should have Multiple begin and end certificates, which should be included.

1. Creating the chained file from the data returned by OIT
    Concatenate the certificate and the intermediate to create a chained file with
      the contents of the cert and interm following:

      ```bash
      cat ${NEW_HOST_NAME}_princeton_edu_cert.cer ${NEW_HOST_NAME}_princeton_edu_interm.cer > ${NEW_HOST_NAME}_princeton_edu_chained.pem
      ```


1. Verify the certificates

    * Make sure the certificates match by running the following. (remembering to
      unencypt the private key)

    ```bash
    echo “--Certificate:” && openssl x509 -noout -modulus -in ${NEW_HOST_NAME}_princeton_edu_chained.pem && echo “--Key:” && openssl rsa -noout -modulus -in ${NEW_HOST_NAME}_princeton_edu_priv.key
    ```

    * Make sure the CN name matches ${NEW_HOST_NAME}_princeton_edu by running the
      following

    ```bash
    openssl x509 -in ${NEW_HOST_NAME}_princeton_edu_chained.pem -text
    ```

1. Adding generated certificates

    * Add the private key to `nginxplus/files/ssl/${NEW_HOST_NAME}_princeton_edu_priv.key`
    (remembering to encrypt it with ansible vault it)
    
      ```
      ansible-vault encrypt ${NEW_HOST_NAME}_princeton_edu_priv.key
      mv ${NEW_HOST_NAME}_princeton_edu_priv.key roles/nginxplus/files/ssl/
      ```

    * Also add the private key to Shared-SSLCerts directory of LastPass Enterprise

    * You will receive a confirmation email from OIT with the certificates and
      intermediate files.

    * add the resulting concatenated file to `nginxplus/files/ssl/`
    
      ```
      mv ${NEW_HOST_NAME}_princeton_edu_chained.pem roles/nginxplus/files/ssl/
      ```

