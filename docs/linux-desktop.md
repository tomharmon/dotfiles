# Linux Desktop Apps

Nix/Home Manager owns shared CLI tools and explicitly selected user configs.
The host owns desktop applications, fonts, graphics drivers, Hyprland, desktop
portals, and privileged services. Devenv deploys the user configuration; it does
not run pacman, apt, vendor installers, or privileged host setup.
Native desktop apps use the host graphics stack without Nix GPU wrappers.
The Linux role disables Home Manager's GPU-library setup; it does not alter or
remove any graphics setup previously installed on a machine.

## Arch And Omarchy

From the repository root, install the official Arch repository manifest:

```sh
xargs -r -a packages/arch-desktop.txt sudo pacman -Syu --needed
```

This captures Element, Firefox, Ghostty, Obsidian, Signal, Hack Nerd Font, and
Zed. Existing packages are kept. This is additive, not a pruning/sync command.
No default browser or terminal is changed.

For the remaining packaged apps, review the AUR recipes and their upstream
download sources before installation. The AUR is community packaging, not an
official vendor repository. With an already installed `yay`, run as your user:

```sh
xargs -r -a packages/arch-desktop-aur.txt yay -S --needed
```

The manifest contains 1Password, Google Chrome, Spotify, and Microsoft's
Visual Studio Code distribution. Do not run `yay` as root or disable its
review prompts. Follow [1Password's Arch instructions](https://support.1password.com/install-linux/#arch-linux)
for importing its signing key before building that package. If Omarchy already
provides an app through a configured native repository, keep that installation
rather than installing another copy from the AUR.
These commands use GNU `xargs -a` on Linux to keep stdin available for
interactive package-manager prompts; do not run them on macOS.

Two vendor installations are tracked separately from the package manifests:

- **Cursor:** use the Linux download from [Cursor](https://cursor.com/downloads).
  Keep an existing Omarchy-managed native installation if present. No Cursor
  AUR recipe is prescribed here; package names and wrappers can change.
- **ChatGPT:** use the [official Arch installation instructions](https://learn.chatgpt.com/docs/linux/linux-app).
  They configure OpenAI's signed native package repository. Download and review
  the installation script before executing it; it performs a full system upgrade.

**Claude Desktop on Arch is an explicit availability exception.** Anthropic's
[Linux beta](https://code.claude.com/docs/en/desktop-linux) currently supports
Debian/Ubuntu and directs Arch users to the CLI. Use the already Nix-managed
Claude Code CLI and [Claude's web app](https://claude.ai/) on Omarchy for now.
These are not a replacement for all Desktop/Cowork features. The app remains
in our desired inventory, but this setup does not install an unsupported
community desktop wrapper. On Ubuntu, install the vendor desktop package below.

## Ubuntu

Use Ubuntu packages when available and vendor repositories/downloads for the
remaining apps. Do not run the Arch manifests on Ubuntu. This table is the
desktop installation inventory; vendor repository registration is a separate,
reviewed step rather than a deployment hook.

| App | Native installation source |
| --- | --- |
| Firefox | Ubuntu's Firefox distribution or [Mozilla's apt repository](https://support.mozilla.org/en-US/kb/install-firefox-linux) |
| Google Chrome | [Google's Linux `.deb`](https://www.google.com/chrome/) |
| Element | [Element's Debian/Ubuntu repository](https://element.io/download) |
| Signal | [Signal's Debian/Ubuntu repository](https://signal.org/download/) |
| Zed | [Zed's Linux installation](https://zed.dev/docs/linux) |
| Ghostty | Ubuntu 26.04+ `ghostty` package; for older releases, choose a method from [Ghostty's packaging documentation](https://ghostty.org/docs/install/binary) |
| Obsidian | [Vendor Linux download](https://obsidian.md/download) |
| Spotify | [Spotify's Debian/Ubuntu repository](https://www.spotify.com/download/linux/) |
| 1Password | [Vendor `.deb`/apt repository](https://support.1password.com/install-linux/) |
| Cursor | [Vendor Linux download](https://cursor.com/downloads) |
| Visual Studio Code | [Microsoft's `.deb`/apt repository](https://code.visualstudio.com/docs/setup/linux) |
| ChatGPT | [Vendor Linux `.deb`](https://learn.chatgpt.com/docs/linux/linux-app) |
| Claude Desktop | [Anthropic's apt repository](https://code.claude.com/docs/en/desktop-linux) |
| Hack Nerd Font | Install the Hack release from [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts/releases) into the host's font directories |

Figma uses the official web app on both Linux distributions. Home Manager
provides a launcher using the host's `google-chrome-stable` executable; install
Chrome before testing it. No third-party Figma wrapper is installed.
Docker is the intentional exception: Home Manager still owns the rootless
engine and user service. Tailscale is a native host service. Follow
[Linux host setup](linux-host.md) for both.

## Config Ownership And Migration

Keep Omarchy's login/session setup, graphics drivers, compositor, portals, and
desktop shortcuts under Omarchy's control. This repo does not manage Hyprland
or replace the system login shell. Ghostty launches Nix-managed Fish directly.
Do not globally inject Nix graphics libraries into the desktop session.

Home Manager continues to own Ghostty and Zed settings plus the shared Fish,
Neovim, Git, SSH, and other tool configs. Before first deployment, back up
colliding live files listed in the main README. On Omarchy, avoid theme/reset
operations that rewrite those selected repo-owned files. Other desktop app
settings and Omarchy's terminal/editor choices stay host-managed.

If migrating an already deployed Linux role, install the native apps first,
then build and deploy. The new generation no longer includes their Nix
packages, but old generations remain available for rollback. Review other Nix
profiles for duplicates; do not delete app data or purge packages indiscriminately.
This refactor does not uninstall anything or back up/change live configs.

Native packages supply their desktop entries through the host installation.
Home Manager's Figma entry lives in `~/.local/share/applications`. If your
launcher caches entries, refresh it or log out and back in.

Update shared Nix tools with `devenv update`, build, and deploy. Update Arch
apps with normal full-system upgrades (`pacman -Syu`, plus reviewed AUR updates),
and Ubuntu apps through their configured native sources. These manifests record
the desired apps, not reproducible version pins, just like the Mac Brewfile.
