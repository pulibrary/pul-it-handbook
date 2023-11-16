# ILLiad 

## Purpose 
ILLiad is the software that supports our Interlibrary Loan and Article Express services. Our resource sharing and branch library staff that support these services use a Widnows Desktop client to process patrons requests. Patrons place requests directly in the Illiad web interface the service provides. The Library Catalog also places InterLibrary Loan and Article Express requests via ILLiad's API. Recent releases described here: https://support.atlas-sys.com/hc/en-us/sections/360002485474-Release-Notes. Releases are infrequent. Only two in the last four years. 

## Web Interface
https://lib-illiad.princeton.edu/illiad/. The login is currently authenticated via LDAP. Github for the web interface code is https://github.com/pulibrary/illiad. Please note it's still possible edit these templates directly on the server so the code in the running application may diverge. 

## Server
ILLiad has SQL Server database and application server installation that includes the web application and server Windows services that run on the server that support the application's processing of requests. The web application and the server both live on lib-illsql.princeton.edu. There is an alias lib-illiad.princeton.edu that is used for the web application. 

### Troubleshooting the server. 
When things go wrong on teh server you usually need to do to do one of two things after connecting with an account with administration rights on the lib-illsql.princeton.edu server. 

1. Restart the IIS Service
2. Restart the ILLiad System Manager Service


## Staff Clients
Staff clients are part of a Windows image. These are typically updated when ILLiad has a new release. ILLiad has three different clients. Staff users have an unique username/password stored in Illiad itself that they use to sign to the client. 

* The "ILLiad" staff client users sign in to do requests. 
* "Staff Manager" allows you to create and manage existing staff client users. Including reseting passwords. 
* "Customization Manager" contains configuration settings for ILLiad as well as configuration settings for server-side add-ons.

## Add-ons
ILLiad has an add-on architecture written lua. Add-ons can be added at the individual client level or on the server. Client add-ons are incorporated into our illiad client install in our staff workstation image. https://atlas-sys.atlassian.net/wiki/spaces/ILLiadAddons/pages/3149543/ILLiad+Addon+Directory

### Server Add-ons we use.
* ReCAP Add-On - Facilitates transactions with SCSB - https://github.com/PrincetonUniversityLibrary/illiad_scsb_addon
* ReShare Add-On Facilitates transactions with our ReShare system

### Client Add-ons we use
* Alma - pushes ill loan requests into Alma - https://github.com/pulibrary/alma-ncip 

### Using the client for troubleshooting/account management
We have several desktop machines that are available for remote desktop connection that will allow IT staff who don't use windows to utilize. Once connected you need actual illiad staff credentials to login into the various clients. 

* lib-ares-cli1
* lib-ares-cli2
* lib-ares-cli3


