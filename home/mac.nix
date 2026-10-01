{ config, pkgs, ... }:
{
  imports = [ ./common.nix ];

  home.username = "thomasharmon";
  home.homeDirectory = "/Users/thomasharmon";

  home.packages = [ pkgs.cocoapods pkgs.docker-client ];

  home.file."Library/Application Support/com.mitchellh.ghostty/config".text =
    builtins.readFile ../config/ghostty.conf + ''
      command = ${config.home.profileDirectory}/bin/fish --login
    '';
}
