#!/usr/bin/env bash

echo "Bootstrapping dotfiles \n";


cd "$(dirname "${BASH_SOURCE}")";

#git pull origin master;

function doIt() {
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude ".osx" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		-avh --no-perms . ~;
	source ~/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;


# Check for Homebrew and install it if we don't have it
if test ! $(which brew); then
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

sudo launchctl config user path "/usr/local/bin:$PATH";

# Update homebrew recipes
brew update

# Install all applications with brew in Brewfile
brew tap homebrew/bundle
brew bundle
brew upgrade
brew cleanup

# fix issues with gpg as installed from homebrew
git config --global gpg.program $(which gpg)
