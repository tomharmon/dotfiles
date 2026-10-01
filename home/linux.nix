{ config, ... }:
{
  imports = [ ./common.nix ./docker-linux.nix ];

  home.username = "thomasharmon";
  home.homeDirectory = "/home/thomasharmon";

  targets.genericLinux.enable = true;
  # Desktop apps and graphics drivers belong to the host package manager.
  targets.genericLinux.gpu.enable = false;
  nixpkgs.config.allowUnfree = true;

  xdg.configFile."ghostty/config".text = builtins.readFile ../config/ghostty.conf + ''
    command = ${config.home.profileDirectory}/bin/fish --login
  '';

  xdg.desktopEntries.figma = {
    name = "Figma";
    genericName = "Collaborative Design";
    exec = "google-chrome-stable --app=https://www.figma.com/";
    settings.TryExec = "google-chrome-stable";
    terminal = false;
    categories = [ "Graphics" ];
  };
}
