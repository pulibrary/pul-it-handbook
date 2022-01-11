# Shibboleth

[Shibboleth](https://en.wikipedia.org/wiki/Shibboleth_(software)), the software behind Princeton's central authentication service, is a widely used single sign on solution. It is favored by libraries and universities because it is open source and it prioritizes security and privacy. A shibboleth service consists of a central "Identity Provider" (IdP) and many "Service Provider" (SP) endpoints. Princeton's IdP is maintained by OIT.

Most of the time, especially for rails applications, we can authenticate to Princeton's central Shibboleth IdP system via [CAS](cas.md), a middleware system that makes this process much easier. However, some java based systems like DSpace and Vireo still require an actual [Shibboleth SP](https://shibboleth.atlassian.net/wiki/spaces/SP3/overview) endpoint.

## Installing a new shibboleth SP endpoint

We have [an ansible role for installing the shibboleth SP software (a.k.a shibd)](https://github.com/pulibrary/princeton_ansible/tree/main/roles/shibboleth), which has additional documentation and examples. The overall process looks like:

1. Spin up a new box and create an ansible playbook for it. The playbook should include the `shibboleth` role. The [vireo playbook](https://github.com/pulibrary/princeton_ansible/blob/main/playbooks/vireo_staging.yml) is a good example to follow.
2. You will need a java jdk to compile the required libraries. The `openjdk` ansible role provides this, but you must set a variable indicating that a JDK (as opposed to just a JRE) is required: `java_type: jdk`. See [this line in the vireo playbook](https://github.com/pulibrary/princeton_ansible/blob/main/group_vars/vireo/common.yml#L5) for an example.
3. You must use apache2 and its shibboleth plugin. There are shibboleth modules for other webservers (e.g., nginx) but we haven't configured those at PUL. Please stick to apache2 unless there is a compelling reason to do something else. 
4. You must use SSL with real signed certs, and these certs need to go into ansible in encrypted vault files. See the [vireo group_vars](https://github.com/pulibrary/princeton_ansible/tree/main/group_vars/vireo) for an example to follow.
5. You must define an [apache2 virtual host](https://github.com/pulibrary/princeton_ansible/blob/main/roles/vireo/templates/vireo.conf.j2), which must have specific directives:
  1. The ServerName must be the FQDN of your service *as defined on the load balancer* if you are using a load balancer.
  2. You must use the directive `  UseCanonicalName On`
  3. You must allow `mod_shib` to handle Shibboleth URLs, i.e., exclude them from any proxying: 
  ```
  ProxyPass        /Shibboleth.sso !
  ProxyPass        /shibboleth-sp !
  ```

Once all of this is in place, you should be able to go to `https://your_fqdn.princeton.edu/Shibboleth.sso/Metadata` and see an XML document containing SP metadata and SSL certs. Check that all of the URLs in the document are fully qualified. If they aren't, go back to the apache2 virtual host definition and double check the settings. 

## Enabling your new endpoint
Once the above is working, you can fill out a [Single Sign-on Integration Request Form](https://princeton.service-now.com/nav_to.do?uri=%2Fcom.glideapp.servicecatalog_cat_item_v[…]alog_view%3Dcatalog_default%26sysparm_view%3Dtext_search ). Put your SP metadata URL in the field called "Service Provider Metadata URL".

Once OIT responds to your request you should be able to go to `https://your_fqdn.princeton.edu/Shibboleth.sso/Login` and it should kick off a successful authentication session and redirect back to your application as expected.

## Useful Reference Documents
[Prepping Apache](https://shibboleth.atlassian.net/wiki/spaces/SP3/pages/2065335062/Apache#Prepping-Apache) Useful guide from shibboleth SP re: how to configure an apache virtual host.

[Installation of Shibboleth SP in Ubuntu](https://medium.com/@winma.15/shibboleth-sp-installation-in-ubuntu-d284b8d850da) Unofficial but useful installation guide. Most of the work described here is accomplished in our ansible role, but it provides a helpful overview of the installation process.
