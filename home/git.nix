{ lib, ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    ignores = builtins.filter
      (line: line != "" && !(lib.hasPrefix "#" line))
      (lib.splitString "\n" (builtins.readFile ../config/.gitignore));
    settings = {
      user = {
        name = "Thomas Harmon";
        email = "thomas.alan.harmon@gmail.com";
      };
      gpg.program = "gpg";
      core.editor = "nvim";
      push.autoSetupRemote = true;
      rebase.autosquash = true;
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      features = "side-by-side line-numbers decorations";
      whitespace-error-style = "22 reverse";
      syntax-theme = "gruvbox";
      decorations = {
        commit-decoration-style = "bold yellow box ul";
        file-style = "bold yellow ul";
        file-decoration-style = "none";
      };
    };
  };
}
