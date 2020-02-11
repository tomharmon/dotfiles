#!/bin/bash

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
WHITE="\033[37m"
NORMAL="\033[0;39m"

# Install Homebrew (if not already installed)
if test ! $(which brew); then
  printf "${YELLOW}Installing Homebrew...${NORMAL}\n"
  eval "/usr/bin/ruby -e '$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)'"
fi

# Updating brew (if out of date)
printf "\n${YELLOW}Updating homebrew...${NORMAL}\n"
brew update

printf "\n${GREEN}Homebrew installed and up to date!${NORMAL}\n"

# Installing packages from brew
printf "\n${YELLOW}Installing packages...${NORMAL}\n"

brew tap homebrew/bundle
brew bundle
brew upgrade
brew cleanup

# fix issues with gpg as installed from homebrew
git config --global gpg.program $(which gpg)

printf "\n${GREEN}Homebrew packages installed!${NORMAL}\n"

# Clean it up
printf "\n${YELLOW}Cleaning up homebrew things...${NORMAL}\n"
brew cleanup
