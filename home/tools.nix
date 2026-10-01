{ pkgs, ... }:
{
  home.packages = [ pkgs.less ];

  programs.bat = {
    enable = true;
    config.theme = "gruvbox";
    themes.gruvbox = {
      src = ../config/bat;
      file = "gruvbox.tmTheme";
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      version = 1;
      git_protocol = "https";
      prompt = "enabled";
      prefer_editor_prompt = "disabled";
      aliases.co = "pr checkout";
      color_labels = "disabled";
      accessible_colors = "disabled";
      accessible_prompter = "disabled";
      spinner = "enabled";
    };
  };

  programs.zed-editor = {
    enable = true;
    package = if pkgs.stdenv.hostPlatform.isDarwin then null else pkgs.zed-editor;
    mutableUserSettings = false;
    userSettings = {
      telemetry.metrics = false;
      vim_mode = true;
      ui_font_size = 16;
      buffer_font_size = 16;
      theme = {
        mode = "system";
        light = "One Light";
        dark = "Gruvbox Dark Hard";
      };
    };
  };

  programs.broot = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
    settings = builtins.fromTOML (builtins.readFile ../config/broot.conf.toml);
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    # LazyVim owns plugins and init.lua; do not generate a competing config.
    sideloadInitLua = true;
    plugins = [ ];
  };

  home.sessionVariables.PAGER = "less";

  programs.zellij = {
    enable = true;
    enableFishIntegration = false;
    enableBashIntegration = false;
    enableZshIntegration = false;
    extraConfig = builtins.readFile ../config/zellij/config.kdl;
    layouts = {
      four-panes = ../config/zellij/layouts/four-panes.kdl;
      sidebar = ../config/zellij/layouts/sidebar.kdl;
    };
  };
}
