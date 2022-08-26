# New Mac Setup
This is a get started guide to make it easier to setup your mac.

When you get a new mac here are some helpful guides to setting it up for software development in RDSS.

Use the URL below to customize/setup your unix prompt.
We use zsh as a unix prompt. The last two setup steps(8,9) are not necessary for mac setup but will add more custimization options if you feel the need to install.

https://www.freecodecamp.org/news/how-to-configure-your-macos-terminal-with-zsh-like-a-pro-c0ab3f3c1156/ 


A new SSH key will also need to be installed on your mac. Below is the link with the steps for connecting to github using SSH keys. The SSH key will be needed to connect with your github account and grants you the ability to start adding data into PUL repositories.  

https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwjJ8fzNxtr5AhXokmoFHU2CC5YQFnoECAUQAQ&url=https%3A%2F%2Fdocs.github.com%2Fen%2Fauthentication%2Fconnecting-to-github-with-ssh&usg=AOvVaw0ObLt130kJ7y4IwQ-069jU

New fellows may also want to rename the computer name,hostname and local hostname on your Mac machine. Below is the link to help rename.

https://jumpcloud.com/blog/how-to-rename-computer-name-hostname-local-hostname-macos


New fellows will need to download and install microsoft visual studio (VS Code) for mac os. You will also need to install the commands that allow you to launch VS Code from the iterm2 terminal command line. Link to instructions are below.

https://code.visualstudio.com/docs/setup/mac


go to the pdc_describe github page and checkout the projects dependencies and the local development setup information to become aware of the specific software plugins you will need to work on the project
https://github.com/pulibrary/pdc_describe


Fellows will also need to install asdf plugins to work with pdc_describe. Below is the link to install asdf plugins. check dependencies in step 1, download asdf in step 2, and run the ZSH & Homebrew command in step 3

https://asdf-vm.com/guide/getting-started.html


after installing asdf you will need the nodejs plugin for asdf version manager and a few other asdf plugins to work with PUL projects  (code "brew install gpg" may be needed as a dependency plugin for the asdf version manager). All plugins needed are below.

https://github.com/asdf-vm/asdf-nodejs
https://github.com/asdf-vm/asdf-ruby
https://github.com/twuni/asdf-yarn
https://gist.github.com/johnny-aroza/ab1ef0db48118f156bf39ed25b509544



Create a specific project profile in iterm2
1.Go to profile at the tab at the top of screen while in iterm2 terminal
2.click open profile
3.click edit profile
4. press the + button at the bottom of the current window to add pdc_describe profile.

While still in current window add pdc_describe to the fields listed below.
1.add name = pdc_describe
2.tag = pdc_describe
3.badge = pdc_describe
4.send text at start = cd ~/projects/pdc_describe
customize the color and text size of your terminal to your personal likeing.



Trouble shooting: 
1. 