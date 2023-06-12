# New Mac Setup
This is a get started guide to make it easier to setup your mac.

## First time on campus

1. If possible, meet with Terry Callahan on the Operations and Desktop Support
   team to get these initial steps completed!
1. Log in to your machine with your Library IT-provided username and password
1. On a coworker's computer:
  1. Look up your netid on https://www.princeton.edu/search/people-advanced
  1. [follow the
     steps](https://princeton.service-now.com/service?id=kb_article&sys_id=9f7a4f5387ca0dd012ae43bd0ebb3589#section4) to set up your princeton password
1. Log in to eduroam with your princeton netid and password

## Important accounts to create

1. Lastpass
1. GitHub (use a personal email address for this -- you will use this account
   throughout your career)

## General applications you will need to set up

Most of these are documented on OIT pages.
* Outlook
* Slack
* Zoom
* Crashplan
* Creative Cloud (this can wait for a bit later)

## Machine setup

When you get a new mac here are some helpful guides to setting it up for PUL software development.

1. [The thoughtbot laptop setup script](https://github.com/thoughtbot/laptop) is great and sets up a lot of useful
   things. Consider running this as your first step.
1. Customize and setup your unix prompt.
    1. Install Xcode CLI tools: `xcode-select —-install`
    2. [Install homebrew](https://brew.sh/) (this is done by the thoughtbot
       script if you ran that)
    3. Many of us prefer using iTerm2 over the default terminal.  You can install it with `brew install iterm2 --cask`
    4. We use zsh as a unix prompt. This is the default for newer Macs, but if it is not installed, you can install it with `brew install zsh`.
    5. Many of us use Oh My Zsh.  You can install it with `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
1. Generate an ssh key. Our operations team recommends [the mozilla instructions for intermediate client configuration](https://infosec.mozilla.org/guidelines/openssh#intermediate-connects-to-older-servers)

2. [Connect your ssh key to your github account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh). This will allow you to push / pull from our repositories from your machine, and this is also how we manage access to our servers.

1. To check and see if this step was completed correctly you will need to go to the github webpage that shows your public keys. your public keys page will look similar to [https://github.com/twade968.keys](https://github.com/twade968.keys), but with your github id.

![alt text](images/github_keys.png "Title")


3. New fellows may also want to rename the computer name,hostname and local hostname on your Mac machine. Below is the link to help rename.

https://jumpcloud.com/blog/how-to-rename-computer-name-hostname-local-hostname-macos

Before I changed my hostname this is what my unix prompt looked like
![alt text](images/change_hostname.png "Title")

This is what the unix prompt should look like after change
![alt text](images/unix_prompt_newhostname.png "Title")



4. New fellows will need to download and install microsoft visual studio (VS Code) for mac os. You will also need to install the commands that allow you to launch VS Code from the iterm2 terminal command line. Link to instructions are below.

https://code.visualstudio.com/docs/setup/mac


5. install these programs with homebrew
```
brew install bat
brew install gpg 
brew install postgres
brew install --cask lando
brew install asdf
```


6. After installing asdf you will need a few other asdf plugins to work with PUL projects. Common plugins needed are below.

* https://asdf-vm.com/guide/getting-started.html
* https://github.com/asdf-vm/asdf-nodejs
* https://github.com/asdf-vm/asdf-ruby
* https://github.com/twuni/asdf-yarn
* https://gist.github.com/johnny-aroza/ab1ef0db48118f156bf39ed25b509544


7. You will also need to install git config commands. The git config command is a convenience function that is used to set Git configuration values on a global or local project level. You can use the Git configuration file to customize how Git works.
```
git config --global user.name "Your Name"
git config --global user.email "your_princeton_email"
git config --global core.pager bat
```

Trouble shooting: 
1. 
