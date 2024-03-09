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
cargo install alacritty
cargo install bat
cargo install bartib
cargo install bindgen
cargo install bottom
cargo install broot
cargo install cargo-expand
cargo install cargo-license
cargo install cbindgen
cargo install exa
cargo install fd-find
cargo install flamegraph
cargo install git-delta
cargo install git-journal
cargo install grex
cargo install hyperfine
cargo install lsd
cargo install ripgrep
cargo install sccache
cargo install tokei
cargo install xsv
cargo install zellij
cargo install zoxide

# copy vim config
printf "${YELLOW}Copying vim config${NORMAL}\n"
mkdir -p ~/.vim/undodir
cp -r ../nvim ~/.config

# copy git files
printf "${YELLOW}Copying git confg${NORMAL}\n"
cp ../.config/.gitignore ~/
cp ../.config/.gitconfig ~/
git config --global core.editor 'nvim'
git config --global core.excludesfile ~/.gitignore

# set gruvbox as the theme for bat
bat --generate-config-file
mkdir -p "$(bat --config-dir)/themes"
cd "$(bat --config-dir)/themes"
git clone git@github.com:austinwagner/gruvbox-sublime.git
bat cache --build
echo "\n--theme=gruvbox" >> $(bat --config-file)


# Set up VS Code Settings and Extensions
sh scripts/vscode.sh

# TODO: copy linting files

# TODO: set up intellij settings

# TODO: install tmux config
#ln -s -f .tmux/.tmux.conf
#cp .tmux/.tmux.conf.local 

# Add global NPM packages
printf "\n${GREEN}Installing global npm packages for ${NORMAL}\n"
npm install -g gatsby-cli prettier eslint

sudo apt install fish

# Follow the instructions on GitHub to generate a new SSH key and add it to your Github account.
printf "\n${WHITE}==============================================================================

${GREEN}All set!

${WHITE}Make sure to follow the instructions on GitHub to generate a new SSH key and then add the key to your GitHub account.

==============================================================================${NORMAL}\n"

open
https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/#generating-a-new-ssh-key
open https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account
