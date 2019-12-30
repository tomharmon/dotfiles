abbr -a gia 'git add -u'
abbr -a gic 'git commit'
abbr -a gip 'git pull --rebase'
abbr -a gil 'git log --all --decorate --oneline --graph'
abbr -a gis 'git status'
abbr -a gir 'git reset --soft'
abbr -a gid 'git diff | bat'
abbr -a giu 'git reset --soft HEAD~1'
abbr -a ls 'exa -F --git-ignore'
abbr -a la 'exa -la'
abbr -a lt 'exa -laT -L 3 -I .git --git-ignore'

source $HOME/.cargo/env
set -x TERM "xterm-256color"
set -U set -U fish_user_paths /usr/local/sbin /usr/local/bin /usr/bin /bin ~/.cargo/bin
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths
[ -f /usr/local/share/autojump/autojump.fish ]; and source /usr/local/share/autojump/autojump.fish
