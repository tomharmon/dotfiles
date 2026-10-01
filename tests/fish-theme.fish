#!/usr/bin/env fish

set -l theme (path dirname (status filename))/../config/fish/theme.fish
if set --query argv[1]
    set theme $argv[1]
end
source "$theme"; or exit 1

function expect_color
    set -l variable $argv[1]
    set -l expected $argv[2..]
    if not set --query --global $variable
        echo "FAIL: $variable must be global" >&2
        exit 1
    end
    if test (string join ' ' -- $$variable) != (string join ' ' -- $expected)
        echo "FAIL: unexpected value for $variable" >&2
        exit 1
    end
end

expect_color fish_color_command blue
expect_color fish_color_autosuggestion brblack
expect_color fish_color_cancel -r
expect_color fish_color_redirection cyan --bold
expect_color fish_color_search_match white --background=brblack
expect_color fish_color_selection white --bold --background=brblack
expect_color fish_color_valid_path --underline
expect_color fish_pager_color_description yellow -i
expect_color fish_pager_color_prefix normal --bold --underline
expect_color fish_pager_color_progress brwhite --background=cyan
expect_color fish_pager_color_selected_background -r

echo "PASS: Fish theme colors, attributes, and global scope"
