if test -d /usr/share/omarchy
    # Use the host's bootstrap so dev-link paths and tool paths stay in sync.
    if test -r /usr/share/omarchy/default/bash/env-bootstrap
        set -l omarchy_env (command bash --noprofile --norc -c '
            source /usr/share/omarchy/default/bash/env-bootstrap
            printf "%s\0" "$OMARCHY_PATH" "$PATH"
        ' | string split0)
        if test (count $omarchy_env) -eq 2
            set -gx OMARCHY_PATH "$omarchy_env[1]"
            set -gx PATH (string split : -- "$omarchy_env[2]")
        end
    else
        set -q OMARCHY_PATH; or set -gx OMARCHY_PATH /usr/share/omarchy
        fish_add_path --path --append "$HOME/.local/share/mise/shims" "$HOME/.local/bin"
    end

    set -q BROWSER; or set -gx BROWSER omarchy-launch-browser
    # Home Manager sets EDITOR after the vendor envs.fish has already run.
    set -q EDITOR; and set -gx SUDO_EDITOR "$EDITOR"
end
