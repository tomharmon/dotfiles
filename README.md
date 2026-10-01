# Dotfiles

Devenv Machines manages two user environments: `mac` (Apple silicon macOS) and
`linux` (x86_64 Linux). Home Manager installs the shared CLI tools and links the
Fish, Neovim, Starship, Broot, Worktrunk, Ghostty, Zellij, and Git configuration.
Native Home Manager modules own program installation and shell integration where
useful; custom Lua, Fish, TOML, and KDL sources remain readable in `config/`.
Desktop apps use Homebrew on macOS and native distro/vendor packages on Linux.
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
   `~/.config/bat/config`, `~/.config/gh/config.yml`,
   `~/.config/zed/settings.json`, `~/.ssh/config`,
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
Claude Desktop, Ghostty, 1Password, Cursor, Visual Studio Code, Tailscale,
Docker Desktop, Firefox, Google Chrome, Zed, Figma, and Signal.
These casks use vendor distributions rather than the Mac App Store.
The 1Password, Codex, Claude Code, and Cursor Agent CLIs are installed through
Nix on both platforms, not Homebrew. Hack Nerd Font is installed through
Homebrew on macOS.
Launch Docker Desktop once to finish its setup.
`brew bundle` also upgrades outdated apps; `greedy: true` includes casks that
normally self-update. It does not remove undeclared Homebrew packages. Sign in
to the apps and approve any macOS permissions they require. No SSH, Remote
Login, or passwordless sudo is needed for the devenv machine.

## New Linux

Install Nix and devenv 2.4+, clone the repository, and check the username and
home directory in `home/linux.nix`. The Linux machine is a local, user-only
Home Manager role for an x86_64 graphical Linux host, not a NixOS installation.
Install the [native desktop apps](docs/linux-desktop.md) and complete the
[Linux host prerequisites](docs/linux-host.md) for Ubuntu or Arch/Omarchy.
Then back up existing managed files, build, and deploy:

```sh
devenv build machines.linux
devenv machines deploy linux
```

The native desktop inventory retains Obsidian, Spotify, Element Desktop,
Ghostty, 1Password, Cursor, Visual Studio Code, Firefox, Google Chrome, Zed,
Signal, ChatGPT, and Claude Desktop where supported. Arch's official and AUR
package manifests live in `packages/`; vendor-only installations and the
Ubuntu inventory are documented in the desktop guide. Claude Desktop currently
supports Debian/Ubuntu, not Arch; the guide records that limitation explicitly
rather than adding an unsupported wrapper. Figma uses its official web app.

Nix still installs the 1Password, Codex, Claude Code, and Cursor Agent CLIs.
Home Manager installs the full Docker
package, including Compose and Buildx, and manages a rootless `docker.service`
in the user systemd manager. Fish defaults to its user-owned socket without
overriding an explicitly exported `DOCKER_HOST` or `DOCKER_CONTEXT`.
Docker data lives under `~/.local/share/docker`; no rootful daemon or
Docker-group access is configured. Docker Desktop remains macOS-only.
Tailscale's normal VPN daemon and CLI are installed together through the host's
package manager, not duplicated in Home Manager. Login remains interactive.
The retained proprietary CLI packages use `allow_unfree` in `devenv.yaml`.

Graphics drivers, Hyprland, desktop portals, fonts, and login/session setup stay
host-owned. Native GUI apps use the host graphics stack; this role deliberately
disables Home Manager's Nix GPU-library setup. NixGL is not required for this
desktop app inventory. Ghostty and Zed settings remain Home Manager-owned,
so avoid Omarchy theme/reset operations that rewrite those selected configs.

Complete the [Linux host setup](docs/linux-host.md) for Ubuntu or
Arch/Omarchy: UID-map helpers, subordinate IDs, optional boot-time lingering,
Ubuntu's targeted RootlessKit AppArmor profile, and the Tailscale system service.
The desktop compositor (Hyprland or otherwise) does not change these steps.
Check the desktop ownership boundary and native manifests without fetching
dependencies or activating anything:

```sh
nix eval --file tests/linux-desktop.nix
```

On Linux, `tests/docker-home.nix` provides an isolated Home Manager test for
the rootless unit, daemon settings, and Fish socket selection. It does not
activate the service or modify host prerequisites.

Figma has no official Linux desktop app. The Linux application menu includes
a Figma launcher for the official web app in a dedicated, native Chrome window;
no third-party Figma desktop wrapper is installed.

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

### Fish ownership

`home/fish.nix` enables Home Manager's `programs.fish` module. Home Manager
generates `~/.config/fish/config.fish`, installs `pkgs.fish` from the rolling
Nixpkgs input, and provides its session variables and package paths.
General initialization places the Home Manager profile's `bin` first, except
inside an inherited devenv environment where project tools retain precedence.
Aliases are declared in `programs.fish.shellAliases`; interactive hooks live in
`config/fish/interactive.fish`. `config/fish/theme.fish` preserves the live
syntax-highlighting and completion-pager colors, including bold, underline,
reverse, and background attributes. Home Manager includes it in interactive
initialization as global variables, after existing `conf.d` snippets run.
The live `fish_frozen_theme.fish` remains untouched until migration.
The pnpm data directory is declared through
`home.sessionVariables`. Old Bun, Deno, Cargo, and pnpm executable directories
are not added to PATH; Nix owns the managed CLI executables.
Rustup still owns project Rust toolchains.
Starship and Zoxide use their Home Manager modules for Fish integration; do not
also initialize them in the fragments. Starship's settings are parsed from
`config/starship.toml` and rendered by its module.

