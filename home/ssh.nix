{ pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    package = pkgs.openssh;
    enableDefaultConfig = false;
    settings = {
      pc = {
        HostName = "pc";
        User = "tom";
        IdentityFile = "~/.ssh/id_ed25519";
        AddressFamily = "inet";
      };
      "github.com" = {
        AddKeysToAgent = "yes";
        IdentityFile = "~/.ssh/id_ed25519";
      };
      proxmox = {
        HostName = "192.168.1.50";
        User = "root";
        IdentityFile = "~/.ssh/proxmox-ssh-key";
      };
      ivory = {
        HostName = "ivory";
        User = "tom";
        IdentityFile = "~/.ssh/id_ed25519";
        IdentitiesOnly = true;
      };
      elitedesk = {
        HostName = "192.168.1.53";
        User = "thomasharmon";
        IdentityFile = "~/.ssh/id_ed25519";
        IdentitiesOnly = true;
      };
      elitedesk-unlock = {
        HostName = "192.168.1.53";
        Port = 2222;
        User = "root";
        IdentityFile = "~/.ssh/id_ed25519";
        IdentitiesOnly = true;
        HostKeyAlias = "elitedesk-unlock";
      };
      k3s-services = {
        HostName = "100.89.30.58";
        User = "thomasharmon";
        IdentityFile = "~/.ssh/id_ed25519";
        IdentitiesOnly = true;
        UserKnownHostsFile = "~/code/self-hosted/.local/known_hosts";
        HostKeyAlias = "192.168.1.52";
      };
    };
  };
}
