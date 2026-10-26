{ lib, pkgs, ... }:
{
  programs.fish.shellInit = lib.mkAfter (builtins.readFile ../config/fish/omarchy.fish);

  xdg.configFile = {
    "bash/omarchy-fish.bash".source = ../config/bash/omarchy-fish.bash;
    # Fish's user conf.d overrides the official package's same-named snippet.
    "fish/conf.d/init.fish".source = ../config/fish/omarchy-init.fish;
  };

  home.activation.omarchyFish = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    if [ -d /usr/share/omarchy ]; then
      run ${pkgs.bash}/bin/bash ${../scripts/setup-omarchy-fish.bash}
    fi
  '';
}
