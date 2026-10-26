# Keep the official bindings, but let Home Manager initialize Starship/Zoxide.
# The host's mise-activate.fish already initializes mise separately.
if test -d /usr/share/omarchy; and status is-interactive
    fish_vi_key_bindings
    if command -q fzf; and functions -q fzf_configure_bindings
        fzf_configure_bindings --processes=
    end
end
