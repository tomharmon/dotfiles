{ pkgs, homeManager }:
let
  home = homeManager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [
      ../home/docker-linux.nix
      {
        home.username = "docker-test";
        home.homeDirectory = "/home/docker-test";
        home.stateVersion = "26.05";
        xdg.enable = true;
        programs.fish.enable = true;
        programs.fish.generateCompletions = false;
      }
    ];
  };
  cfg = home.config;
  service = cfg.systemd.user.services.docker;
in
assert pkgs.stdenv.hostPlatform.isLinux;
assert builtins.all (entry: entry.assertion) cfg.assertions;
assert builtins.elem pkgs.docker cfg.home.packages;
assert service.Service.Type == "notify";
assert pkgs.lib.hasInfix "/bin/dockerd-rootless " (builtins.head service.Service.ExecStart);
assert service.Service.Delegate;
assert service.Service.NotifyAccess == "all";
assert service.Unit.ConditionUser == "!root";
assert service.Install.WantedBy == [ "default.target" ];
assert pkgs.lib.hasInfix "/run/wrappers/bin:/usr/bin:/bin" (builtins.head service.Service.Environment);
assert pkgs.lib.hasInfix "not set -q DOCKER_CONTEXT" cfg.programs.fish.shellInit;
assert pkgs.lib.hasInfix "unix://$XDG_RUNTIME_DIR/docker.sock" cfg.programs.fish.shellInit;
assert pkgs.lib.hasInfix "${pkgs.rootlesskit}/bin/rootlesskit" cfg.xdg.configFile."docker/rootlesskit.apparmor".text;
pkgs.runCommand "dotfiles-rootless-docker-check" { nativeBuildInputs = [ pkgs.fish ]; } ''
  fish --no-config --no-execute ${cfg.xdg.configFile."fish/config.fish".source}
  grep -q 'data-root' ${cfg.xdg.configFile."docker/daemon.json".source}
  fish --no-config -c '
    set -e DOCKER_HOST DOCKER_CONTEXT
    set -gx XDG_RUNTIME_DIR /run/user/1234
    source ${pkgs.writeText "docker-init.fish" cfg.programs.fish.shellInit}
    test "$DOCKER_HOST" = unix:///run/user/1234/docker.sock; or exit 1
    set -gx DOCKER_HOST tcp://remote:2376
    source ${pkgs.writeText "docker-init.fish" cfg.programs.fish.shellInit}
    test "$DOCKER_HOST" = tcp://remote:2376; or exit 1
    set -e DOCKER_HOST
    set -gx DOCKER_CONTEXT remote
    source ${pkgs.writeText "docker-init.fish" cfg.programs.fish.shellInit}
    set -q DOCKER_HOST; and exit 1
    set -e DOCKER_CONTEXT XDG_RUNTIME_DIR
    source ${pkgs.writeText "docker-init.fish" cfg.programs.fish.shellInit}
    set -q DOCKER_HOST; and exit 1
    exit 0
  '
  touch "$out"
''
