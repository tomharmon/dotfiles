{ pkgs, ... }:
{
  imports = [ ./common.nix ];

  home.username = "thomasharmon";
  home.homeDirectory = "/Users/thomasharmon";

  home.packages = [ pkgs.cocoapods ];

  home.file."Library/Application Support/com.mitchellh.ghostty/config".source =
    ../config/ghostty.conf;
}
