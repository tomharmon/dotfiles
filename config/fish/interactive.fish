if command -q devenv; and not functions -q _devenv_hook
    devenv hook fish | source
end

if command -q pbpaste; and command -q pbcopy
    alias fmtj="pbpaste | jq . | pbcopy"
end

if command -q pbcopy
    function gh_lines_mac_copy
        echo $argv | pbcopy
    end
end
