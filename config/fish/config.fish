if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
    alias vim="nvim"
    
    alias ga="git add -u"
    alias gc="git commit"
    # and rebase
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
    
    set PATH $PATH ~/.cargo/bin
    
    zoxide init fish | source
end
