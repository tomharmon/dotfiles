{ pkgs, ... }:
let
  cargoPackages = import ./cargo-packages.nix { inherit pkgs; };
in
{
  imports = [ ./fish.nix ./git.nix ./tools.nix ./ssh.nix ];

  home.stateVersion = "26.05";

  xdg.enable = true;
  xdg.configFile = {
    "fish/functions/obswiki.fish".source = ../config/fish/functions/obswiki.fish;
    "fish/functions/wt.fish".source = ../config/fish/functions/wt.fish;
    "fish/functions/fisher.fish".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/jorgebucaran/fisher/a6bf0e5b9e356d57d666bc6def114f16f1e5e209/functions/fisher.fish";
      sha256 = "59640d07bda182f2ad0fdfe9dc8a799fb79f46e6e5fc460354ffe2e21f759688";
    };
    "worktrunk/config.toml".source = ../config/worktrunk.toml;
    "nvim" = {
      source = ../config/nvim;
      recursive = true;
    };
  };

  home.file.".vimrc".source = ../config/.vimrc;

  home.packages = (with pkgs; [
    _1password-cli
    claude-code
    codex
    cursor-cli
    bottom # Terminal system monitor.
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
    deno # JavaScript and TypeScript runtime.
    devenv # Project environments and native shell auto-activation.
    dioxus-cli # Build Dioxus web and native apps.
    dua # Inspect and reclaim disk space.
    dust # Summarize directory disk usage.
    eza # List files with richer metadata.
    fastlane # Automate mobile build and release workflows.
    fd # Find files and directories quickly.
    ffmpeg # Convert and inspect audio and video.
    flamegraph # Visualize profiling samples.
    flyctl # Deploy and manage Fly.io applications.
    git-cliff # Generate changelogs from Git history.
    gnupg # Encrypt data and manage signing keys.
    grex # Generate regular expressions from examples.
    hyperfine # Benchmark command-line programs.
    imagemagick # Convert and process images.
    jless # Interactively browse JSON.
    jq # Query and transform JSON.
    just # Run project command recipes.
    k9s # Browse and manage Kubernetes clusters interactively.
    kubectl # Manage Kubernetes resources.
    kubernetes-helm # Install and manage Helm charts.
    loco # Scaffold and develop Loco web apps.
    mdbook # Build books from Markdown.
    mdbook-linkcheck2 # Check links in mdBook content.
    mdbook-mermaid # Render Mermaid diagrams in mdBook.
    nodejs_24 # Global Node.js fallback; projects can pin their own version.
    opentofu # Manage infrastructure as code.
    pgcli # PostgreSQL client with completion and syntax highlighting.
    pnpm # Manage JavaScript packages and workspaces.
    ripgrep # Search text across files.
    rust-bindgen # Generate Rust bindings for C libraries.
    rust-cbindgen # Generate C bindings for Rust libraries.
    rustup # Manage Rust toolchains.
    sccache # Cache compiler outputs.
    sqlx-cli # Manage SQLx databases and migrations.
    stripe-cli # Develop and test Stripe integrations.
    swiftlint # Lint Swift code on macOS and Linux.
    tokei # Count lines of code by language.
    tree-sitter # Generate and test syntax parsers.
    typst # Typeset documents.
    uv # Manage Python packages and environments.
    watchman # Watch project files for development tools.
    worker-build # Build Cloudflare Workers Rust projects.
    worktrunk # Manage Git worktrees with shell integration.
    wthrr # Show weather in the terminal.
    xan # Process CSV data from the shell.
    xh # Send HTTP requests from the CLI.
    yt-dlp # Download media from supported sites.
  ]) ++ builtins.attrValues cargoPackages;
}
