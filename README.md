# Dotfiles

The `mac` machine in `devenv.nix` uses devenv 2.4 Machines to activate a local
Home Manager configuration. It manages the checked-in shell, editor, terminal,
and Git files, plus a baseline of CLI packages. It does not run the older
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

6. Run `rustup default stable` if there is no Rust toolchain yet. To restore the
   remaining observed Cargo tools, run `bash scripts/install-cargo-tools.sh`.
   This can take a long time and is intentionally separate from activation.

There is no `devenv machines install` for macOS. The local Home Manager role
needs neither SSH nor passwordless sudo. Machines and their interface are still
[experimental](https://devenv.sh/machines/). The first devenv run creates
`devenv.lock`; commit it after a successful build to pin the inputs.

## What is managed

- `home/mac.nix` installs the commonly available tools through Nix, including
  Fish, Neovim, Starship, Rustup, Git, Bun, pnpm, Deno, uv, and a subset of the
  Cargo CLI inventory.
- `cargo-tools.tsv` records **all 54 crates** reported by `cargo install --list`
  on this Mac on 2026-09-27. Its `nix` rows are provided by Home Manager; its
  `cargo` rows are installed at the observed versions by the opt-in script.
  `rusty-script` is marked `local`: its source is another repository and cannot
  be restored from these dotfiles alone. Cargo builds may fail on a different
  Rust version or architecture; the script continues and reports failures.
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
