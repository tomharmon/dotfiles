# Dotfiles

Devenv Machines manages two user environments: `mac` (Apple silicon macOS) and
`linux` (x86_64 Linux). Home Manager installs the shared CLI tools and links the
checked-in Fish, Neovim, Starship, Broot, Worktrunk, Ghostty, Zellij, and Git configuration.
The old `mac-dotfiles/` and `linux-dotfiles/` installers are gone.

## New Mac

1. Complete macOS setup, then install the Xcode Command Line Tools, Nix,
   [devenv 2.4+](https://devenv.sh/getting-started/), and
   [Homebrew](https://brew.sh/).
2. Clone this repository. Check that `thomasharmon` matches your macOS account
   in `home/mac.nix`.
3. Back up existing files Home Manager will own, especially
   `~/.config/fish/config.fish`, `~/.config/nvim`, `~/.gitconfig`,
   `~/.config/worktrunk/config.toml`, `~/.config/zellij`,
   `~/.config/fish/functions/fisher.fish`, and
   `~/Library/Application Support/com.mitchellh.ghostty/config`.
4. Inspect and build before activation, then deploy the local Home Manager role:

   ```sh
   devenv machines info
   devenv build machines.mac
   devenv machines deploy mac
   ```
5. Install the Mac apps and native CLIs from Homebrew's manifest, with normal
   interactive macOS approval when required:

   ```sh
   brew bundle --file ./Brewfile
   ```

The `Brewfile` lists Obsidian, Spotify, Element Desktop (Matrix), ChatGPT,
Claude Desktop, Ghostty, 1Password, Cursor, Visual Studio Code, Tailscale, and
Docker Desktop. It also installs the 1Password CLI and the
[Codex](https://developers.openai.com/codex/cli), Claude Code, and
[Cursor Agent](https://formulae.brew.sh/cask/cursor-cli) CLIs separately from
their desktop apps. Hack Nerd Font is installed through Homebrew too.
Launch Docker Desktop once to finish its setup.
`brew bundle` also upgrades outdated apps; `greedy: true` includes casks that
normally self-update. It does not remove undeclared Homebrew packages. Sign in
to the apps and approve any macOS permissions they require. No SSH, Remote
Login, or passwordless sudo is needed for the devenv machine.

## New Linux

Install Nix and devenv 2.4+, clone the repository, and check the username and
home directory in `home/linux.nix`. The Linux machine is a local, user-only
Home Manager role for an x86_64 graphical Linux host, not a NixOS installation.
Back up existing managed files, then run:

```sh
devenv build machines.linux
devenv machines deploy linux
```

Linux installs Obsidian, Spotify, Element Desktop, Ghostty, 1Password, Cursor,
Visual Studio Code, and Tailscale through Nixpkgs, along with the 1Password,
Codex, Claude Code, and Cursor Agent CLIs. The Docker client includes
`docker compose` and `docker buildx`; install and configure a Docker daemon on
the Linux host separately, or connect to a remote daemon using a Docker context.
This user-only setup does not enable system services or grant Docker socket
access. Docker Desktop is only installed on macOS by this repository.
The official Linux
builds of ChatGPT and Claude Desktop come from separate, pinned Nix packaging inputs in
`devenv.yaml`, because the main Nixpkgs input does not package them for Linux.
These are third-party packaging definitions, not upstream Nix releases. Tailscale
still needs a system daemon and login, which this user-only role does not
configure. Proprietary apps require the `allow_unfree` setting in `devenv.yaml`.

Both machines import `home/common.nix`, so Worktrunk and its settings, GitHub
CLI, Node.js 24, Fish integration, and the reconciled Neovim configuration
apply to Linux too. Ghostty uses the same checked-in settings at Linux's XDG
config path. Credentials and agent sessions remain machine-local on both.

## Shared development tools

Home Manager installs GitHub CLI (`gh`), Worktrunk (`wt`), and Node.js 24 as a
global fallback alongside pnpm. Worktrunk uses the checked-in worktree path and
`copy-ignored` hook; existing hook approvals remain machine-local.

Pin Node in each project's own devenv when it needs a specific version, for example:

```nix
{ pkgs, ... }:
{
  languages.javascript = {
    enable = true;
    package = pkgs.nodejs_24;
  };
}
```

Home Manager installs Fisher 4.4.5 from a pinned, hash-checked source on both
platforms. No other Fish plugins are installed, and nvm.fish is deliberately
excluded: devenv owns project Node selection. The old `fish_plugins` inventory
has been removed. Update Fisher's source pin in `home/common.nix`, not with
`fisher update fisher`, because Home Manager owns its function file. Plugins
you add with Fisher and their generated files remain machine-local.

Fish uses devenv's [native auto-activation](https://devenv.sh/auto-activation/),
not direnv. Review a project's configuration, then run `devenv allow` there to
trust it; use `devenv revoke` to withdraw trust. You can also enter explicitly
with `devenv shell`. Check `type -a node` after migration for older installations
shadowing the managed fallback.

Python uses `uv` instead of pyenv. In a project, use `uv python pin 3.13` to
record its Python version and `uv sync` / `uv run` for its environment. For a
standalone virtual environment, use `uv venv --python 3.13`. No pyenv shell
initialization or global Python shim is installed. Existing Python environments
are not deleted.

Both platforms also install:

- Infrastructure: `kubectl`, Helm, `k9s`, OpenTofu, `flyctl`, `pgcli`, and Stripe CLI.
- Documents and media: Typst, FFmpeg, ImageMagick, and `yt-dlp`.
- Mobile tooling: Watchman, Fastlane, and SwiftLint. CocoaPods is macOS-only;
  Apple's SDKs, Xcode, and iOS builds also require macOS. Fastlane tasks on Linux
  must not depend on those Apple tools.

Ghostty uses Gruvbox Dark Hard, Hack Nerd Font Mono, and the same Shift+Enter
binding on both platforms, at its native macOS config path and
`~/.config/ghostty/config` on Linux. Linux installs the font through Nix and
enables Home Manager's Fontconfig integration.

Zellij keeps current built-in defaults except for the intentional overrides in
`config/zellij/config.kdl`: Alt+i/Alt+o do not move tabs, and session-mode `w`
opens the session manager directly. Start the captured layouts with
`zellij --layout four-panes` or `zellij --layout sidebar`. The old `.dkl`
filenames were corrected to `.kdl`, and the sidebar split property was repaired.

Authentication is deliberately unmanaged: sign in to `gh`, `op`, and the agent
CLIs on each machine. Do not commit their credential stores, tokens, or sessions.
Existing manually installed binaries are not removed. Use
`type -a claude cursor-agent codex op` to check for older copies shadowing the
managed versions.

## Xcode bootstrap

For Apple development, install full Xcode from the App Store or Apple's
developer downloads; Command Line Tools alone do not include the iOS SDK.
Open Xcode, review and accept its license, and finish its initial setup. Then
select that installation and install its first-launch components:

```sh
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
xcodebuild -version
xcrun simctl list runtimes
```

Install the iOS simulator/runtime through Xcode's settings, or explicitly run
`xcodebuild -downloadPlatform iOS`. These downloads can be large. Apple signing
accounts, certificates, provisioning profiles, and App Store credentials stay
outside Git. See Apple's [command-line tool selection](https://developer.apple.com/documentation/xcode/configuring-command-line-tools-settings)
and [additional components](https://developer.apple.com/documentation/xcode/downloading-and-installing-additional-xcode-components)
documentation.

## Neovim configuration

The checked-in Neovim settings and plugin snapshots match the live Mac setup
captured during migration, rather than upgrading to current plugin releases.
The scratch file `foo` is intentionally excluded. Editor extensions for VS Code
are not managed by this repository.

[`lazy-lock.json`](https://lazy.folke.io/usage/lockfile) records plugin commit
pins; `lazyvim.json` records LazyVim extras and configuration metadata. On first
startup, the config seeds writable copies of both into Neovim's `stdpath("state")`
directory (normally `~/.local/state/nvim`). This keeps plugin updates and
LazyVim settings writable while Home Manager owns the read-only config files.
Existing state copies are preserved, not overwritten on deployment.

Use `:Lazy restore` to restore the seeded plugin versions. After intentional
plugin or extras changes, sync the two state files back into `config/nvim/` and
review the diff to update the baseline for new machines. This does not pin
Mason-installed language servers or Tree-sitter parser binaries.

Run the isolated config checks without loading plugins or your live settings:

```sh
nvim --headless -u NONE -i NONE -l tests/neovim-state.lua
```

## Packages and updates

The shared CLI inventory lives in `home/common.nix`. It includes the retained
Cargo tools available from Nixpkgs; `xan` replaces the removed `xsv` package,
and `eza` replaces `exa`. Five remaining Rust tools are pinned in
`home/cargo-packages.nix`, using their upstream lockfiles. No Cargo
install script runs during activation. After deployment, run `rustup default
stable` if you need a Rust toolchain.

Devenv's inputs are pinned by `devenv.lock` after the first successful build.
Run `devenv update`, build, and deploy to update Nixpkgs packages. Custom Rust
source pins need separate updates. Run `brew bundle --file ./Brewfile` again to
update Mac apps and native CLIs. Homebrew casks use current metadata when run,
so they are less reproducible than Nix packages. Devenv Machines are still
[experimental](https://devenv.sh/machines/).

Tool-generated Fish files remain unmanaged. Deployment does not remove old
Cargo/Homebrew installations, Python environments, or credentials.
