#!/bin/sh

# Check if there is a gitmessage template configured, and
# if not, configure it
git config --get commit.template || git config --global commit.template ~/.gitmessage

# See which file is currently configured as the template
export LOCALGITMESSAGE=$(git config --get commit.template)

# Download the template from github
wget -O $LOCALGITMESSAGE https://raw.githubusercontent.com/pulibrary/pul-it-handbook/main/gitmessage.md

# The file we download from github includes some documentation,
# as well as the actual gitmessage (which is surrounded by ```)
#
# First, we remove the lines outside the ``` section
sed -i '' '/^```/,/^```/!d' $LOCALGITMESSAGE

# And finally, we remove the ``` delimiter lines
sed -i '' '/^```/d' $LOCALGITMESSAGE
