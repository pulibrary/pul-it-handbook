# DataSpace

## Authentication for EZProxy

In order to authenticate over the SSH into the DataSpace, OAR, and Theses
servers, one must request and obtain separate, privileged \*NIX accounts from 
the Office of Information Technology using a ServiceNow @ Princeton (SN@P) 
request. Further, RSA SecureID soft tokens for this separate account with must 
also be requested.

Once these are in place, one should have set a PIN for the RSA soft token, along
with properly configured the mobile app. which randomly generates temporary
access codes.

One should attempt to authenticate into the server using
`ssh [my_privileged_account]@epoxy@princeton.edu`.  When attempting to 
authenticate, one will receive a prompt `Enter PASSCODE:`.  Please enter the RSA
 PIN followed immediately by your current temporary access code in order to gain
 access to the server.

## Authentication for DSpace Servers

Once on the EZProxy server, one should be granted access to multiple servers for
the following:
- DataSpace
  - `cisdr202l.princeton.edu`
  - `updatespace.princeton.edu`
- Thesis Central
  - `cisdrtc100l.aws.princeton.edu`
  - `cisdrtc200l.aws.princeton.edu`
- Waiver DB
  - `asoar301l.princeton.edu`
  - `asoar201l.princeton.edu`
- Open Access Repository (OAR)
  - `cisdr103l.Princeton.EDU`
  - `cisdr204l.Princeton.EDU`

Each one of these servers can only be accessed with the account `dspace` (e. g.
`ssh dspace@cisdr202l.princeton.edu`) from the EZProxy server.  The credentials
are shared using [LastPass](https://lastpass.com/), and may be requested from 
either [@jrgriffiniii](https://github.com/jrgriffiniii), 
[@kayiwa](https://github.com/kayiwa), or 
[@stephayers](https://github.com/stephayers).

