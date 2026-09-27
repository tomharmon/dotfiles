{ pkgs, ... }:
{
  imports = [ ./common.nix ];

  home.username = "thomasharmon";
  home.homeDirectory = "/home/thomasharmon";

  targets.genericLinux.enable = true;
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    _1password-gui
    code-cursor
    element-desktop
    ghostty
    obsidian
    spotify
    tailscale
    vscode
  ];
}
