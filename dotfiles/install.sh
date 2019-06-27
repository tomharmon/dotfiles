#!/bin/bash

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
WHITE="\033[37m"
NORMAL="\033[0;39m"

sudo -v

printf "\n${WHITE}==============================================================================

SETTING UP YOUR COMPUTER!

==============================================================================${NORMAL}\n"

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool YES

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool YES

# Show the ~/Library folder
chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Change minimize/maximize window effect
defaults write com.apple.dock mineffect -string "scale"

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool YES

# Enable spring loading for all Dock items
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool YES

# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool NO

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool NO

# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool YES

# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

# Allow hitting the Backspace key to go to the previous page in history
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool YES

# Disable Safari’s thumbnail cache for History and Top Sites
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

# Make Safari’s search banners default to Contains instead of Starts With
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool NO

# Block pop-up windows
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool NO
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool NO

# Disable auto-playing video
defaults write com.apple.Safari WebKitMediaPlaybackAllowsInline -bool NO
defaults write com.apple.SafariTechnologyPreview WebKitMediaPlaybackAllowsInline -bool NO
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool NO
defaults write com.apple.SafariTechnologyPreview com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool NO

# Enable “Do Not Track”
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool YES

# Fix macOS Mojave antialiased fonts
defaults write -g CGFontRenderingFontSmoothingDisabled -bool NO

# Show hidden dotfiles in finder
defaults write com.apple.finder AppleShowAllFiles YES
killall Finder

# Install XCode Command Line Tools
printf "\n${BLUE}Installing XCode Command Line Tools...${NORMAL}\n"
eval "xcode-select --install"

# Install NVM
printf "\n${GREEN}Installing NVM...${NORMAL}\n"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
nvm install node --lts
nvm alias default node

# Install Homebrew and its packages
eval "sh scripts/brew.sh"

# Install Oh My Zsh
printf "\n${BLUE}Installing Oh My Zsh...${NORMAL}\n"
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Copy ZSH config
printf "${YELLOW}Copying ZSH config into ~/.zshrc...${NORMAL}\n"
eval "cp .zshrc ~/.zshrc"

eval "git clone https://github.com/denysdovhan/spaceship-prompt.git '$ZSH_CUSTOM/themes/spaceship-prompt'"
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"


# Refresh ZSH config
eval "source ~/.zshrc"


# set zsh to default
eval "chsh -s /bin/zsh"

# copy git files
printf "${YELLOW}Copying git files into ~/...${NORMAL}\n"
eval "cp .gitignore ~/"
#eval "cp .gitconfig ~/"

# Install fonts
eval "sh scripts/fonts.sh"

# Set up VS Code Settings and Extensions
eval "sh scripts/vscode.sh"

# Add global NPM packages
printf "\n${GREEN}Installing global npm packages for Spaceship ZSH Prompt, Trash CLI, Gulp CLI, Docker CLI, Gatsby CLI, Vue CLI...${NORMAL}\n"
eval "npm install -g spaceship-prompt trash-cli gulp-cli docker-cli gatsby-cli @vue/cli vsce yo"

# Open links for apps that can't be downloaded via brew cask
printf "\n${BLUE}Opening links for apps to download...${NORMAL}\n"


# Development
eval "open https://developer.apple.com/xcode/"


# Follow the instructions on GitHub to generate a new SSH key and add it to your Github account.
printf "\n${WHITE}==============================================================================

${GREEN}All set!

${WHITE}Make sure to follow the instructions on GitHub to generate a new SSH key and then add the key to your GitHub account.

==============================================================================${NORMAL}\n"

eval "open https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/#generating-a-new-ssh-key"
eval "open https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account"
