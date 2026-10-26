# Linux Host Setup

Home Manager owns rootless Docker's Nix package, daemon configuration, and
systemd user service. The host owns the small set of privileged prerequisites
and normal Tailscale VPN integration. These steps run on the Linux host,
not the Mac. They are not run automatically by deployment.

Desktop applications, fonts, and GPU drivers also belong to the host. Complete
the [native desktop installation](linux-desktop.md) before deploying the user
configs. Neither this guide nor Home Manager replaces Omarchy's desktop setup.

## Host Packages

### Ubuntu

Install the privileged UID-map helpers and user-session D-Bus support:

```sh
sudo apt-get update
sudo apt-get install uidmap dbus-user-session
```

Install Tailscale through its official installer, which configures its package
repository. Review the installer before running it if desired:

```sh
curl -fsSL https://tailscale.com/install.sh | sh
sudo systemctl enable --now tailscaled.service
```

### Arch Or Omarchy

Use Arch's maintained packages; do not install a second rootful Docker daemon
for this setup:

```sh
sudo pacman -Syu --needed shadow dbus tailscale
sudo systemctl enable --now tailscaled.service
```

Omarchy may already configure rootful Docker and Docker-group access. That
existing daemon has separate containers, images, and volumes from rootless
Docker; they are not migrated or deleted by this repository.

## Omarchy Fish

