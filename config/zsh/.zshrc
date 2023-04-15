# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"
# Path to your oh-my-zsh installation.

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="apple"
export BARTIB_FILE="/Users/thomasharmon/.bartib/activities.bartib"
# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
autoload -Uz compinit; compinit;
bindkey "^Xa" _expand_alias
zstyle ':completion:*' completer _expand_alias _complete _ignored
zstyle ':completion:*' regular true

preexec(){ [ $1 != $2 ] && print -r "> $2" }

function squash-last-two-commits() {
  # Get shortened SHA of current commit
  local sha=$(git log --pretty=format:'%h' -n 1)
  # Get commit message of current commit
  local message=$(git log -1 --pretty=%B)
  # Add all changes
  git add .
  # Make a new commit with the squash flag
  echo "$sha"
  git commit --fixup "$sha"
  # Rebase
  git rebase --autosquash -i HEAD~2
}


alias vim="nvim"

alias ga="git add -u"
alias gc="git commit"
# and rebase
alias gcc="squash-last-two-commits"
alias gco="git checkout"
alias gp="git pull --rebase"
alias gl="git log --all --decorate --oneline --graph"
alias gs="git status"
alias gr="git reset --soft"
alias gd="git diff"
alias gu="git reset --soft HEAD~1"
alias ls="exa -Fl --git-ignore"
alias la="exa -la"
alias lt="exa -laT -L 3 -I .git\|.idea\|target --git-ignore"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias j="z"
alias ji="zi"

source $HOME/.cargo/env

export PATH="/usr/bin/pip3:/opt/homebrew/opt/python@3.11/libexec/bin:$PATH"

eval "$(zoxide init zsh)"
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh
eval "$(direnv hook zsh)"
