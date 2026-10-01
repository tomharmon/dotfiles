{ pkgs, homeManager }:
let
  home = homeManager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [
      ../home/fish.nix
      ../home/git.nix
      ../home/tools.nix
      ../home/ssh.nix
      {
        home.username = "fish-test";
        home.homeDirectory = "/tmp/dotfiles-fish-test";
        home.stateVersion = "26.05";
        programs.fish.generateCompletions = false;
        xdg.configFile."nvim" = {
          source = ../config/nvim;
          recursive = true;
        };
      }
    ];
  };
  cfg = home.config;
  generated = cfg.xdg.configFile."fish/config.fish";
in
assert cfg.programs.fish.enable;
assert cfg.programs.fish.package == pkgs.fish;
assert pkgs.lib.hasInfix "${cfg.home.profileDirectory}/bin" cfg.programs.fish.shellInit;
assert !(pkgs.lib.hasInfix ".cargo/bin" cfg.programs.fish.shellInit);
assert !(cfg.home.sessionVariables ? KUBECONFIG);
assert !(cfg.home.sessionVariables ? BUN_INSTALL);
assert cfg.programs.starship.enableFishIntegration;
assert cfg.programs.zoxide.enableFishIntegration;
assert pkgs.lib.hasInfix (builtins.readFile ../config/fish/theme.fish) cfg.programs.fish.interactiveShellInit;
assert pkgs.lib.hasInfix "devenv hook fish" cfg.programs.fish.interactiveShellInit;
assert !(pkgs.lib.hasInfix "devenv hook fish" cfg.programs.fish.shellInit);
assert cfg.programs.fish.shellAliases.gp == "git pull --rebase";
assert cfg.programs.git.lfs.enable;
assert cfg.programs.delta.enableGitIntegration;
assert builtins.elem "*.sql" cfg.programs.git.ignores;
assert builtins.elem "*.sqlite" cfg.programs.git.ignores;
assert cfg.programs.git.settings.user.name == "Thomas Harmon";
assert cfg.programs.bat.config.theme == "gruvbox";
assert cfg.programs.bat.themes.gruvbox.file == "gruvbox.tmTheme";
assert cfg.programs.gh.settings.git_protocol == "https";
assert cfg.programs.gh.settings.aliases.co == "pr checkout";
assert !cfg.programs.zed-editor.mutableUserSettings;
assert cfg.programs.zed-editor.userSettings.vim_mode;
assert cfg.programs.zed-editor.userSettings.theme.dark == "Gruvbox Dark Hard";
assert cfg.programs.zed-editor.package == null;
assert cfg.programs.ssh.package == pkgs.openssh;
assert cfg.programs.ssh.includes == [ ];
assert cfg.programs.ssh.settings.proxmox.data.IdentityFile == "~/.ssh/proxmox-ssh-key";
assert cfg.programs.broot.enableFishIntegration;
assert cfg.programs.broot.settings.skin == (builtins.fromTOML (builtins.readFile ../config/broot.conf.toml)).skin;
assert cfg.programs.starship.settings == builtins.fromTOML (builtins.readFile ../config/starship.toml);
assert cfg.programs.neovim.defaultEditor;
assert cfg.programs.neovim.plugins == [ ];
assert !(cfg.xdg.configFile."nvim/init.lua".enable or false);
assert cfg.home.sessionVariables.PAGER == "less";
assert cfg.home.sessionVariables.EDITOR == "nvim";
assert cfg.home.sessionVariables.VISUAL == "nvim";
assert cfg.home.sessionVariables.PNPM_HOME == (if pkgs.stdenv.hostPlatform.isDarwin then
  "/tmp/dotfiles-fish-test/Library/pnpm" else "/tmp/dotfiles-fish-test/.local/share/pnpm");
assert !cfg.programs.zellij.enableFishIntegration;
assert !cfg.programs.zellij.enableBashIntegration;
assert !cfg.programs.zellij.enableZshIntegration;
assert cfg.programs.zellij.layouts.sidebar == ../config/zellij/layouts/sidebar.kdl;
assert cfg.xdg.configFile."fish/conf.d/00-nix.fish".text != "";
assert builtins.all (entry: entry.assertion) cfg.assertions;
pkgs.runCommand "dotfiles-fish-check" { nativeBuildInputs = [ pkgs.fish ]; } ''
  fish --no-config --no-execute ${generated.source}
  fish --no-config ${../tests/fish-theme.fish} ${../config/fish/theme.fish}
  grep -q 'hm-session-vars.fish' ${generated.source}
  grep -q 'devenv hook fish' ${generated.source}
  grep -q 'starship.*init fish' ${generated.source}
  grep -q 'zoxide.*init fish' ${generated.source}
  if grep -q 'zellij.*setup.*auto-start' ${generated.source}; then
    echo 'Zellij must not launch automatically' >&2
    exit 1
  fi
  fish --no-config --no-execute ${pkgs.writeText "00-nix.fish" cfg.xdg.configFile."fish/conf.d/00-nix.fish".text}
  touch "$out"
''
