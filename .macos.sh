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

echo "installing Apple CommandLineTools"
xcode-select --install

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
# zsh: UNIX shell
# pyenv: Python version manager
brew install dfu-util freetds git htop jq mosquitto ripgrep \
unixodbc zsh pyenv


echo "installing apps with brew cask"
brew cask install google-chrome firefox brave-browser \
visual-studio-code arduino 1password balenaetcher \
zoomus iterm2 \
spotify whatsapp zappy

echo "Making zsh the default shell"
chsh -s $(which zsh)

echo "installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"



###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

# Trackpad: enable tap to click for this user and for the login screen
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: enable three finger drag
defaults write http://com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -int 1

# Disable “natural” (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false


###############################################################################
# Screen                                                                      #
###############################################################################

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to the Desktop/Screenshots
defaults write com.apple.screencapture location -string "${HOME}/Desktop/Screenshots"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
# defaults write com.apple.screencapture disable-shadow -bool true

# Enable subpixel font rendering on non-Apple LCDs
# Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
defaults write NSGlobalDomain AppleFontSmoothing -int 1

# Enable HiDPI display modes (requires restart)
# sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true


# Show the ~/Library folder
chflags nohidden ~/Library

# Don’t display the annoying prompt when quitting iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

###############################################################################
# Photos                                                                      #
###############################################################################

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true



printf "TODO:\n\
install: \n\
  Paste (App Store) \n\
  MS Office \n\
  Adobe Lr, Ps, Pr \n\
  GoPro Quick (https://community.gopro.com/t5/en/GoPro-legacy-software/ta-p/595533) \n\
  PlayMemories Home \n\
  Giphy Capture \n\
\n\
Restart Terminal.app\n\
login to literally everything \n\
"