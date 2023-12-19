# ILLiad 

## Purpose 
ILLiad is the software that supports our Interlibrary Loan and Article Express services. Our resource sharing and branch library staff that support these services use a Widnows client to process patrons requests. Patrons place requests directly in the Illiad web interface the service provides. The Library Catalog also places InterLibrary Loan and Article Express requests via ILLiad's API. Review recent [releases](https://support.atlas-sys.com/hc/en-us/sections/360002485474-Release-Notes). Releases are infrequent. Only two in the last four years. 

## Web Interface
Web interface [landing page](https://lib-illiad.princeton.edu/illiad/). The login is currently authenticated via LDAP. The web interface code is stored on [Github](https://github.com/pulibrary/illiad). Please note it's still possible edit these templates directly on the server so the code in the running application may diverge. 

## Server
ILLiad has SQL Server database and application server installation that includes the web application and server Windows services that run on the server that support the application's processing of requests. The database, ILLiad web application and the Illiad server-side application both live on the server lib-illsql.princeton.edu. There is an alias "lib-illiad.princeton.edu" that is attached to that server and used for the web application. 

### Troubleshooting the server. 
When things go wrong on the server you usually need to do to do one of two things after connecting with an account with administration rights on the lib-illsql.princeton.edu server. 

#### Restart the IIS Manager

1. Connect to lib-illsql.princeton.edu with an PRINCETON domain account that has admin rights on the server
2. Click on the Windows icon and select the search icon.
3. Search for Internet Information Services (IIS) Manager. 
4. Right-click the IIS Manager and select "run as administrator".
5. Browse to the "Default Web Site"
6. Restart the IIS Service by selecting restart under "Manage Website section".


##### Restart the ILLiad System Manager Service
1. Connect to lib-illsql.princeton.edu with an PRINCETON domain account that has admin rights on the server
2. Click on the Windows icon and select the search icon.
3. Search for Services. 
4. Right-click on Services and select "run as administrator".
5. Browse to the services starting with "Illiad"
6. Select the "Illiad System Manager" and restart it. 


## Staff Clients
Staff clients are part of a Windows image. These are typically updated when ILLiad has a new release. The ILLiad has three different clients. Staff users have a unique username/password stored in Illiad itself that they use to sign to the client. 

* The "ILLiad" staff client users sign in to do requests. 
* "Staff Manager" allows you to create and manage existing staff client users. Including reseting passwords. 
* "Customization Manager" contains configuration settings for ILLiad as well as configuration settings for server-side add-ons.

## Add-ons
ILLiad has an add-on architecture implemented in [LUA](https://www.lua.org/). Add-ons can be added at the individual client level or on the server. Client add-ons are incorporated into our illiad client install in our staff workstation image and replicated on every client instance. Server add-ons are installed in a single place within the ILLiad server application. See available [add-ons](https://atlas-sys.atlassian.net/wiki/spaces/ILLiadAddons/pages/3149543/ILLiad+Addon+Directory).

### Server Add-ons we use.
* [ReCAP Add-On](https://github.com/PrincetonUniversityLibrary/illiad_scsb_addon) - Facilitates transactions with SCSB
* ReShare Add-On Facilitates transactions with our ReShare system for borrowing and lending requests that are part of our Borrow Direct partnership. Check with PUL Resource Sharing for where to obtain the current version of this. 

### Client Add-ons we use
* [Alma NCIP](https://github.com/pulibrary/alma-ncip) - facilitates circulations transactions with Alma for both ILL borrowing and lending requests. 

### Using the client for troubleshooting/account management
We have several desktop machines that are available for remote desktop connection that will allow IT staff who don't use windows to utilize. Once connected you need actual illiad staff credentials to login into the various clients. 

* lib-ares-cli1
* lib-ares-cli2
* lib-ares-cli3


