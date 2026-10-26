#!/usr/bin/env bash
set -euo pipefail

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
setup=${1:-$root/scripts/setup-omarchy-fish.bash}
launcher=${2:-$root/config/bash/omarchy-fish.bash}
scratch=$(mktemp -d)
trap 'rm -rf -- "$scratch"' EXIT
export HOME="$scratch/home"
mkdir -p "$HOME"
printf '# Existing configuration\nexport KEEP_ME=yes\n' > "$HOME/.bashrc"
cp "$HOME/.bashrc" "$scratch/original"

bash "$setup"
backups=("$HOME"/.bashrc.before-omarchy-fish.*)
[[ ${#backups[@]} == 1 ]]
cmp "$scratch/original" "${backups[0]}"
grep -Fqx 'export KEEP_ME=yes' "$HOME/.bashrc"
cp "$HOME/.bashrc" "$scratch/installed"
bash "$setup"
cmp "$scratch/installed" "$HOME/.bashrc"
backups=("$HOME"/.bashrc.before-omarchy-fish.*)
[[ ${#backups[@]} == 1 ]]

mkdir -p "$scratch/linked"
ln -s "$scratch/original" "$scratch/linked/.bashrc"
if HOME="$scratch/linked" bash "$setup"; then
  echo 'Setup must not rewrite a symlinked Bash configuration' >&2
  exit 1
fi
cmp "$scratch/original" "${backups[0]}"

# Explicit commands, including bash -ic, must never get replaced by Fish.
[[ $(bash --noprofile --norc -c 'source "$1"; printf kept-bash' _ "$launcher") == kept-bash ]]
[[ $(bash --noprofile --norc -ic 'source "$1"; printf kept-bash' _ "$launcher" 2>/dev/null) == kept-bash ]]
bash -n "$setup" "$launcher" "$HOME/.bashrc"
printf 'Omarchy Bash integration checks passed\n'
