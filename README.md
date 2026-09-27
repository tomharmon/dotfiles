# Dotfiles

Devenv Machines manages two user environments: `mac` (Apple silicon macOS) and
`linux` (x86_64 Linux). Home Manager installs the shared CLI tools and links the
checked-in Fish, Neovim, Starship, Broot, and Git configuration. The old
`mac-dotfiles/` and `linux-dotfiles/` installers are gone.

## New Mac

1. Complete macOS setup, then install the Xcode Command Line Tools, Nix,
   [devenv 2.4+](https://devenv.sh/getting-started/), and
   [Homebrew](https://brew.sh/).
2. Clone this repository. Check that `thomasharmon` matches your macOS account
   in `home/mac.nix`.
3. Back up existing files Home Manager will own, especially
   `~/.config/fish/config.fish`, `~/.config/nvim`, and `~/.gitconfig`.
4. Inspect and build before activation, then deploy the local Home Manager role:

   ```sh
   devenv machines info
   devenv build machines.mac
   devenv machines deploy mac
   ```
5. Install the GUI apps from Homebrew's native manifest, with normal interactive
   macOS approval when required:

   ```sh
   brew bundle --file ./Brewfile
   ```

The `Brewfile` lists Obsidian, Spotify, Element Desktop (Matrix), ChatGPT,
Claude Desktop, Ghostty, 1Password, Cursor, Visual Studio Code, and Tailscale.
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
Visual Studio Code, and the Tailscale package through Nixpkgs. Tailscale still
needs a system daemon and login, which this user-only role does not configure.
ChatGPT and Claude Desktop are macOS-only in this configuration; their web apps
remain available on Linux. Spotify and other proprietary apps require the
`allow_unfree` setting in `devenv.yaml`.

## Packages and updates

The shared CLI inventory lives in `home/common.nix`. It includes the retained
Cargo tools available from Nixpkgs; `xan` replaces the removed `xsv` package,
and `eza` replaces `exa`. Nine remaining Rust tools are pinned in
`home/cargo-packages.nix`, with generated lockfiles in `home/locks/`. No Cargo
install script runs during activation. After deployment, run `rustup default
stable` if you need a Rust toolchain.

Devenv's inputs are pinned by `devenv.lock` after the first successful build.
Run `devenv update`, build, and deploy to update Nixpkgs packages. Custom Rust
source pins need separate updates. Run `brew bundle --file ./Brewfile` again to
update Mac apps. Homebrew casks use current metadata when run, so they are less
reproducible than Nix packages. Devenv
Machines are still [experimental](https://devenv.sh/machines/).

`config/fish/fish_plugins` records the live Fisher plugins but is not linked by
Home Manager. Tool-generated Fish files remain unmanaged. Some checked-in
Neovim files differ from the current live configuration; review them before
replacing `~/.config/nvim` on this Mac.
