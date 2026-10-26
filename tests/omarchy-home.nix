{ pkgs, homeManager }:
let
  home = homeManager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [
      ../home/fish.nix
      ../home/omarchy-fish.nix
      {
        home.username = "fish-test";
        home.homeDirectory = "/tmp/dotfiles-fish-test";
        home.stateVersion = "26.05";
        programs.fish.generateCompletions = false;
      }
    ];
  };
  cfg = home.config;
  init = cfg.xdg.configFile."fish/conf.d/init.fish".source;
in
assert pkgs.lib.hasInfix "env-bootstrap" cfg.programs.fish.shellInit;
assert pkgs.lib.hasInfix "setup-omarchy-fish.bash" cfg.home.activation.omarchyFish.data;
assert cfg.xdg.configFile."bash/omarchy-fish.bash".source == ../config/bash/omarchy-fish.bash;
assert !(pkgs.lib.hasInfix "starship init" (builtins.readFile init));
assert !(pkgs.lib.hasInfix "zoxide init" (builtins.readFile init));
assert !(pkgs.lib.hasInfix "mise activate" (builtins.readFile init));
assert cfg.programs.starship.enableFishIntegration;
assert cfg.programs.zoxide.enableFishIntegration;
assert !cfg.programs.bash.enable;
assert builtins.all (entry: entry.assertion) cfg.assertions;
pkgs.runCommand "dotfiles-omarchy-fish-check" {
  nativeBuildInputs = [ pkgs.bash pkgs.fish ];
} ''
  fish --no-config --no-execute ${cfg.xdg.configFile."fish/config.fish".source} ${init}
  bash ${../tests/omarchy-fish.bash} ${../scripts/setup-omarchy-fish.bash} ${../config/bash/omarchy-fish.bash}
  touch "$out"
''
