{ ... }:
{
  system.primaryUser = "thomasharmon";
  system.stateVersion = 6;

  homebrew = {
    enable = true;
    user = "thomasharmon";
    greedyCasks = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "none";
    };
    casks = [
      "1password"
      "chatgpt"
      "claude"
      "cursor"
      "element"
      "ghostty"
      "obsidian"
      "spotify"
      "tailscale"
      "visual-studio-code"
    ];
  };
}
