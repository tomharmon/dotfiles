{ inputs }:
{ pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  imports = [ ./common.nix ];

  home.username = "thomasharmon";
  home.homeDirectory = "/home/thomasharmon";

  targets.genericLinux.enable = true;
  nixpkgs.config.allowUnfree = true;

  home.packages = (with pkgs; [
    _1password-gui
    code-cursor
    element-desktop
    ghostty
    obsidian
    spotify
    tailscale
    vscode
  ]) ++ [
    inputs.chatgpt-desktop.packages.${system}.default
    inputs.claude-desktop.packages.${system}.default
  ];
}
