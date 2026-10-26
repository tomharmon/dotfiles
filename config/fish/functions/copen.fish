function copen --description 'Print a VS Code Remote SSH link to the current directory'
    if test (count $argv) -gt 1
        printf 'Usage: copen [ssh-host]\n' >&2
        return 1
    end

    set -l host $argv[1]
    if test -z "$host"
        set host (whoami)@(hostname)
    end

    set -l directory (string escape --style=url -- "$PWD")
    set -l url "vscode://vscode-remote/ssh-remote+$host$directory"
    printf '\033]8;;%s\007%s\033]8;;\007\n' "$url" "$url"
end
