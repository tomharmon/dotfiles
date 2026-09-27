# Dotfiles

The `mac` machine in `devenv.nix` uses devenv 2.4 Machines to activate a local
Home Manager configuration. It manages the checked-in shell, editor, terminal,
and Git files, plus CLI packages. It does not run the older
`mac-dotfiles/install.sh` script or change macOS system settings.

## New Apple silicon Mac

1. Finish macOS setup and install the Xcode Command Line Tools (`xcode-select --install`).
2. Install [Nix and devenv 2.4+](https://devenv.sh/getting-started/), then clone this repository.
3. Check `home/mac.nix` for the correct username and home directory. This machine
   is currently specific to `thomasharmon` on `aarch64-darwin`.
4. From the repository root, inspect and build without activating:

   ```sh
   devenv machines info
   devenv build machines.mac
   ```

5. Back up any existing files that Home Manager would manage, especially
   `~/.config/fish/config.fish`, `~/.config/nvim`, and `~/.gitconfig`. Home Manager
   will refuse to overwrite an existing regular file. Then activate:

   ```sh
   devenv machines deploy mac
   ```

6. Run `rustup default stable` if there is no Rust toolchain yet.

There is no `devenv machines install` for macOS. The local Home Manager role
needs neither SSH nor passwordless sudo. Machines and their interface are still
[experimental](https://devenv.sh/machines/). The first devenv run creates
`devenv.lock`; commit it after a successful build to pin the inputs.
Run `devenv update` when you want newer Nixpkgs packages, then build again
before deploying. A lockfile makes each deployment reproducible rather than
silently changing package versions.

## What is managed

- `home/mac.nix` installs the 52 retained tools observed in `cargo install --list`
  on 2026-09-27, alongside Fish, Neovim, Starship, Rustup, Git, Bun, pnpm,
  Deno, and uv. Available tools use Nixpkgs packages; their versions follow
  `devenv.lock`, rather than the old Cargo installation versions. `eza`
  replaces `exa`, and `mdbook-linkcheck2` replaces `mdbook-linkcheck`.
- `home/cargo-packages.nix` defines the remaining tools as pinned Nix Rust
  packages, including `rusty-script` from its public Git repository. The crate
  versions and Git heads were checked against upstream on 2026-09-27 and were
  the latest available then. Their pins must be updated separately from
  `devenv update`. Generated lockfiles for the two crates that do not publish
  one live in `home/locks/`. These source builds may take longer than cached
  Nixpkgs packages. No Cargo install script runs during activation.
- `config/fish/config.fish` reflects the live Fish config, including Docker,
  Cargo, local binaries, Bun, pnpm, LM Studio, Kubeconfig, pyenv, Starship,
  zoxide, and aliases. The two personal functions are also managed.
- `config/fish/fish_plugins` records the live Fisher plugin list but is **not**
  linked by Home Manager. Install Fisher and then its listed plugins using
  [Fisher's instructions](https://github.com/jorgebucaran/fisher); Fisher owns
  its generated files and plugin list on the machine.

Tool-generated Fish `conf.d` files and `fish_variables` remain unmanaged.
External applications and their installers, including Docker Desktop, LM Studio,
Obsidian, and Worktrunk, are not provisioned here. Some checked-in
editor files differ from the live `~/.config/nvim`; review those differences
before replacing that directory on this Mac. The old setup scripts are retained
for reference and are not run by the new machine.
