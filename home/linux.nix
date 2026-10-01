{ inputs }:
{ config, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  imports = [ ./common.nix ./docker-linux.nix ];

  home.username = "thomasharmon";
  home.homeDirectory = "/home/thomasharmon";

  targets.genericLinux.enable = true;
  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;

  xdg.configFile."ghostty/config".text = builtins.readFile ../config/ghostty.conf + ''
    command = ${config.home.profileDirectory}/bin/fish --login
  '';

  home.packages = (with pkgs; [
    _1password-gui
    code-cursor
    element-desktop
    firefox
    google-chrome
    signal-desktop
    ghostty
    nerd-fonts.hack
    obsidian
    spotify
    vscode
  ]) ++ [
    inputs.chatgpt-desktop.packages.${system}.default
    inputs.claude-desktop.packages.${system}.default
  ];

  xdg.desktopEntries.figma = {
    name = "Figma";
    genericName = "Collaborative Design";
    exec = "${pkgs.google-chrome}/bin/google-chrome-stable --app=https://www.figma.com/";
    terminal = false;
    categories = [ "Graphics" ];
  };
}
