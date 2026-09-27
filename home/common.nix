{ pkgs, ... }:
let
  cargoPackages = import ./cargo-packages.nix { inherit pkgs; };
in
{
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
    bat # Syntax-highlighted file viewer.
    bottom # Terminal system monitor.
    broot # Interactive directory navigator.
    bun # JavaScript runtime and package manager.
    cargo-chef # Cache Rust dependency builds in containers.
    cargo-dist # Build and publish release artifacts.
    cargo-edit # Edit Cargo dependencies from the CLI.
    cargo-expand # Show expanded Rust macros.
    cargo-generate # Create Rust projects from templates.
    cargo-leptos # Build Leptos web applications.
    cargo-license # List Cargo dependency licenses.
    cargo-make # Run Rust project tasks.
    cargo-update # Update Cargo-installed executables.
    cocogitto # Manage conventional commits and versions.
    delta # Show readable Git diffs.
    deno # JavaScript and TypeScript runtime.
    dioxus-cli # Build Dioxus web and native apps.
    dua # Inspect and reclaim disk space.
    dust # Summarize directory disk usage.
    eza # List files with richer metadata.
    fd # Find files and directories quickly.
    fish # Interactive command-line shell.
    flamegraph # Visualize profiling samples.
    git # Version control system.
    git-cliff # Generate changelogs from Git history.
    git-lfs # Store large Git files outside the repository.
    gnupg # Encrypt data and manage signing keys.
    grex # Generate regular expressions from examples.
    hyperfine # Benchmark command-line programs.
    jless # Interactively browse JSON.
    jq # Query and transform JSON.
    just # Run project command recipes.
    loco # Scaffold and develop Loco web apps.
    lsd # List files with colors and icons.
    mdbook # Build books from Markdown.
    mdbook-linkcheck2 # Check links in mdBook content.
    mdbook-mermaid # Render Mermaid diagrams in mdBook.
    neovim # Edit text and code.
    pnpm # Manage JavaScript packages and workspaces.
    pyenv # Switch between Python versions.
    ripgrep # Search text across files.
    rust-bindgen # Generate Rust bindings for C libraries.
    rust-cbindgen # Generate C bindings for Rust libraries.
    rustup # Manage Rust toolchains.
    sccache # Cache compiler outputs.
    sqlx-cli # Manage SQLx databases and migrations.
    starship # Render the shell prompt.
    tokei # Count lines of code by language.
    tree-sitter # Generate and test syntax parsers.
    uv # Manage Python packages and environments.
    worker-build # Build Cloudflare Workers Rust projects.
    wthrr # Show weather in the terminal.
    xan # Process CSV data from the shell.
    xh # Send HTTP requests from the CLI.
    zellij # Multiplex terminal sessions.
    zoxide # Jump to frequently used directories.
  ]) ++ builtins.attrValues cargoPackages;
}
