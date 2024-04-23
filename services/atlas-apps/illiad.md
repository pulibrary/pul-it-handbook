# ILLiad
ILLiad software is written and maintained by Atlas Systems. Our implementation is hosted locally at PUL. The software runs at lib-illsql.princeton.edu. We also maintain three client machines to connect to ILLiad (and also to [Ares and Aeon](hosted_service.md), which are hosted by Atlas). For historical reasons these machine names reference Ares only, though all three Atlas systems products (Ares, Aeon, and ILLiad) have clients installed on them. These Atlas client machines are:

* lib-ares-cli1
* lib-ares-cli2
* lib-ares-cli3

## Purpose
ILLiad software supports our Interlibrary Loan and Article Express services. Our resource sharing and branch library staff that support these services use a Windows client to process patron requests. Patrons place requests directly in the Illiad web interface the service provides. The Library Catalog also places InterLibrary Loan and Article Express requests via ILLiad's API. Review recent [releases](https://support.atlas-sys.com/hc/en-us/sections/360002485474-Release-Notes). Releases are infrequent. Only two between 2020 and 2023. 

## Web Interface
Web interface [landing page](https://lib-illiad.princeton.edu/illiad/). The login is currently authenticated via LDAP. The web interface code is stored on [Github](https://github.com/pulibrary/illiad). Please note it's still possible edit these templates directly on the server so the code in the running application may diverge. 

## Server
ILLiad has SQL Server database and application server installation that includes the web application and server Windows services that run on the server that support the application's processing of requests. The database, ILLiad web application and the Illiad server-side application both live on the server lib-illsql.princeton.edu. There is an alias "lib-illiad.princeton.edu" that is attached to that server and used for the web application. 

### Troubleshooting the server
When things go wrong on the server you must connect to lib-illsql.princeton.edu with an account with administrative rights. You then usually need to do one of two things: either restart the IIS Manager or restart the ILLiad System Manager Service.

#### Restarting the IIS Manager
1. Connect to lib-illsql.princeton.edu with a PRINCETON domain account that has admin rights on the server.
2. Click on the Windows icon and select the search icon.
3. Search for Internet Information Services (IIS) Manager. 
4. Right-click the IIS Manager and select "run as administrator".
5. Browse to the "Default Web Site"
6. Restart the IIS Service by selecting restart under "Manage Website section".

##### Restarting the ILLiad System Manager Service
1. Connect to lib-illsql.princeton.edu with a PRINCETON domain account that has admin rights on the server.
2. Click on the Windows icon and select the search icon.
3. Search for Services. 
4. Right-click on Services and select "run as administrator".
5. Browse to the services starting with "Illiad"
6. Select the "Illiad System Manager" and restart it. 

## Staff Clients
Staff clients are part of a Windows image. When ILLiad has a new release, we must download new images and apply them to the client-side system manually. Staff users have a unique username/password stored in Illiad itself that they use to sign in to one of the three ILLiad clients: 

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

### Getting Support for ILLiad
Support for ILLiad is through OCLC. You can review the [documentation](https://help.oclc.org/Resource_Sharing/ILLiad) or [request support](https://help.oclc.org/Librarian_Toolbox/Contact_OCLC_Support). If OCLC needs to, it can escalate issue to Atlas Systems.

### Using the client for troubleshooting/account management
The ILLiad client is not connected to SSO - all staff members need separate login credentials. IT staff who need to troubleshoot or manage accounts, but do not regularly work on Windows machines, must use Windows Remote Desktop to connect to one of the desktop Windows machines listed below. Once connected, staff must use actual ILLiad client staff credentials to login into one of the Atlas client machines:

* lib-ares-cli1
* lib-ares-cli2
* lib-ares-cli3


