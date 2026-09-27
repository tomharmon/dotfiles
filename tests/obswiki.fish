#!/usr/bin/env fish

source (status dirname)/../config/fish/functions/obswiki.fish

set -l fixture (mktemp -d)
or exit 1
set -lx HOME "$fixture"
set -lx XDG_CONFIG_HOME ""
set -lx OBSWIKI_VAULT ""
set -g test_os Darwin

function uname
    echo $test_os
end

function register_vault --argument-names registry vault
    mkdir -p (path dirname "$registry") "$vault"
    or exit 1
    command jq -n --arg vault "$vault" '{vaults: {test: {path: $vault}}}' >"$registry"
    or exit 1
end

function expect_vault --argument-names expected
    obswiki
    or exit 1
    test "$PWD" = "$expected"
    or exit 1
end

function expect_failure
    set -l previous "$PWD"
    obswiki 2>/dev/null
    set -l result $status
    test $result -ne 0
    or exit 1
    test "$PWD" = "$previous"
    or exit 1
end

# Vault paths come from the registry, not a presumed default folder.
set -l mac_registry "$HOME/Library/Application Support/obsidian/obsidian.json"
register_vault "$mac_registry" "$HOME/My Mac Notes/Tom"
expect_vault "$HOME/My Mac Notes/Tom"

set -g test_os Linux
expect_failure
set -l linux_registry "$HOME/.config/obsidian/obsidian.json"
register_vault "$linux_registry" "$HOME/My Linux Notes/Tom"
expect_vault "$HOME/My Linux Notes/Tom"
set -e XDG_CONFIG_HOME
expect_vault "$HOME/My Linux Notes/Tom"

set -lx XDG_CONFIG_HOME "$HOME/custom config"
set -l custom_registry "$XDG_CONFIG_HOME/obsidian/obsidian.json"
register_vault "$custom_registry" "$HOME/Synced Notes/Tom"
expect_vault "$HOME/Synced Notes/Tom"

register_vault "$custom_registry" "$HOME/Other Vault"
expect_failure
command jq -n '{vaults: {}}' >"$custom_registry"
expect_failure
printf 'invalid json\n' >"$custom_registry"
expect_failure
command jq -n --arg first "$HOME/My Linux Notes/Tom" --arg second "$HOME/Synced Notes/Tom" \
    '{vaults: {first: {path: $first}, second: {path: $second}}}' >"$custom_registry"
expect_failure
command jq -n --arg vault "$HOME/missing/Tom" '{vaults: {test: {path: $vault}}}' >"$custom_registry"
expect_failure

# An explicit override bypasses the registry on either platform.
set -lx OBSWIKI_VAULT "$HOME/custom vault"
mkdir -p "$OBSWIKI_VAULT"
expect_vault "$OBSWIKI_VAULT"
set -g test_os Darwin
expect_vault "$OBSWIKI_VAULT"
set -lx OBSWIKI_VAULT "$HOME/missing vault"
expect_failure
set -e OBSWIKI_VAULT
expect_vault "$HOME/My Mac Notes/Tom"

cd /
command rm -rf "$fixture"
printf 'PASS: obswiki registry lookup, platform paths, overrides, and error handling\n'