The managed `fish/conf.d/00-nix.fish` loads the multi-user Nix environment before
Home Manager's session setup. The existing Fish function sources and pinned
Fisher function remain managed individually. Fisher-installed plugins and Fish
universal variables remain local.

Changing this repository does not change a live shell until activation. On an
existing machine, build first, then back up and move colliding files immediately
before deployment; do not leave the live configuration absent between steps.
Ghostty explicitly launches the managed Fish on both platforms. Home Manager
does not change the operating system's login-shell registration.
On Omarchy, preserve the system login shell and session initialization; use
Fish inside Ghostty instead. On macOS, after successful deployment, register
the stable managed Fish path and make it your login shell, from Fish:

```fish
set managed_fish "$HOME/.nix-profile/bin/fish"
grep -Fxq "$managed_fish" /etc/shells; or echo "$managed_fish" | sudo tee -a /etc/shells
chsh -s "$managed_fish"
```

Keep Homebrew Fish until the login-shell switch succeeds. Update the rolling
input with `devenv update`, then build and deploy to obtain newer Fish releases
as they reach Nixpkgs; Fish is not frozen to a version in this repository.
Existing Fish universal variables and vendor-written `conf.d` files are not
deleted automatically. Move obsolete runtime startup snippets aside during
migration so they do not reintroduce competing executable paths.

Check Fish syntax and the vault helper without activating anything:

```sh
fish -n config/fish/*.fish config/fish/functions/*.fish
fish tests/obswiki.fish
fish --no-config tests/fish-theme.fish
```

`tests/fish-home.nix` is an isolated Home Manager build test for the generated
Fish config, session-variable setup, Git/LFS/Delta, Broot, Neovim, and Zellij.
It checks that Zellij autostart stays disabled and LazyVim's init file is not
replaced. It can run
without building the full CLI inventory or changing any live config:

```sh
nix build --impure --no-link --expr '
  let
    homeManager = builtins.getFlake "github:nix-community/home-manager";
    pkgs = import (builtins.getFlake "nixpkgs").outPath { config.allowUnfree = true; };
  in import ./tests/fish-home.nix { inherit pkgs homeManager; }
'
```

### Native tool modules

`home/git.nix` owns Git identity, settings, LFS filters, and Delta integration.
Global ignore patterns are read from `config/.gitignore` and rendered to
`~/.config/git/ignore`; Git's configuration lives at `~/.config/git/config`.
The old linked `~/.gitconfig` must be moved aside during migration, otherwise
its higher-precedence settings can override the generated XDG config. No
signing keys, credentials, or authentication settings are added by this module.

`home/tools.nix` manages Broot, Neovim, and Zellij. Broot's TOML is parsed into
native settings, rendered as `~/.config/broot/conf.hjson`, and its Fish
integration provides the `br` navigation function. Move any old Broot config
directory aside immediately before first activation so an old `conf.toml`
does not compete with the generated configuration.
Neovim is the default editor (`EDITOR` and `VISUAL`); `PAGER` is `less`, which is
installed too. Neovim's Lua sources, LazyVim plugins, and writable plugin state
retain their existing ownership; no second plugin manager is introduced.

Zellij's module installs the program and renders the existing KDL and layouts.
Fish, Bash, and Zsh autostart integrations are explicitly disabled. Sessions
start only when you run `zellij` or choose a layout yourself. Worktrunk and
Ghostty remain managed through their existing config sources.

Bat uses the exact Gruvbox theme captured from the live setup, including its
MIT license, in `config/bat/`. Home Manager rebuilds Bat's theme cache during
activation. Zed's Vim mode, font sizes, theme choice, and disabled telemetry
metrics are declared in `home/tools.nix`; its settings are repo-owned rather
than writable through Zed. Zed itself comes from the vendor Homebrew cask on
macOS and native Linux packages. Home Manager manages its settings only.
GitHub CLI keeps HTTPS Git transport and the `gh co` alias; authentication
in `hosts.yml` and the keychain remains machine-local.

`home/ssh.nix` installs OpenSSH and declares the existing host aliases without
the obsolete OrbStack include or duplicated hostname directive. Private keys,
authorized keys, and known-host state are not managed or copied.

There is no global `KUBECONFIG` override. Kubernetes uses its normal default
configuration unless a project or explicit command selects another file:

```sh
kubectl --kubeconfig "$HOME/.kube/k3s-ci.yaml" config current-context
```

Start a fresh shell after deployment; an already-exported `KUBECONFIG` in the
parent environment is not unset by removing its declaration.

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
`~/.config/ghostty/config` on Linux. Linux installs Hack Nerd Font natively,
through Arch's `ttf-hack-nerd` package or the upstream font release on Ubuntu.

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
update Mac apps. Update Linux desktop apps through their native package sources,
as described in [Linux desktop setup](docs/linux-desktop.md).
Homebrew casks use current metadata when run,
so they are less reproducible than Nix packages. Devenv Machines are still
[experimental](https://devenv.sh/machines/).

Tool-generated Fish files remain unmanaged. Deployment does not remove old
Cargo/Homebrew installations, Python environments, or credentials.
