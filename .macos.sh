#!/usr/bin bash

# ~/.macos — https://mths.be/macos
# Modified by DSR
# Run without downloading:
# curl https://raw.githubusercontent.com/dsepulvedar/dotfiles/master/.macos.sh | bash

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

echo "Hello $(whoami)! Let's get you set up.\n"

echo "mkdir -p ${HOME}/Repositories"
mkdir -p "${HOME}/Repositories"

echo "installing Apple CommandLineTools"
xcode-select --install

echo "installing homebrew"
# install homebrew https://brew.sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

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
unixodbc telnet pyenv curl


echo "installing apps with brew cask"
# Not use anymore: 
# ibm-cloud-cli
# arduino
brew install --cask google-chrome firefox brave-browser \
visual-studio-code 1password balenaetcher \
zoom iterm2 docker \
spotify whatsapp zappy telegram

echo "installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "cloning dotfiles"
git clone git@github-personal:dsepulvedar/dotfiles.git "${HOME}/Repositories/dotfiles"
ln -sf "${HOME}/Repositories/dotfiles/.zshrc" "${HOME}/.zshrc"
ln -sf "${HOME}/Repositories/dotfiles/.vimrc" "${HOME}/.vimrc"
ln -sf "${HOME}/Repositories/dotfiles/ipython_config.py" "${HOME}/.ipython/profile_default/ipython_config.py"

# Install nvm as a plugin for zsh
# echo "adding nvm plugin for zsh"
# git clone https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm

# Install volta
echo "Installing volta"
curl https://get.volta.sh | bash

source ~/.zshrc

# Install node LTS
echo "installing node tls"
volta install node

echo "node version"
node --version

# Not use anymore: 
# particle-cli
echo "installing Node-red and Particle CLI as a global program"
npm install -g node-red

# echo "installing Python 3.9.4 and making it global"
pyenv install 3.12
pyenv global 3.12

source ~/.zshrc

# pip install requests pyodbc pymodbus pytz ipdb paho-mqtt ipython 

echo "Making system modifications:"

# Make Chrome Two finger swipe for back and forward
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool TRUE

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

# Trackpad: enable tap to click for this user and for the login screen
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: enable three finger drag
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

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
# Finder                                                                      #
###############################################################################

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Show the /Volumes folder
sudo chflags nohidden /Volumes

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

###############################################################################
# Photos                                                                      #
###############################################################################

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

echo "Making zsh the default shell"
echo "$(which zsh)"  | sudo tee -a /etc/shells
chsh -s $(which zsh)

printf "TODO:\n\
install: \n\
  Paste (App Store) \n\
  MS Office \n\
  Adobe Lr, Ps, Pr \n\
  GoPro Quick (https://community.gopro.com/t5/en/GoPro-legacy-software/ta-p/595533) \n\
  Giphy Capture \n\
  USB Drivers for NodeMCU in Arduino: https://www.silabs.com/products/development-tools/software/usb-to-uart-bridge-vcp-drivers \n\
  Logi Options for MX Master 3 mouse \n\
  Balena CLI
\n\
Restart Terminal.app\n\
login to literally everything \n\
"