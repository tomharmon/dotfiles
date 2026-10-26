# Match the official launcher guards without replacing Omarchy's Bash config.
[[ $- == *i* && -z ${BASH_EXECUTION_STRING:-} && ${SHLVL:-0} == 1 ]] || return 0
[[ -d /usr/share/omarchy ]] || return 0
[[ $(ps --no-header --pid="$PPID" --format=comm) != fish ]] || return 0

if [[ -x "$HOME/.nix-profile/bin/fish" ]]; then
  if shopt -q login_shell; then
    exec "$HOME/.nix-profile/bin/fish" --login
  else
    exec "$HOME/.nix-profile/bin/fish"
  fi
fi
