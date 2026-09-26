{ pkgs, ... }:
{
  home.username = "thomasharmon";
  home.homeDirectory = "/Users/thomasharmon";
  home.stateVersion = "26.05";

  xdg.enable = true;
  xdg.configFile = {
    "fish/config.fish".source = ../config/fish/config.fish;
    "fish/functions/obswiki.fish".source = ../config/fish/functions/obswiki.fish;
    "fish/functions/wt.fish".source = ../config/fish/functions/wt.fish;
    "alacritty/alacritty.toml".source = ../config/alacritty/alacritty.toml;
    "broot/conf.toml".source = ../config/broot.conf.toml;
    "starship.toml".source = ../config/starship.toml;
    "nvim" = {
      source = ../config/nvim;
      recursive = true;
    };
  };

  home.file.".gitconfig".source = ../config/.gitconfig;
  home.file.".gitignore".source = ../config/.gitignore;
  home.file.".vimrc".source = ../config/.vimrc;

  # The common CLI tools are managed by Nix. The rest of the observed Cargo
  # inventory is preserved in cargo-tools.tsv for a separate, opt-in install.
  home.packages = with pkgs; [
    bat
    bottom
    broot
    bun
    cbindgen
    delta
    deno
    fd
    fish
    git
    git-cliff
    git-lfs
    gnupg
    hyperfine
    jq
    just
    lsd
    mdbook
    neovim
    pnpm
    pyenv
    ripgrep
    rustup
    sccache
    starship
    tokei
    uv
    xh
    xsv
    zellij
    zoxide
  ];
}
