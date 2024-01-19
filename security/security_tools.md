Report on Dynamic and Static Analysis Security Tools
====================================================

This is a list of security tools that we have evaluated.  Some are
well-suited for incorporation in CI, and those are listed at the
top under the heading "Recommendations for the CI pipeline".
Others are more suited to other types of security projects
(e.g. security research, dependency audits).

This report covers four types of tools:
* [Dynamic Application Security Testing (DAST)](#dast): Source code files are interpreted (e. g. Rails application is run) or compiled (and the binary executed) in order to execute the vulnerability scanning suite
* [Static Application Security Testing (SAST)](#sast): These examine and interpret the source code to identify potential vulnerabilities.
* [Exploitation Enumeration Solutions](#exploitation-enumeration-solutions): These allow a human user to send requests to a
  running application to identify potential vulnerabilities.  While some of these (Dastardly and OWASP ZAP) can theoretically be incorporated into CI, they are at
  their best when a human user uses them interactively to research an application.
* [Software Composition Analysis (SCA)](#sca): These examine our dependency manifest files to identify vulnerabilities in our dependencies.

Recommendations for the CI pipeline
-----------------------------------

We recommend the following tools for integration in CI for PUL projects,
with our favorites at the top:

-   [CodeQL](#codeql)
-   [Semgrep](#semgrep)
-   [Wapiti](#wapiti)
-   [Dastardly](#burp-suite-and-dastardly)
-   [Bearer](#bearer)

Each tool has its own pros and cons, which are detailed in the report below.
Each project need not implement all of them, most projects would benefit from
adding one or two to their CI pipelines.

Most of these tools are general: they search for various classes of
vulnerabilities.  Adding them to your CI pipeline won't provide comprehensive
protection from any vulnerability, but they will help to:
* Educate the team about vulnerabilities and mitigation techniques they aren't yet familiar with
* Enforce secure code patterns
* Shift security thinking left, from remediation to prevention

The following table gives a brief roundup of the pros and cons to help
teams decide which tool(s) to start investigating for a particular project:

| Tool | Category | Use case(s) |
|----|----|----|
| [CodeQL](#codeql) | SAST | A project in Ruby, Java, Javascript, or Python that is looking for a low-barrier setup |
| [Semgrep](#semgrep) | SAST | A project in languages that CodeQL doesn't support (e.g. PHP), a project that want to enforce custom rules related to security or code style, or a project that needs CI to run very fast |
| [Wapiti](#wapiti) | DAST | A project that wants to use a DAST to check the running application |
| [Dastardly](#burp-suite-and-dastardly) | DAST | A project that wants to use a DAST to check the running application |
| [Bearer](#bearer) | SAST | A project that includes sensitive user data |

## DAST

### [Dastardly](https://portswigger.net/burp/dastardly)

See [Burp Suite](#burp-suite-and-dastardly).

### [Wapiti](https://wapiti-scanner.github.io/)

Wapiti needs Python 3.x where x is >= 10 (3.10, 3.11)

Installation: [use the setup.py script or pip install wapiti3](https://github.com/wapiti-scanner/wapiti/blob/master/INSTALL.md)

The ssl module used to scan TLS/SSL misconfiguration won't work on ARM processors (see[  SSLyze documentation](https://nabla-c0d3.github.io/sslyze/documentation/installation.html)).

Running Wapiti on Windows can be accomplished through the use of[  WSL](https://learn.microsoft.com/en-us/training/modules/get-started-with-windows-subsystem-for-linux/).

It will not check the code of the application. It will scan the pages of the deployed web application, extract links and forms and attack the scripts, send payloads and look for error messages, special strings or abnormal behaviors.

[General features](https://github.com/wapiti-scanner/wapiti#general-features)

[Browsing features](https://github.com/wapiti-scanner/wapiti#browsing-features)

[Supported attacks](https://github.com/wapiti-scanner/wapiti#supported-attacks)

Wapiti supports both GET and POST HTTP methods for attacks. It also supports multipart and can inject payloads in filenames (upload). Display a warning when an anomaly is found (for example 500 errors and timeouts) Makes the difference between permanent and reflected XSS vulnerabilities.

It was very straightforward to use. It generates reports in html that you can load and view. If there is an error it provides a link to the documentation.

## SAST

### [Bearer](https://github.com/bearer/bearer) 

To enable in CI: [use their CircleCI setup](https://docs.bearer.com/guides/ci-setup/#circleci) (not yet tried in any PUL projects).

To run it locally, you can install it through brew and run `bearer scan .` in the directory you wish to scan.

It supports Ruby, Javascript, and Typescript.  It has beta support for 4 other languages.  Bearer includes [73 ruby rules and 72 javascript/typescript rules](https://docs.bearer.com/reference/rules/).

Bearer provides packages for macOs and numerous linux distributions.  There is no specific information about Windows support, but it's theoretically possible to run the official bearer docker image.

I found bearer's output very pleasant to work with.  For any suspected issue, it provides you with a documentation link and a way to ignore the issue.  When ignoring the issue, it prompts you to write some documentation about why you are ignoring it, which it then stores in the repo.

The main thing Bearer brings to the table that other SAST tools do not is a focus on privacy.  For example, it includes some good rules specific to user credentials in rails.  For example, [it recommends using activerecord encryption for personally identifiable information](https://docs.bearer.com/reference/rules/ruby_rails_default_encryption/).

### [CodeQL](https://codeql.github.com/)

CodeQL is a hosted service provided by GitHub which provides vulnerability scanning on behalf of GitHub users. While GitHub provides their dedicated Advanced Security service separately from the CodeQL project, the documentation within the CodeQL project confirms that CodeQL libraries provide the underlying architecture for this Advanced Security solution.
While CodeQL provides vulnerability scanning features which are automated for GitHub repositories, there currently exist no implementation of any integration of CodeQL with any alternative version control projects dependent upon git (such as GitLab).
CodeQL itself contains various extensions to the underlying rulesets which is offered for a set of default languages and frameworks. More specifically, the following languages and frameworks are supported: C, C++, C#, Go, Java, Kotlin, JavaScript, Python, Ruby, Swift, and TypeScript. While there exist GitHub repositories through which one may be able to submit support for additional languages, the size of the user community (which includes GitHub itself) will ensure that the requirements for integrating CodeQL are fairly high. Beyond this, CodeQL is typically integrated into any given GitHub repository by modifying specific repository settings (this is described in the [community documentation](https://docs.github.com/en/code-security/code-scanning/introduction-to-code-scanning/about-code-scanning)). As such, end-users will then receive the vulnerability scanning reports when commits have been pushed to the repository, or in response to a pull request having been opened.

### [Semgrep](https://semgrep.dev/)

Semgrep has an open source version and a paid version (which includes additional rules and a software composition analyzer).  We evaluated the open source version.

To enable Semgrep, you can set up a CircleCi job using the Semgrep docker image.

-   [Example PR in allsearch-frontend](https://github.com/pulibrary/allsearch_frontend/commit/a25b0f2b7c4294b68ff57a3c23fd721da91d1223)

-   [Example PR with custom rules in bibdata](https://github.com/pulibrary/bibdata/pull/2189/files)

To run it locally, you can install it with brew.

Semgrep supports [many languages](https://semgrep.dev/docs/supported-languages/), including Ruby, Javascript, Typescript, PHP, and Python.  There are [43 rules for Ruby](https://semgrep.dev/p/ruby) and [71 rules for Javascript](https://semgrep.dev/p/javascript).  It can run on linux or macOs.  It can also run on Windows via Windows Subsystem for Linux or through the official docker image.

Semgrep is very fast, and makes it easy to create custom rules.  Its VSCode integration works well.

## Exploitation Enumeration Solutions

### [Burp Suite](https://portswigger.net/burp/documentation/desktop) and [Dastardly](https://portswigger.net/burp/dastardly)

Burp Suite serves as a comprehensive platform for undertaking manual vulnerability testing and discovery for web applications. Burp is available to users as a Community Edition, which is released under an open source license, and offers a graphical user interface within supported operating system environments (Burp itself is implemented using Java and distributed as a JAR). Further, there also exists a distribution of Burp, Dastardly, which provides a release of the suite which is optimized for continuous integration (CI) workflows. As a JAR, support for the Burp Suite is provided for Windows, macOS, and all major distributions of the Linux operating system.

Addressing the features of Burp, the suite provides users with the ability to send and modify HTTP request headers with the intended outcome of ensuring that a vulnerability is exploited, and that the target web application behavior provides a level of privilege escalation required to provide clients with some pathway to gaining security-sensitive information, or abnormal control over the behavior of the web application.

Burp does provide an API which supports the ability to develop custom extensions using Maven or Gradle, and implementing these using Java 17 releases (or earlier).

- [Example PR adding dastardly to allsearch-frontend](https://github.com/pulibrary/allsearch_frontend/pull/178)

### [Metasploit Framework](https://www.metasploit.com/)

Metasploit serves as a comprehensive vulnerability and penetration testing framework which is extensible, and which serves to ensure that end-users can, utilizing the Ruby language, automate workflows for vulnerability scanning and exploitation against a number of pre-defined operating system environments. As Metasploit is primarily developed within Ruby, Windows environments require the utilization of the Windows Subsystem for Linux (WSL).

Metasploit must be installed and run using a terminal environment, and as such, one must utilize apt, yum, pacman, brew, or similar package management utilities. Additionally, it is also quite possible to rely upon a Docker Container environment or an entire virtual machine in order to access and use the suite.

Metasploit provides a suite of various utilities through which to access tools commonly used to undertake penetration testing. These include, but are not limited to, the `nmap` port scanner, the airodump-ng WiFi traffic analyzer, and the netcat network diagnostic utility. Within the Metasploit environment, one is provided with the ability to create interactive sessions, in which the targeted remote host is tracked as an environment variable and stored within PostgreSQL database records, and then ensure that the output captured from each of these diagnostic and scanning utilities is persisted within the database for future reference (hence, ensuring that multiple sessions within Metasploit may be undertaken for the same remote host). Metasploit then provides a layer of features which relate more directly to exploiting known vulnerabilities within the targeted remote host. The feature named exploits provides extensible plug-ins which provide a means by which to create a reverse shell connecting to the remote host. The underlying plug-in architecture for exploits themselves are termed payloads, and these are specific strategies for compromising any given remote host, and then establishing the aforementioned reverse shell connection. As these must be specific to different types of remote hosts (e. g. Windows operating systems or Debian operating systems), these are individually developed using the Ruby language. Metasploit users must be familiar and comfortable with selecting the appropriate payloads in order to successfully exploit a remote host, and then proceed to elevate user privileges within the remote host using the remote shell.

### [Zed Attack Proxy (ZAP)](https://www.zaproxy.org/)

Zed Attack Proxy provides a series of utilities designed to exploit web application vulnerabilities focused more directly upon web applications. As an open source framework, the ZAP is designed to run primarily within graphical desktop environments, and as such, Windows and macOS operating system environments are supported in major releases.

While ZAP itself does contain a command-line interface for conducting vulnerability scans against any web application, most instructional resources and documentation assumes that end-users are utilizing the graphical interface in order to select, specify, and capture the output from the various scans provided by default within all major releases of the ZAP. Further, there also exist a number of extended modes for the ZAP which may be utilized for specific web application features, including (but not limited to) WebSocket vulnerability scanning, AJAX vulnerability scanning, an API (for local automation of ZAP scans), as well as a community-maintained addons within the [ZAP Marketplace](https://www.zaproxy.org/addons/).

## SCA

These examine our dependency manifest files to identify vulnerabilities in our dependencies.  Adding them to our CI pipeline gives us a warning when we open a PR that includes an insecure dependency, rather than us needing to wait for it to show up on a dependabot check.  Many of these tools look for various types of risks involved in a dependency, such as low use, code quality, or license imcompatibilities.

### [Snyk-CLI](https://docs.snyk.io/snyk-cli)

You can run the CLI locally from the command line or in an IDE. 

You can also run the CLI in your CI/CD pipeline.

[Supported languages and tools](https://docs.snyk.io/scan-using-snyk/supported-languages-and-frameworks)

[Supported operating system distributions](https://docs.snyk.io/scan-using-snyk/snyk-container/how-snyk-container-works/supported-operating-system-distributions)

[Supported IaC and cloud providers](https://docs.snyk.io/scan-using-snyk/scan-infrastructure/supported-iac-languages-cloud-providers-and-cloud-resources)

[Integrate with Snyk](https://docs.snyk.io/integrate-with-snyk)

[Pricing plans](https://docs.snyk.io/more-info/plans)

I haven't tried it yet in my local environment.

### [Vet](https://docs.safedep.io/)

I could not find any examples of Vet being used with CircleCI in Github.  I was unable to figure it out myself either, and [Vet's CircleCI documentation](https://docs.safedep.io/integrations/circle-ci) simply says "TBD".

To run locally:

```
brew tap safedep/tap
brew install safedep/tap/vet
vet auth configure --community
vet auth verify
vet scan
```

It has a [powerful filtering/query syntax](https://docs.safedep.io/advanced/filtering), which allows you to find, say, all the javascript projects with vulnerabilities but no maintainers.  I like that it includes [OSSF scorecard data](https://securityscorecards.dev/), as well as whether or not a dependency is maintained.  In practice, almost any project with any js dependencies fails these checks, and it is not granular enough to ignore certain dependencies.

It seems that this tool would not be useful as a CI tool in most PUL projects.  However, it is well suited for performing audits on-the-fly.
