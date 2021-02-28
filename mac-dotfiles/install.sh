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
xcode-select --install

# Install Homebrew and its packages
sh scripts/brew.sh

# Install Oh My Fish
printf "\n${BLUE}Installing Oh My Fish...${NORMAL}\n"
curl -L https://get.oh-my.fish | fish
omf install simple-ass-prompt

# Copy Fish config
printf "${YELLOW}Copying Fish config${NORMAL}\n"
mkdir ~/.config
cp -r fish ~/.config/

# set fish to default
echo (which fish) >> /etc/shells
chsh -s (which fish)

# install rust
printf "${YELLOW}Installing rust${NORMAL}\n"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

printf "${YELLOW}Installing cargo tools${NORMAL}\n"
source $HOME/.cargo/env
cargo install bat
cargo install bindgen
cargo install bottom
cargo install broot
cargo install cargo-expand
cargo install cargo-license
cargo install cargo-update
cargo install cargo-edit
cargo install cbindgen
cargo install exa
cargo install fd-find
cargo install flamegraph
cargo install git-delta
cargo install git-journal
cargo install grex
cargo install hyperfine
cargo install ripgrep
cargo install sccache
cargo install tokei
cargo install xsv
cargo install zoxide

# copy vim config
printf "${YELLOW}Copying vim config${NORMAL}\n"
cp -r ../nvim ~/.config

# copy git files
printf "${YELLOW}Copying git confg${NORMAL}\n"
cp ../.config/.gitignore ~/
cp ../.config/.gitconfig ~/
git config --global core.editor 'nvim'
git config --global core.excludesfile ~/.gitignore

# set gruvbox as the theme for bat
mkdir -p "$(bat --config-dir)/themes"
cd "$(bat --config-dir)/themes"
git clone git@github.com:austinwagner/gruvbox-sublime.git
bat cache --build


# Set up VS Code Settings and Extensions
sh scripts/vscode.sh

# TODO: copy linting files

# TODO: set up intellij settings

# TODO: install tmux config
#ln -s -f .tmux/.tmux.conf
#cp .tmux/.tmux.conf.local 

# TODO: auto install nerd fonts https://github.com/ryanoasis/nerd-fonts

# Add global NPM packages
printf "\n${GREEN}Installing global npm packages for ${NORMAL}\n"
npm install -g gatsby-cli prettier eslint


# Follow the instructions on GitHub to generate a new SSH key and add it to your Github account.
printf "\n${WHITE}==============================================================================

${GREEN}All set!

${WHITE}Make sure to follow the instructions on GitHub to generate a new SSH key and then add the key to your GitHub account.

==============================================================================${NORMAL}\n"

open
https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/#generating-a-new-ssh-key
open https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account
