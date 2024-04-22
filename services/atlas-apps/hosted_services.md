# Atlas-hosted Systems in Use at PUL

The library has two systems hosted by Atlas: Aeon and Ares. We maintain three client machines to connect to these systems (and also to Illiad, which is hosted locally). For historical reasons these machine names reference Ares only, though all three Atlas systems products (Ares, Aeon, and [locally-hosted ILLiad](illiad.md)) have clients installed on them. These Atlas client machines are:

* lib-ares-cli1
* lib-ares-cli2
* lib-ares-cli3

See below for details on each hosted system.

## Aeon

### Purpose of Aeon
Aeon manages requests from patrons to use Special Collections materials in our restricted access reading rooms. Patrons can place requests directly in the Aeon web interface, but most requests come from integrations in the Library Catalog and in Pulfalight that route requests into the Aeon web interface.

### Aeon Product Owners
Our Special Collections staff who are responsible for supervising the use of restricted materials are the primary users of Aeon.

### Web Interface for Aeon
Aeon has a web interface that Atlas hosts for us. The current web interface code lives in a [Github repo](https://github.com/AtlasSystems/hosting-aeon-princeton). You need to request access to this via Atlas support. [Documentation](https://support.atlas-sys.com/hc/en-us/articles/4407504126611-Editing-Atlas-Hosted-Aeon-Web-Pages-in-GitHub) on the workflow to allow PUL users to submit updates is available. The web interface is integrated via Shibboleth for Princeton net ID holders and offers a self-managed username and password for SC users outside of Princeton who want to request SC items. 

### Staff Clients for Aeon
Staff clients are part of a Windows image. These are typically updated when Aeon has a new release or Atlas releases a security patch for Aeon. Staff users have a unique username/password stored in Aeon itself that they use to sign to the client. 

* The "Aeon" staff client allows staff to process requests. 
* "Staff Manager" allows you to create and manage existing staff client users. Including resetting passwords. 
* "Customization Manager" contains configuration settings for Aeon as well as configuration settings for server-side add-ons.

### Printing
Aeon staff clients print out various labels that are used in the Reading Room circulation process. A description is available in the [Aeon print documentation](https://support.atlas-sys.com/hc/en-us/articles/360011920833-Aeon-Default-Print-Templates). All clients have a path that they resolve set in the Aeon Customization Manager key "PrintDocumentsPath". Currently that is set to a file share on the lib-aeon.princeton.edu server. 

### Maintenance for Aeon
Although the server-side of Aeon is hosted, we maintain the client machines. Sometimes new software releases include updates to the client. You can review recent [releases here](https://support.atlas-sys.com/hc/en-us/articles/360011818834-Aeon-Release-Schedule).

#### Add-ons for Aeon
Aeon has an add-on architecture implemented in [LUA](https://www.lua.org/). Add-ons can be added at the individual client level or on the server. Client add-ons are incorporated into our Aeon client install in our staff workstation image and replicated on every client instance. Server add-ons are installed in a single place within the Aeon server application. See available [add-ons](https://atlas-sys.atlassian.net/wiki/spaces/ILLiadAddons/pages/3149603/Aeon+Addon+Directory).

#### Aeon Server Add-ons we use.
* [ReCAP Add-On](https://github.com/PrincetonUniversityLibrary/aeon_scsb_addon) - Facilitates transactions with SCSB

### Getting Support for Aeon
General documentation is available on the [Atlas website](https://support.atlas-sys.com/hc/en-us/categories/360000720853-Aeon). Support can be requested through the [Atlas Web Portal](https://support.atlas-sys.com/hc/en-us/requests/new)

## Accessing the Aeon client
The Aeon client is not connected to SSO - all staff members need separate login credentials. The Aeon client can only be reached from PUL Windows machines that have been added to the allow list for the Atlas hosting environment. IT staff who need to troubleshoot or manage accounts, but do not regularly work on Windows machines, must use Windows Remote Desktop to connect to one of the desktop Windows machines listed below. Once connected, staff must use actual Aeon client staff credentials to login into one of the Atlas client machines: 

* lib-ares-cli1
* lib-ares-cli2
* lib-ares-cli3

## Ares

### Purpose of Ares
Ares is used to manage reading lists of Library materials. Students enrolled in courses access Ares-managed reading lists through an integration with the campus Canvas application. Faculty and other University staff involved in supporting those courses use Ares within Canvas to add new materials to course reading lists. Library staff also add items to reading lists on request using the Ares staff client. Review recent [releases](https://support.atlas-sys.com/hc/en-us/articles/360011824074-Ares-Release-Schedule). 

The materials in the reading lists primarily link to library electronic content hosting on our vendor resources but they do include links to print materials in the Library Catalog, digitized content in Figgy, as well as materials in Finding Aids. They also contain links to digitized videos stored in the [Video Reserves application](https://github.com/PrincetonUniversityLibrary/video_reserves). 

### Ares Product Owners
Our Resource Sharing staff are the primary staff users of Ares. Refer any functional questions about the application to them.

### Web Interface for Ares
Ares has a web interface that Atlas hosts for us. The current web interface code in a [Github repo](https://github.com/AtlasSystems/hosting-ares-princeton). You need to request access to this via Atlas support. [Documentation](https://support.atlas-sys.com/hc/en-us/articles/4407504126611-Editing-Atlas-Hosted-Aeon-Web-Pages-in-GitHub) on the workflow to allow PUL users to submit updates is available. Students, Faculty, or University staff who use Ares do not log directly into the Ares web interface but rather interact with it through the Canvas integration. A limited number of course auditors who do not have Princeton net IDs need access to Ares. Library Resource Sharing staff handle the creation of accounts these users in the Ares web interface. 

### Ares Integration with Canvas
[Canvas](https://princeton.instructure.com/) is Princeton's Learning Management System (LMS). Reading lists prepared for courses each semester are delivered through an integration with Ares that uses the [Learning Technology Interoperability](https://support.atlas-sys.com/hc/en-us/articles/5659979374483-Integrating-Ares-and-Canvas-with-LTI-1-3) (LTI) standard. Each active course that has a reading list created in Ares displays that list by linking the course identifier in Canvas with the course identifier in Ares. There is an example test course in the system under "Library Sandbox" that can be utilized for testing Ares features in canvas. Only users who have successfully authenticated in canvas are able to see Ares contact. Ares content is available under the "Reserves" link in the individual course menu options. Ask the resource sharing staff about utilizing the [test reading list](https://princeton.instructure.com/courses/254/external_tools/399) if needed. 

## Add-ons for Ares
Ares has an add-on architecture implemented in [LUA](https://www.lua.org/). Add-ons can be added at the individual client level or on the server. Client add-ons are incorporated into our Ares client install in our staff workstation image and replicated on every client instance. Server add-ons are installed in a single place within the Ares server application. See available [add-ons](https://atlas-sys.atlassian.net/wiki/spaces/ILLiadAddons/pages/3149456/Ares+Addon+Directory).

## Staff Clients for Ares
Staff clients are part of a Windows image. These are typically updated when Ares has a new release or Atlas releases a security patch for Ares. Staff users have a unique username/password stored in Ares itself that they use to sign to the client. 

* The "Ares" staff client allows staff to process requests.  
* "Staff Manager" allows you to create and manage existing staff client users. Including reseting passwords. 
* "Customization Manager" contains configuration settings for Ares as well as configuration settings for server-side add-ons.

### Getting Support for Ares
General documentation is available on the [Atlas website](https://support.atlas-sys.com/hc/en-us/categories/360000716834-Ares). Support can be requested through the [Atlas Web Portal](https://support.atlas-sys.com/hc/en-us/requests/new)

## Accessing the Ares client
The Ares client is not connected to SSO - all staff members need separate login credentials. The Ares client can only be reached from PUL Windows machines that have been added to the allow list for the Atlas hosting environment. IT staff who need to troubleshoot or manage accounts, but do not regularly work on Windows machines, must use Windows Remote Desktop to connect to one of the desktop Windows machines listed below. Once connected, staff must use actual Ares client staff credentials to login into one of the Atlas client machines:

* lib-ares-cli1
* lib-ares-cli2
* lib-ares-cli3