On Omarchy only, install the [official Fish integration](https://github.com/omacom/omarchy-fish)
through the host package manager before deploying the Linux role:

```sh
xargs -r -a packages/omarchy-shell.txt omarchy pkg add
devenv build machines.linux
devenv machines deploy linux
```

The native package supplies Fish vendor functions, completions, environment
defaults, and fzf.fish. Nix-managed Fish discovers the host's vendor directories
through `XDG_DATA_DIRS`; no Fisher installation or copied vendor tree is needed.
Home Manager continues to own Fish itself, the prompt, aliases, colors, and
Starship/Zoxide integration. Its Linux-only `conf.d/init.fish` overrides the
package's same-named initializer to retain the official vi/fzf bindings without
initializing Starship, Zoxide, or mise twice. The host's separate
`mise-activate.fish` continues to initialize mise.

Do not run `omarchy-setup-fish` over these dotfiles: its current helper replaces
the whole `.bashrc` with a template using the old Omarchy install path. Instead,
Linux activation on Omarchy appends one guarded source line to the existing
`.bashrc`, makes a `.bashrc.before-omarchy-fish.*` backup on the first change,
and leaves the rest of the file intact. Repeated activation is a no-op. A
symlinked `.bashrc` is refused; add the hook in its owning configuration instead.

The hook launches `$HOME/.nix-profile/bin/fish` only for a top-level interactive
Bash shell with no command string and no Fish parent, carrying through login
mode. Explicit `bash -c` / `bash -ic`, scripts, and nested Bash remain Bash.
The account's login shell and Omarchy's system/session files are unchanged.
Fish uses Omarchy's current environment bootstrap to retain `OMARCHY_PATH`,
dev-link overrides, and local tool paths even when a terminal launches it
directly. The shared Home Manager editor remains authoritative.

Open a new terminal or SSH session after deployment. Verify:

```fish
status fish-path
echo $OMARCHY_PATH
type compress fip ff
functions ls
```

The helper functions should come from `/usr/share/fish/vendor_functions.d`,
while `ls` retains the shared dotfiles alias. This host-only package is not
added to the generic Arch desktop manifest or installed on Ubuntu/macOS.

## Subordinate IDs

Both `/etc/subuid` and `/etc/subgid` need at least 65,536 subordinate IDs
allocated to your login user. Inspect existing allocations from Fish:

```fish
set login_user (id -un)
grep -- "^$login_user:" /etc/subuid /etc/subgid
```

If either allocation is absent or too small, inspect both files and choose an
unused range. An administrator can allocate it with
`sudo usermod --add-subuids START-END --add-subgids START-END USERNAME`.
Replace the placeholders; do not reuse another user's range or assume a
particular starting ID is free. Keep existing valid allocations.
The helpers must be privileged host binaries; installing ordinary copies
of `newuidmap` and `newgidmap` into a Nix profile is not sufficient.

## Deploy And Start Docker

Build and activate the Linux Home Manager role after backing up its colliding
live configs. In particular, an existing
`~/.config/docker/daemon.json` or user `docker.service` needs review:

```sh
devenv build machines.linux
devenv machines deploy linux
```

On Ubuntu 24.04+, Nix's RootlessKit executable needs a targeted AppArmor
permission to create user namespaces. Home Manager generates a profile for
the exact packaged executable. Install and load it after deployment:

```sh
sudo install -m 0644 ~/.config/docker/rootlesskit.apparmor /etc/apparmor.d/dotfiles-rootlesskit
sudo apparmor_parser -r /etc/apparmor.d/dotfiles-rootlesskit
```

Repeat those two commands when a Nix update changes RootlessKit's store path.
Do not disable AppArmor or globally disable its user-namespace restriction.
On Ubuntu, the initial service start may fail until this profile is loaded;
the restart below clears the failure and retries.

Start the user service and open a fresh Fish shell:

```sh
systemctl --user daemon-reload
systemctl --user reset-failed docker.service
systemctl --user start docker.service
docker info
docker compose version
docker buildx version
```

`docker info` should show `rootless` under Security Options. Fish sets
`DOCKER_HOST` to `unix://$XDG_RUNTIME_DIR/docker.sock` only when no explicit
Docker host/context environment is present. For another engine, use
`docker --context CONTEXT ...` or explicitly export `DOCKER_CONTEXT`.
Using `docker context use` alone does not override `DOCKER_HOST`.
Do not use `sudo docker` for the rootless engine.

For boot-time startup and containers that keep running after logout, enable
lingering once, from Fish:

```fish
sudo loginctl enable-linger (id -un)
```

Modern Ubuntu and Arch normally use cgroup v2. Resource-limit flags also
depend on systemd's delegated controllers; this user service enables
`Delegate=true`, but it cannot change the host's delegation policy.
If startup fails, inspect `journalctl --user -u docker.service -b`.

## Retire An Existing Rootful Engine

After verifying rootless Docker and dealing with any containers that still
need the old engine, disable the system daemon and its socket:

```sh
sudo systemctl disable --now docker.service docker.socket
```

If your user is a member of the `docker` group, remove that access, from Fish:

```fish
sudo gpasswd -d (id -un) docker
```

Log out and back in so old sessions no longer retain group membership.
This is particularly relevant on Omarchy: choosing the rootless socket does
not remove the powerful access granted by an existing Docker-group membership.
Neither command deletes Docker data. Distribution updates or Omarchy tooling
may re-enable its own daemon, so recheck after those changes.

## Tailscale Login

The host's package supplies both `tailscaled` and `tailscale`, keeping their
versions aligned. Home Manager does not start a proxy-only Tailscale daemon.

```sh
sudo tailscale up
tailscale status
```

Follow the login URL. No authentication keys or Tailscale state belong in the
dotfiles repository.
Continue with [Tailscale setup](tailscale.md) to connect the MacBook and verify
connectivity between the two machines.

## References

- [Docker rootless prerequisites](https://docs.docker.com/engine/security/rootless/)
- [Docker rootless service and resource limits](https://docs.docker.com/engine/security/rootless/tips/)
- [RootlessKit AppArmor setup](https://rootlesscontaine.rs/getting-started/common/apparmor/)
- [Tailscale Linux installation](https://tailscale.com/docs/install/linux)
- [Omarchy Docker configuration](https://github.com/basecamp/omarchy/blob/dev/install/config/docker.sh)
