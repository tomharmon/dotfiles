# Dotfiles

Devenv Machines manages two user environments: `mac` (Apple silicon macOS) and
`linux` (x86_64 Linux). Home Manager installs the shared CLI tools and links the
checked-in Fish, Neovim, Starship, Broot, and Git configuration. The old
`mac-dotfiles/` and `linux-dotfiles/` installers are gone.

## New Mac

1. Complete macOS setup, then install the Xcode Command Line Tools, Nix,
   [devenv 2.4+](https://devenv.sh/getting-started/), and
   [Homebrew](https://brew.sh/). Homebrew is bootstrapped separately; nix-darwin
   manages its casks, not the Homebrew installation itself.
2. Clone this repository. Check that `thomasharmon` matches your macOS account
   in `devenv.nix`, `home/mac.nix`, and `home/darwin.nix`.
3. Enable Remote Login for your account and configure passwordless sudo for
   nix-darwin activation. Devenv's nix-darwin deploy currently uses SSH, even
   for the `localhost` target. Do not deploy until you are comfortable with
   that access requirement.
4. Back up existing files Home Manager will own, especially
   `~/.config/fish/config.fish`, `~/.config/nvim`, and `~/.gitconfig`.
5. Inspect and build before activation, then deploy:

   ```sh
   devenv machines info
   devenv build machines.mac
   devenv machines deploy mac
   ```

The macOS system role uses nix-darwin's Homebrew module to install Obsidian,
Spotify, Element Desktop (Matrix), ChatGPT, Claude Desktop, Ghostty, 1Password,
Cursor, Visual Studio Code, and Tailscale. Cask metadata and installed apps are
upgraded on activation; undeclared Homebrew packages are left alone. You must
still sign in to the apps and approve any macOS permissions or system extensions
they require. The Home Manager role runs after nix-darwin succeeds.

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
source pins need separate updates. The macOS casks use current Homebrew metadata
on each activation, so they are less reproducible than Nix packages. Devenv
Machines are still [experimental](https://devenv.sh/machines/).

`config/fish/fish_plugins` records the live Fisher plugins but is not linked by
Home Manager. Tool-generated Fish files remain unmanaged. Some checked-in
Neovim files differ from the current live configuration; review them before
replacing `~/.config/nvim` on this Mac.
