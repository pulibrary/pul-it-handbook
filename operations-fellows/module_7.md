## 3rd tier / Systems Administration - hosted applications 

While some of our applications are hosted on-prem (on servers at Princeton), many are vendor-hosted in the cloud. There are many reasons for this, including ease of maintenance, security patching, and infrastructure/storage space. It simply depends on the application and service being provided. 

For those applications hosted in the cloud, we often manage the system (e.g. user accounts, settings, look & feel) through the user interface (UI) with admin access. The Operations team works with the following vendor-hosted platforms in this way. 

### Springshare

#### Purpose

[Springshare](https://springshare.com/index.html) (also collectively called LibApps) is a suite of applications meant to help librarians work with patrons efficiently and effectively. At PUL, we use the following LibApps in Springshare's suite: 

1. [LibGuides](https://springshare.com/libguides/): Springshare's content management system (CMS) that is primarily used for creating librarian-authored [research guides](https://libguides.princeton.edu/). LibGuides also hosts the library's [A-Z Databases List](https://libguides.princeton.edu/az.php), or our collection of databases and electronic resources available to the Princeton community. 

2. [LibCal](https://springshare.com/libcal/): Springshare's system for event and space management. At PUL, we use [LibCal](https://libcal.princeton.edu) to manage: public-facing and staff-facing events/workshops; patron appointments with library staff; building and service desk hours; public space bookings (e.g. group study rooms) and internal space bookings (e.g. library classrooms); and equipment lending. 

3. [LibAnswers](https://springshare.com/libanswers/): Springshare's patron communication system. We use [LibAnswers](https://faq.library.princeton.edu/) to receive and respond to patron emails (via email queues), communicate in real-time with patrons via Chat, record our public services desk statistics, and record frequently asked questions and answers. 

4. [LibInsight](https://springshare.com/libinsight/): Springshare's data collection and analytics platform. We use LibInsight to track information services statistics, such as instruction and consultation statistics. 

5. [LibWizard](https://springshare.com/libwizard/): Springshare's platform to create online forms, surveys, quizzes, and interactive tutorials. 

#### Web Interface

The web interface for LibApps is https://princeton.libapps.com. Users authenticate through Princeton CAS credentials. Users are added at the individual LibApp level (e.g. LibGuides); however, once a user is added to one app, their account can be pulled in to any app across the system. User levels vary by app but generally include the following: 

- Regular users: Those who can interact with the system as editors within an app without access to overall settings.
- Admins: Those who have full access to an app and its settings.
- Inactive: Those who are not active in the system (due to not working at PUL any longer, for example) but whose account data needs to be retained. 

#### Documentation 

Our documentation for Springshare, which includes tutorials, past workshop recordings, newsletters, and a changelog, mainly lives on [Confluence](https://pul-confluence.atlassian.net/wiki/), since most librarians access and use this wiki for internal information sharing.

Springshare hosts a wealth of documentation on their site, including access to vendor webinars, which users can access when logged into our PUL system by choosing "Help" from the top navigation menu within each App. 

While most changes to Springshare's "look & feel" can be managed from the UI, we have modified certain HTML and CSS files that are tracked in our [libapps GitHub repo](https://github.com/pulibrary/libapps). Anyone can create a PR to this repo to modify and track files. 

#### Getting Support

The Operations team currently supports LibApps. Users can get help by emailing lsupport@princeton.edu and someone from Operations will respond. Users can also submit a Support ticket to Springshare directly from the documentation site; however, usually these requests are brought to L-Support's attention first, and then Springshare admins escalate to Springshare Support. 

We also use a Slack channel for Springshare-related questions, updates, highlighted features and use cases, and general communication that anyone is welcome to join: #springshare-faq. 

### Confluence 

#### Purpose

[Confluence](https://www.atlassian.com/software/confluence) is a wiki and web-based collaboration and content management tool and, as such, a virtual space to create, organize, and discuss work as a team. Confluence is organized into Spaces, or project areas; at PUL, we have Spaces for things like committee work, department-specific projects, and cross-library teams. Spaces consist of Pages, where content lives and can be edited. By default, Confluence Spaces are publicly available to anyone who has the link to our [PUL Confluence site](https://pul-confluence.atlassian.net/wiki/); however, we have the ability to make Spaces private so that only PUL users can view them when signed in or, more restrictively, only certain users within PUL can view them when signed in. Confluence authenticates with the campus SSO (Single Sign-On) through an integration with Atlassian Access, a platform that OIT manages for all Atlassian products and users across campus. 

#### Documentation

PUL-specific documentation on Confluence can be found in the [Princeton University Library](https://pul-confluence.atlassian.net/wiki/spaces/PUL/overview) Space as well as in the [Best Practices](https://pul-confluence.atlassian.net/wiki/spaces/BP/overview) Space. We have previously recorded workshops and materials, such as slides and exercise files, linked from within the PUL Space on a [Trainings](https://pul-confluence.atlassian.net/wiki/spaces/PUL/pages/1769716/Training+Sessions) page.

Atlassian provides robust [Confluence documentation](https://support.atlassian.com/confluence-cloud/resources/), including video tutorials and training. Confluence is often a training topic on various learning platforms that we have access to as Princeton staff, such as [LinkedIn Learning](https://linkedinlearning.princeton.edu/) and [Pluralsight](https://www.pluralsight.com/). 

#### Getting Support

The Operations team currently supports Confluence. Users can get help by emailing lsupport@princeton.edu and someone from Operations will respond. Only those admins dedicated from Operations can submit tickets directly through Atlassian's support interface using an admin account sign in. 

### Drupal

#### Purpose

The [Library website](https://library.princeton.edu/) is hosted on Drupal, an open-source platform for building digital sites. We are moving from a Drupal 7 site, which the library currently hosts on-prem, to a Drupal 10 site through the campus Drupal instance, called Site Builder, that will be hosted by OIT's Web Development Services (WDS) unit. WDS is responsible for site maintenance and security patching; library staff in Operations, AUX, and DACS will have administrative access through the UI to manage content and user accounts. 

#### Documentation

WDS has prepared documentation that is both general to the Site Builder platform and that is specific to the Library's instance of Site Builder. The Drupal community at large is a robust one and many questions can be answered by exploring their own documentation and community forums. 

#### Support

Folks across Library IT teams are equipped to proved Drupal support; however, the best course of action is to email lsupport@princeton.edu, and your ticket will be triaged to the approrpiate person. Like other hosted systems we manage, the Drupal site admins have the ability to escalate a question or issue to WDS to receive support from their team. 

### Atlas Systems Applications

The following applcations are hosted by Atlas Systems. These services are described in more detail in the [hosted services](https://github.com/pulibrary/pul-it-handbook/blob/main/services/hosted_services.md) section of this handbook: 

- [Aeon](https://github.com/pulibrary/pul-it-handbook/blob/main/services/hosted_services.md#aeon): Used to manage requests from users to utilize our Special Collections materials in our restricted access reading rooms.
- [Ares](https://github.com/pulibrary/pul-it-handbook/blob/main/services/hosted_services.md#ares): Used to manage course-related reading lists of Library materials through an integration with the campus learning management system (LMS), Canvas.
- [ILLiad](https://github.com/pulibrary/pul-it-handbook/blob/main/services/illiad.md): Software that supports our Interlibrary Loan and Article Express services (resource sharing). Note that currently, ILLiad is still hosted on-prem through a Windows VM managed by the Operations team. We are actively pursuing moving this to an Atlas-hosted cloud solution.  
