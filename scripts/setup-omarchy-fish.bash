#!/usr/bin/env bash
set -euo pipefail

bashrc="$HOME/.bashrc"
hook='if [[ -r "${XDG_CONFIG_HOME:-$HOME/.config}/bash/omarchy-fish.bash" ]]; then source "${XDG_CONFIG_HOME:-$HOME/.config}/bash/omarchy-fish.bash"; fi'

if [[ -f "$bashrc" ]] && grep -Fqx -- "$hook" "$bashrc"; then
  exit 0
fi
if [[ -L "$bashrc" ]]; then
  echo "Refusing to modify a symlinked .bashrc; add the Omarchy Fish hook in its owning configuration." >&2
  exit 1
fi
if [[ -f "$bashrc" ]]; then
  backup=$(mktemp "$HOME/.bashrc.before-omarchy-fish.XXXXXXXX")
  cp -p -- "$bashrc" "$backup"
  printf 'Backed up Bash configuration to %s\n' "$backup"
fi

printf '\n# Launch managed Fish in interactive Omarchy shells.\n%s\n' "$hook" >> "$bashrc"
