#!/usr/bin/env fish

source (status dirname)/../config/fish/functions/copen.fish

function whoami
    echo testuser
end

function hostname
    echo testhost
end

function expect_link --argument-names url
    set -l escape (printf '\033')
    set -l bell (printf '\007')
    set -l expected "$escape]8;;$url$bell$url$escape]8;;$bell"
    set -l actual (copen $argv[2..])
    test "$actual" = "$expected"
    or exit 1
end

cd /
expect_link 'vscode://vscode-remote/ssh-remote+testuser@testhost/'
expect_link 'vscode://vscode-remote/ssh-remote+my-ssh-alias/' my-ssh-alias

set -l fixture (mktemp -d)
or exit 1
set -l directory "$fixture/a b#c%?"
mkdir -p "$directory"
or exit 1
cd "$directory"
expect_link "vscode://vscode-remote/ssh-remote+testuser@testhost$fixture/a%20b%23c%25%3F"

copen first second 2>/dev/null
test $status -ne 0
or exit 1

cd /
command rm -rf "$fixture"
printf 'PASS: copen default host, SSH alias, URL escaping, and argument validation\n'
