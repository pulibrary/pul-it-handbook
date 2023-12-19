# Hosted Systems in Use at PUL

## Infolinx/Tigris

### Purpose
Records management software used by both University staff and Library staff in the Library's Records Management. Anne-Marie Phillips is the primary contact for the software. The software product name for this is "Infolinx". [Further information](https://aisww.com/infolinx/). Our implementation is called Tigris.

### Access
Web [tigris login](https://tigris.princeton.edu). Tigris is integrated with our campus IDP. Access to it is governed by membership in certain Active Directory groups established specifically for tigris. These need to be managed via OIT's [web tools portal](https://tools.princeton.edu). 

Groups defined
* TIGRIS Administrator
* TIGRIS Legal User
* TIGRIS Read Write
* TIGRIS Storage User
* TIGRIS User  

### Renewing the SSL Cert
Tigris.princeton.edu has an A DNS record pointing to: princetonuniversity.cloudapp.net. When the certificate is expiring a new one needs to be emailed to support for tigris at: support@gimmal.com. Must be submitted as a .pfx file. 

### Getting Tigris Support
General application support questions should be sent via the vendor [web portal](https://aisww.com/support/). 

## Aeon

### Purpose 
 Aeon is used to manage requests from users to utilize our Special Collections materials our restricted access reading rooms. Patrons place requests directly in the Illiad web interface the service provides. The Library Catalog and Pulfalight also directly route requests in the Aeon web interface.. Review recent [releases](https://support.atlas-sys.com/hc/en-us/articles/360011818834-Aeon-Release-Schedule).

### Product Owners
Our Special Collections staff responsible for supervising the use of requested materials are the primary users of Aeon. 

### Web Interface
Atlas hosts the web interface code in a [Github repo](https://github.com/AtlasSystems/hosting-aeon-princeton). You need to request access to this via Atlas support. [Documentation](https://support.atlas-sys.com/hc/en-us/articles/4407504126611-Editing-Atlas-Hosted-Aeon-Web-Pages-in-GitHub) on the workflow to allow PUL users to submit updates is available. The web interface is integrated via Shibboleth for Princeton net ID holders and offers a self-managed username and password for SC users outside of Princeton who want to request SC items. 

## Staff Clients
Staff clients are part of a Windows image. These are typically updated when Aeon has a new release or Atlas releases a security patch. Staff users have a unique username/password stored in Aeon itself that they use to sign to the client. 

* The "Aeon" staff client allows staff to process requests. 
* "Staff Manager" allows you to create and manage existing staff client users. Including reseting passwords. 
* "Customization Manager" contains configuration settings for ILLiad as well as configuration settings for server-side add-ons.

## Printing
Aeon staff clients print out various labels that are used in the Reading Room circulation process. A description is available in the [Aeon print documentation](https://support.atlas-sys.com/hc/en-us/articles/360011920833-Aeon-Default-Print-Templates). All clients have a path that they resolve set in the Aeon Customization Manager key "PrintDocumentsPath". Currently that is set to a file share on the lib-aeon.princeton.edu server. 

## Add-ons
Aeon has an add-on architecture implemented in [LUA](https://www.lua.org/). Add-ons can be added at the individual client level or on the server. Client add-ons are incorporated into our Aeon client install in our staff workstation image and replicated on every client instance. Server add-ons are installed in a single place within the ILLiad server application. See available [add-ons](https://atlas-sys.atlassian.net/wiki/spaces/ILLiadAddons/pages/3149603/Aeon+Addon+Directory).

### Server Add-ons we use.
* [ReCAP Add-On](https://github.com/PrincetonUniversityLibrary/aeon_scsb_addon) - Facilitates transactions with SCSB

### Getting Support 
General documentation is available on the [Atlas website](https://support.atlas-sys.com/hc/en-us/categories/360000720853-Aeon). Support can be requested through the [Atlas Web Portal](https://support.atlas-sys.com/hc/en-us/requests/new)

## Using the client for troubleshooting/account management
The Aeon client can only be reached from PUL Windows machines. IT staff who do not regularly work on Windows machines must use Windows Remote Desktop to connect to one of the desktop Windows machines listed below. Once connected, staff must use actual Aeon client staff credentials to login into the various clients. 

* lib-ares-cli1
* lib-ares-cli2
* lib-ares-cli3

## ARES
Ares is used manage reading lists of Library materials. Students enrolled in course via reading lists and follow links to the full content of Library materials from those lists. Faculty and other staff involved in supporting those course use Ares to add new materials to course reading lists. Library staff also add items to reading lists on request. Review recent [releases](https://support.atlas-sys.com/hc/en-us/articles/360011824074-Ares-Release-Schedule). 

The materials in these lists primarily link to library electronic content hosting on our vendor resourses but they do include links to materials in the Library Catalog, Figgy and Finding Aids. They also contain links to digitized videos stored in the [Video Reserves application](https://github.com/PrincetonUniversityLibrary/video_reserves). 

### Product Owners
Our Resource Sharing staff are the primary staff users of Ares. Refer any functional questions about the application to them. 

### Web Interface
Atlas hosts the web interface code in a [Github repot](https://github.com/AtlasSystems/hosting-ares-princeton). You need to request access to this via Atlas support. [Documentation](https://support.atlas-sys.com/hc/en-us/articles/4407504126611-Editing-Atlas-Hosted-Aeon-Web-Pages-in-GitHub) on the workflow to allow PUL users to submit updates is available. Students, Faculty, or University staff who support the management of course reading lists typically do not log into the Ares web interface but rather interact with it through the Canvas integration. Resource sharing handle the creation of accounts to use the web interface directly by request on for those auditing courses who do not posses a Princeton net ID. 

### Integration with Canvas
[Canvas](https://princeton.instructure.com/) is Princeton's Learning Management System (LMS). Reading lists prepared for courses each semester are delivered through an integration with Ares supported by the [Learning Technology Interoperability](https://support.atlas-sys.com/hc/en-us/articles/5659979374483-Integrating-Ares-and-Canvas-with-LTI-1-3) (LTI) standard. Each active course that has a reading list created in Ares displays that list by linking the course identifier in Canvas with the course identifier in Aeon. There is an example test course in the system under "Library Sandbox" that can be utilized for testing Ares features in canvas. Only users who have successfully authenticated in canvas are able to see Ares contact. Ares content is available under the "Reserves" link in the individual course menu options. Ask the resource sharing staff about utilizing the [test reading list](https://princeton.instructure.com/courses/254/external_tools/399) if needed. 

## Add-ons
Aeon has an add-on architecture implemented in [LUA](https://www.lua.org/). Add-ons can be added at the individual client level or on the server. Client add-ons are incorporated into our Aeon client install in our staff workstation image and replicated on every client instance. Server add-ons are installed in a single place within the ILLiad server application. See available [add-ons](https://atlas-sys.atlassian.net/wiki/spaces/ILLiadAddons/pages/3149456/Ares+Addon+Directory).

## Staff Clients
Staff clients are part of a Windows image. These are typically updated when Ares has a new release or Atlas releases a security patch. Staff users have a unique username/password stored in Aeon itself that they use to sign to the client. 

* The "Ares" staff client allows staff to process requests.  
* "Staff Manager" allows you to create and manage existing staff client users. Including reseting passwords. 
* "Customization Manager" contains configuration settings for ILLiad as well as configuration settings for server-side add-ons.


### Getting Support 
General documentation is available on the [Atlas website](https://support.atlas-sys.com/hc/en-us/categories/360000716834-Ares). Support can be requested through the [Atlas Web Portal](https://support.atlas-sys.com/hc/en-us/requests/new)

## Using the client for troubleshooting/account management
We have several desktop machines that are available for remote desktop connection that will allow IT staff who don't use windows to utilize. Once connected you need to use actual Ares client staff credentials to login into the various clients. 

* lib-ares-cli1
* lib-ares-cli2
* lib-ares-cli3