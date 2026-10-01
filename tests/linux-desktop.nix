let
  linux = import ../home/linux.nix {
    config.home.profileDirectory = "/test/profile";
  };
  tools = import ../home/tools.nix { pkgs.less = "less"; };
  readPackages = path:
    builtins.filter (line: line != "")
      (builtins.filter builtins.isString (builtins.split "\n" (builtins.readFile path)));
  native = readPackages ../packages/arch-desktop.txt;
  aur = readPackages ../packages/arch-desktop-aur.txt;
in
assert !(linux.home ? packages);
assert linux.targets.genericLinux.enable;
assert !linux.targets.genericLinux.gpu.enable;
assert tools.programs.zed-editor.package == null;
assert tools.programs.zed-editor.enable;
assert linux.xdg.desktopEntries.figma.exec == "google-chrome-stable --app=https://www.figma.com/";
assert linux.xdg.desktopEntries.figma.settings.TryExec == "google-chrome-stable";
assert native == [ "element-desktop" "firefox" "ghostty" "obsidian" "signal-desktop" "ttf-hack-nerd" "zed" ];
assert aur == [ "1password" "google-chrome" "spotify" "visual-studio-code-bin" ];
true
