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
      server = {
        HostName = "server";
        User = "tom";
        IdentityFile = "~/.ssh/id_ed25519_hp_server";
      };
      truenas = {
        HostName = "truenas";
        User = "admin";
        IdentityFile = "~/.ssh/id_ed25519_nas";
      };
      proxmox = {
        HostName = "192.168.1.50";
        User = "root";
        IdentityFile = "~/.ssh/proxmox-ssh-key";
      };
    };
  };
}
