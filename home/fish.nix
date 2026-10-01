{ config, lib, pkgs, ... }:
{
  programs.fish = {
    enable = true;
    package = pkgs.fish;
    shellInit = ''
      if not set -q DEVENV_PROFILE
          fish_add_path --path --prepend ${lib.escapeShellArg "${config.home.profileDirectory}/bin"}
      end
    '';
    interactiveShellInit =
      builtins.readFile ../config/fish/theme.fish + "\n"
      + builtins.readFile ../config/fish/interactive.fish;
    shellAliases = {
      vim = "nvim";
      ga = "git add -u";
      gc = "git commit";
      gco = "git checkout";
      gp = "git pull --rebase";
      gl = "git log --all --decorate --oneline --graph";
      gs = "git status";
      gr = "git reset --soft";
      gd = "git diff";
      gu = "git reset --soft HEAD~1";
      ls = "eza -Fl --git-ignore";
      la = "eza -la";
      lt = "eza -laT -L 3 -I .git\\|.idea\\|target --git-ignore";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      j = "z";
      ji = "zi";
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = builtins.fromTOML (builtins.readFile ../config/starship.toml);
  };

  home.sessionVariables = {
    PNPM_HOME = if pkgs.stdenv.hostPlatform.isDarwin then
      "${config.home.homeDirectory}/Library/pnpm"
    else
      "${config.home.homeDirectory}/.local/share/pnpm";
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # conf.d runs before the generated config and its session setup.
  xdg.configFile."fish/conf.d/00-nix.fish".text = ''
    if not set -q __ETC_PROFILE_NIX_SOURCED; and test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    end
  '';
}
