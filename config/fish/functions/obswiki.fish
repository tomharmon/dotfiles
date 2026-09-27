function obswiki --description 'Open the Obsidian wiki vault directory'
    # Allow an explicit path for vaults not registered with Obsidian.
    if set -q OBSWIKI_VAULT; and test -n "$OBSWIKI_VAULT"
        cd "$OBSWIKI_VAULT"
        return $status
    end

    set -l config_home
    if test (uname) = Darwin
        set config_home "$HOME/Library/Application Support"
    else
        set config_home "$HOME/.config"
        if set -q XDG_CONFIG_HOME; and test -n "$XDG_CONFIG_HOME"
            set config_home "$XDG_CONFIG_HOME"
        end
    end

    set -l registry "$config_home/obsidian/obsidian.json"
    if not test -r "$registry"
        printf 'obswiki: Cannot read %s. Create or open the Tom vault in Obsidian first.\n' "$registry" >&2
        return 1
    end
    if not command -q jq
        printf 'obswiki: jq is required to locate the Tom vault.\n' >&2
        return 1
    end

    set -l vaults (command jq -r '[.vaults[]? | .path? | strings | select(split("/")[-1] == "Tom")] | unique[]' "$registry" 2>/dev/null)
    if test $status -ne 0
        printf 'obswiki: Could not parse %s.\n' "$registry" >&2
        return 1
    end
    if test (count $vaults) -eq 0
        printf 'obswiki: No Tom vault registered. Create or open it in Obsidian first.\n' >&2
        return 1
    end
    if test (count $vaults) -gt 1
        printf 'obswiki: Multiple Tom vaults found. Set OBSWIKI_VAULT to the desired path.\n' >&2
        return 1
    end

    cd "$vaults[1]"
end
