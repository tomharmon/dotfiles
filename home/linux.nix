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
  fonts.fontconfig.enable = true;

  xdg.configFile."ghostty/config".source = ../config/ghostty.conf;

  home.packages = (with pkgs; [
    _1password-cli # Nixpkgs prefixes both 1Password names with _ because Nix identifiers cannot start with a digit.
    _1password-gui
    claude-code
    code-cursor
    codex
    cursor-cli
    docker-client # Includes Compose and Buildx; the daemon is host-managed.
    element-desktop
    ghostty
    nerd-fonts.hack
    obsidian
    spotify
    tailscale
    vscode
  ]) ++ [
    inputs.chatgpt-desktop.packages.${system}.default
    inputs.claude-desktop.packages.${system}.default
  ];
}
