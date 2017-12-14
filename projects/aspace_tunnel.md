# Microsoft Windows Archivesspace MariaDB tunnel

## Prerequisites

Install all the software below and create a GitHub account

* [GitBash](http://gitforwindows.org/)
* [Github Account](https://github.com/join?source=header-home)
* [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)
* [MySQL ODBC](https://dev.mysql.com/downloads/connector/odbc/)
* [Visual C++](https://www.microsoft.com/en-us/download/details.aspx?id=40784)

## Upload SSH-Keys to GitHub

Launch you GitBash Application and run the following steps

```
ssh-keygen -t rsa -b 4096 -C "your_email@princeton.edu"
```

This will generate a new ssh key using your princeton email as the label. If you created your
GitHub account with a different account please adjust accordingly. You will be
prompted to "Enter a file in which to save the key," press Enter. This accepts
the default file location

```
Enter a file in which to save the key (/c/Users/you/.ssh/id_rsa):[Press enter]
```

At the prompt, type a secure passphrase.

Copy the SSH key to your clipboard

```
clip < ~/.ssh/id_rsa.pub
```

Follow the instructions from the url below

https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/#platform-windows

## Convert OpenSSL Keys

Start the PuTTYgen application by tapping the Windows Key and typing "PuTTygen"

In PuTTYgen, import your existing ~/.ssh/id_rsa (private) key, via `Conversions`
-> `Import Key`

Save the imported key via `Save private key` button as `~/.ssh/id_rsa.ppk`

## Setting up an SSH Session with SSH Keys in PuTTY

Start by opening up the main PuTTY program. You can do this by double clicking on the PuTTY program, or by tapping the Windows key and typing "PuTTY".

Inside, you'll be taken to the main session screen. The first step is to enter the IP mariadb1 into the session page.

By default, SSH happens on port 22, and the "SSH" connection type should be selected. These are the values we want.

Next, we'll need to select the "Data" configuration inside the "Connection" heading in the left-hand navigation menu:

![Data Example][logo]
[logo](images/aspace_tunnel/data_category.png)

Here, we will enter our server's username. For the initial setup, this should be the "aspaceuser" user, which is the administrative user of your server. This is the account that has been configured with your SSH public key. Enter "aspaceuser" into the "Auto-login username" prompt:

Next, we'll need to click on the "SSH" category in the navigation menu:

Within this category, click on the "Auth" sub-category.

There is a field on this screen asking for the "Private key file for authentication". Click on the "Browse" button:

![Browse for Key][logo]
[logo](images/aspace_tunnel/browse_keys.png)

Search for the private key file that you saved. This is the key that ends in ".ppk". Find it and select "Open" in the file window:

Now, in the navigation menu, we need to return to the "Session" screen that we started at.

Select `SSH` -> `Tunnels` and configure it like this

Source port: 3306

Destination: 127.0.0.1:3306

Click `Add` to add it to the list of forwarded ports

This time, we need to create a name for the session that we will be saving. This can be anything but we will save it as `aspace@mariadb1` to allow consistency in documentation.

Create a shortcut on the user’s desktop to automatically load the saved PuTTY tunnel configuration.

* Locate Putty in the start menu
* Right click on the start menu Putty shortcut and select `Send to Desktop`
* Right click on the newly created shortcut on the desktop and choose
  `Properties`
* Adjust the Target as follows: "C:\Program Files\PuTTY\putty.exe" -load
  "aspaceuser@mariadb1"
* Click OK to close the shortcut properties window
* Right click the shortcut and select rename: "aspaceuser@mariadb1"

Create MySQL ODBC User DSN pointing to the localhost port 3306

* Double click the desktop shortcut created earlier and authenticate the SSH session
* Configure the ODBC settings but set the server name to 127.0.0.1:3306
* Click the test button to confirm successful configuration
