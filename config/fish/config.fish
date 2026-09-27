fish_add_path --path --append "$HOME/.docker/bin" "$HOME/.cargo/bin" "$HOME/.local/bin"
fish_add_path --path --prepend "$HOME/.bun/bin" "$HOME/Library/pnpm" "$HOME/.lmstudio/bin"

set -gx BUN_INSTALL "$HOME/.bun"
set -gx PNPM_HOME "$HOME/Library/pnpm"
set -gx KUBECONFIG "$HOME/.kube/k3s-ci.yaml"

if command -q pyenv
    pyenv init - | source
    if pyenv commands | string match -q virtualenv-init
        pyenv virtualenv-init - | source
    end
end

if status is-interactive
    if command -q starship
        starship init fish | source
    end
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
    alias fmtj="pbpaste | jq . | pbcopy"

    if command -q zoxide
        zoxide init fish | source
    end
end

function gh_lines_mac_copy
    echo $argv | pbcopy
end
