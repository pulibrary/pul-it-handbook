# DataSpace and the Open Access Repository

## Authentication using the EZProxy/Bastion Host

In order to authenticate over the SSH into the DataSpace, OAR, and Theses
servers, one must request and obtain separate, privileged \*NIX accounts from 
the Office of Information Technology (OIT) using a ServiceNow @ Princeton (SN@P) 
request. Further, RSA SecureID soft tokens for this separate account with must 
also be requested.

### Requesting a Service Account from OIT

Service accounts are provided exclusively from the OIT, and these must be
requested using the form at
https://princeton.service-now.com/service?id=sc_cat_item&sys_id=f44539ab4ff81640f56c0ad14210c77c.
 One must specify their own name in the `Sponsor` field, with `Library -
 Information Technology` as the `Department`.

The `Desired NetID` must be distinct from your current `NetID`, and while there
are no restrictions on the format, the pattern I have seen is `libvi[NETID]` for
these values.

`Does this account need UNIX` should be `yes`, while accounts should not be
visible in the `PU Home Directory Search`. Please use the normal NetID e-mail
address for the `Exchange e-mail box`.

The type of account needs to be `Elevated Access`, with a `Permanent` duration.
`No` should be specified for the AIS support question, and one should leave the 
`User of the account, if not sponsor` blank. Also, a description should be 
provided for the business case, such as the following:

```bash
Providing developer access to the DataSpace and Open Access Repository
applications for new member of Library Information Technology [TEAM MEMBER NAME]
 in their role as [ROLE NAME].
```

### Authenticating with the RSA Soft Token on the servers

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

