# Tailscale: Linux Desktop And MacBook

Sign both machines into the same Tailscale account and tailnet (your private
Tailscale network). They can then connect using their Tailscale addresses from
different networks. Router port forwarding, an exit node, and subnet routing
are not needed to connect these two devices.

The Mac app is already declared as `tailscale-app` in the root `Brewfile`.
Linux uses the host's native package for both the CLI and privileged daemon;
[Linux host setup](linux-host.md) tracks installation and boot-time startup.
Home Manager does not install another Tailscale daemon. Login and device state
stay on each machine, outside the repository.

## Linux Desktop

On Omarchy, install the package if `tailscale` is missing:

```sh
omarchy pkg add tailscale
```

On plain Arch, use `sudo pacman -Syu --needed tailscale`. For Ubuntu, follow
the installation instructions in [Linux host setup](linux-host.md).
Then enable the service and sign in:

```sh
sudo systemctl enable --now tailscaled.service
sudo tailscale up
tailscale status
tailscale ip -4
```

Open the login URL printed by `tailscale up` and use the same account as the
MacBook. If device approval is enabled for the tailnet, approve the desktop in
the [Machines page](https://login.tailscale.com/admin/machines).
The service starts at boot and retains the login until it expires or is revoked.

This desktop's system hostname is `ivory`, and its Linux login user is `tom`.
Check `tailscale status` for its actual Tailscale name; an existing device with
the same name can cause Tailscale to add a suffix.

## MacBook

Install just Tailscale, or use the full Brewfile during normal Mac setup:

```sh
brew install --cask tailscale-app
open -a Tailscale
```

Follow the app's onboarding, approve the system extension and VPN configuration
when macOS requests them, and sign in to the same account and tailnet as Linux.
Ensure Tailscale is connected. Enable the app's launch-at-login option for
automatic reconnection when you sign in to the Mac.

For Terminal commands, install CLI integration from Tailscale's Settings.
This integration requires macOS Ventura 13 or later; see the
[CLI documentation](https://tailscale.com/docs/reference/tailscale-cli?tab=macos)
for other app variants. The Homebrew formula `tailscale` installs a separate
daemon and is not needed with this GUI app.

## Verify The Connection

On the MacBook, with CLI integration installed:

```sh
tailscale status
tailscale ping ivory
```

Replace `ivory` with the desktop's name from `tailscale status` if different.
Both machines should appear in the status output. On Linux, run
`tailscale ping MACBOOK_NAME` using the MacBook's name from the same output.
A direct connection or a DERP relay connection is valid; both are encrypted.

[MagicDNS](https://tailscale.com/docs/features/magicdns) lets applications use
device names such as `ivory`. Check that it is enabled in the tailnet's
[DNS settings](https://login.tailscale.com/admin/dns), and that both clients
accept Tailscale DNS. If name resolution fails, use the desktop's `100.x.y.z`
address from `tailscale ip -4` while troubleshooting.

## Optional: SSH From The Mac To Linux

Tailscale networking alone does not start an SSH server. To allow a terminal
session using Tailscale's identity-based SSH server, run on Linux:

```sh
sudo tailscale set --ssh
```

Then run on the Mac:

```sh
ssh tom@ivory
```

Tailscale SSH serves connections to the desktop's Tailscale address on port 22.
It does not require enabling the host's `sshd` service or copying an SSH key.
The tailnet policy must allow both network access to port 22 and Tailscale SSH
access to Linux user `tom`. The default policy supports connections between
devices owned by the same Tailscale user; a customized policy may need changes.
Follow a browser reauthentication prompt if the policy uses check mode.
Disable this server with `sudo tailscale set --ssh=false` when desired.

The Mac GUI app can act as a Tailscale SSH client. For SSH in the other
direction, enable macOS Remote Login for the intended Mac user and use ordinary
OpenSSH over the Mac's Tailscale address. The GUI app does not host a Tailscale
SSH server. This repository's Mac account is `thomasharmon`; verify the actual
account with `whoami` on the Mac before connecting.

## Troubleshooting

- **NeedsLogin / logged out:** run `sudo tailscale up` on Linux, or sign in
  through the Mac app. Confirm both clients have selected the same tailnet.
- **Daemon unavailable:** check `systemctl status tailscaled.service` and
  `journalctl -u tailscaled.service -b` on Linux.
- **Ping works but SSH fails:** enable an SSH server on the destination and
  check the tailnet's network and SSH policies. A successful Tailscale ping
  does not prove that an application port is reachable.
- **An application port is blocked:** inspect the host firewall and permit
  only the required traffic on `tailscale0`. Keep the firewall enabled.
- **A development web server is unreachable:** a server bound to `127.0.0.1`
  only accepts local connections. Bind it to the Tailscale address, use
  Tailscale Serve, or forward its port over SSH. For example, once SSH works,
  run `ssh -N -L 3000:127.0.0.1:3000 tom@ivory` on the Mac and open
  `http://localhost:3000` there.
- **Desktop unavailable after sleep:** it must remain awake and connected
  for remote access. Tailscale does not wake a sleeping computer.

## References

- [Tailscale Linux installation](https://tailscale.com/docs/install/linux)
- [Tailscale macOS installation](https://tailscale.com/docs/install/mac)
- [Tailscale CLI and macOS CLI integration](https://tailscale.com/docs/reference/tailscale-cli)
- [Tailscale SSH and access policies](https://tailscale.com/docs/features/tailscale-ssh)
