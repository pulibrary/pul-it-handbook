# DataSpace

## Authentication for EZProxy

In order to authenticate over the SSH into the DataSpace, OAR, and Theses
servers, one must request and obtain separate, privileged \*NIX accounts from the 
Office of Information Technology using a ServiceNow @ Princeton (SN@P) request.
 Further, RSA SecureID soft tokens for this separate account with must also be
requested.

Once these are in place, one should have set a PIN for the RSA soft token, along
with properly configured the mobile app. which randomly generates temporary
access codes.

One should attempt to authenticate into the server using
`ssh [my_privileged_account]@[ezproxy_server]`.  Please contact either
[@jrgriffiniii](https://github.com/jrgriffiniii), 
[@kayiwa](https://github.com/kayiwa), or 
[@stephayers](https://github.com/stephayers) for the EZProxy host name.  When 
attempting to authenticate, one will receive a prompt `Enter PASSCODE:`.  Please
enter the RSA PIN followed immediately by your current temporary access code in
order to gain access to the server.

## Authentication for DSpace Servers

Once on the EZProxy server, one should be granted access to multiple servers for
the following:
- DataSpace
- Thesis Central
- Waiver DB
- Open Access Repository (OAR)

Please contact any of the previously referenced persons for the hostnames of
those servers, as well as the credentials which are used to access the servers
over SSH.

