#!/usr/bin/env bash
set -u

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
failures=0

if ! command -v cargo >/dev/null 2>&1; then
  printf 'cargo is required. Run rustup default stable first.\n' >&2
  exit 1
fi

while IFS='|' read -r crate version source install_path; do
  case "$crate" in
    ''|'#'*) continue ;;
  esac

  case "$install_path" in
    nix) continue ;;
    local)
      printf 'Skipping %s: local source %s is not in this repo.\n' "$crate" "$source"
      continue
      ;;
    cargo) ;;
    *)
      printf 'Unknown install path for %s: %s\n' "$crate" "$install_path" >&2
      failures=$((failures + 1))
      continue
      ;;
  esac

  printf 'Installing %s %s\n' "$crate" "$version"
  if [[ "$source" == crates.io ]]; then
    cargo install --locked --version "$version" "$crate" || failures=$((failures + 1))
  elif [[ "$source" == *#* ]]; then
    cargo install --locked --git "${source%#*}" --rev "${source##*#}" "$crate" || failures=$((failures + 1))
  else
    printf 'Unknown source for %s: %s\n' "$crate" "$source" >&2
    failures=$((failures + 1))
  fi
done < "$repo_dir/cargo-tools.tsv"

if ((failures > 0)); then
  printf '%d Cargo tools failed to install.\n' "$failures" >&2
  exit 1
fi
