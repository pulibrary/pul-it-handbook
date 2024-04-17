## 3rd tier / Systems Administration - hosted applications 

While some of our applications are hosted on-prem (on servers at Princeton), many are vendor-hosted in the cloud. There are many reasons for this, including ease of maintenance, security patching, and infrastructure/storage space. It simply depends on the application and service being provided. 

For those applications hosted in the cloud, we often manage the system (e.g. user accounts, settings, look & feel) through the system UI with admin access. The Operations team works with the following vendor-hosted platforms in this way. 

### Springshare

#### Purpose

Springshare (also collectively called LibApps) is a library-specific suite of applications meant to help librarians work with patrons efficiently and effectively. At PUL, we use the following LibApps in Springshare's suite: 

1. LibGuides: Springshare's content management system (CMS) that is primarily used for creating librarian-authored [research guides](https://libguides.princeton.edu/). LibGuides also hosts the library's [A-Z Databases List](https://libguides.princeton.edu/az.php), or our collection of electronic resources available to the Princeton community. 

2. LibCal: Springshare's system for event and space management. At PUL, we use [LibCal](https://libcal.princeton.edu) to manage: public-facing and staff-facing events/workshops; patron appointments with library staff; building and service desk hours; public space bookings (e.g. group study rooms) and internal space bookings (e.g. library classrooms); and equipment lending. 

3. LibAnswers: Springshare's patron communication system. We use LibAnswers to receive and respond to patron emails (via email queues), communicate in real-time with patrons via Chat, record our public services desk statistics, and record frequently asked questions and answers. 

4. LibInsight: Springshare's data collection and analytics platform. We use LibInsight to track information services statistics, such as instruction and consultation statistics. 

5. LibWizard: Springshare's platform to create online forms, surveys, quizzes, and interactive tutorials. 

#### Web Interface

The web interface for LibApps is https://princeton.libapps.com. Users authenticate through Princeton CAS credentials. Users are added at the LibApp level (e.g. LibGuides) but once a user is added to one app, their account can be pulled in to any app across the system. User levels vary by app but generally include the following: 
- Regular users: Those who can interact with the system as editors within an app without access to settings.
- Admins: Those who have full access to an app's settings.
- Inactive: Those who are not active in the system (due to not working at PUL, for example) but whose account data we want to retain. 

#### Documentation 

Our documentation for Springshare, which includes tutorials, past workshop recordings, newsletters, and a changelog, largely lives on [Confluence](https://pul-confluence.atlassian.net/wiki/), since most library staff access and use this wiki for internal information sharing.

Springshare hosts a wealth of documentation on their site, including access to vendor webinars, which users can access when logged into our PUL system by choosing Help from the menu in each App. 

While most changes to Springshare's "look & feel" can be managed from the UI, we have modified certain HTML and CSS files that are tracked in our [libapps GitHub repo](https://github.com/pulibrary/libapps). Anyone can create a PR to this repo to modify and track files. 

#### Getting Support

The Operations team currently supports LibApps. Users can get help by emailing lsupport@princeton.edu and someone from Operations will get back to you. Users can also submit a Support ticket to Springshare directly from the documentation site; however, usually these requests are brought to lsupport's attention first, and then Springshare admins escalate to Springshare Support. 

### Confluence 

#### Purpose

Confluence is a wiki and web-based collaboration and content management tool and, as such, a virtual space to create, organize, and discuss work as a team. Confluence is organized into Spaces, or project areas, and at PUL, we have Spaces for things like committee work, department-specific spaces, and cross-library projects. Spaces consist of pages, where content lives and can be edited. By default, Confluence spaces are publicly available to anyone who has the link to our Confluence site; however, we have the ability to make spaces private so that only PUL users can view them when signed in or, more restrictive, only certain users within PUL can view them when signed in. Confluence authenticates with SSO through an integration with Atlassian Access, which OIT manages for all Atlassian products across campus. 

#### Documentation

PUL-specific documentation on Confluence can be found in the [Princeton University Library](https://pul-confluence.atlassian.net/wiki/spaces/PUL/overview) space as well as in the [Best Practices](https://pul-confluence.atlassian.net/wiki/spaces/BP/overview) space. We have previously recorded workshops and materials, such as slides or exercise files, linked from within the PUL space on a [Trainings](https://pul-confluence.atlassian.net/wiki/spaces/PUL/pages/1769716/Training+Sessions) page.

Atlassian has robust Confluence documentation on their site, including video tutorials and training. Confluence is often a training topic on various learning platforms, such as LinkedIn Learning and Pluralsight. 

#### Getting Support

The Operations team currently supports Confluence. Users can get help by emailing lsupport@princeton.edu and someone from Operations will get back to you. Only those admins dedicated from Operations can submit tickets directly through Atlassian's interface using admin account sign in. 

### Atlas Systems Applications

The following applcations are hosted by Atlas Systems. These services are described in more detail in the [hosted services](https://github.com/pulibrary/pul-it-handbook/blob/main/services/hosted_services.md) section of this handbook: 
- Aeon: Used to manage requests from users to utilize our Special Collections materials in our restricted access reading rooms.
- Ares: Used to manage course-related reading lists of Library materials through an integration with the campus learning management system (LMS), Canvas.
- ILLiad: Software that supports our Interlibrary Loan and Article Express services (resource sharing).

