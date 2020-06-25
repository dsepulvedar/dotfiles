#!/usr/bin bash

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# DSR's Customizations                                                       #
###############################################################################

echo "Hello $(whoami)! Let's get you set up."

echo "installing homebrew"
# install homebrew https://brew.sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "brew installing stuff"
# dfu-util: download and upload firmware to/from devices connected over USB. Needed to flash Particle devices over the CLI
# freetds: Libraries to talk to Microsoft SQL Server and Sybase databases
# git: version control
# htop: interactive process viewer
# jq: Lightweight and flexible command-line JSON processor
# mosquitto: MQTT client 
# ripgrep: rg is faster than alternatives
# unixodbc: ODBC 3 connectivity for UNIX
brew install dfu-util freetds git htop jq mosquitto ripgrep \
unixodbc