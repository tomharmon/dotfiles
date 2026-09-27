{ pkgs, ... }:
let
  cargoPackages = import ./cargo-packages.nix { inherit pkgs; };
in
{
  home.username = "thomasharmon";
  home.homeDirectory = "/Users/thomasharmon";
  home.stateVersion = "26.05";

  xdg.enable = true;
  xdg.configFile = {
    "fish/config.fish".source = ../config/fish/config.fish;
    "fish/functions/obswiki.fish".source = ../config/fish/functions/obswiki.fish;
    "fish/functions/wt.fish".source = ../config/fish/functions/wt.fish;
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

  home.packages = (with pkgs; [
    bat
    bottom
    broot
    bun
    cargo-chef
    cargo-dist
    cargo-edit
    cargo-expand
    cargo-generate
    cargo-leptos
    cargo-license
    cargo-make
    cargo-update
    cbindgen
    cocogitto
    delta
    deno
    dioxus-cli
    dua
    dust
    eza
    fd
    fish
    flamegraph
    git
    git-cliff
    git-lfs
    gnupg
    grex
    hyperfine
    jless
    jq
    just
    loco
    lsd
    mdbook
    mdbook-linkcheck2
    mdbook-mermaid
    neovim
    pnpm
    pyenv
    ripgrep
    rust-bindgen
    rustup
    sccache
    sqlx-cli
    starship
    tokei
    tree-sitter
    uv
    worker-build
    wthrr
    xh
    xsv
    zellij
    zoxide
  ]) ++ builtins.attrValues cargoPackages;
}
