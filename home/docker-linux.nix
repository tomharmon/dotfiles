{ config, lib, pkgs, ... }:
{
  assertions = [
    {
      assertion = pkgs.stdenv.hostPlatform.isLinux;
      message = "docker-linux.nix requires a Linux host.";
    }
  ];

  home.packages = [ pkgs.docker ];

  xdg.configFile."docker/daemon.json".source = (pkgs.formats.json { }).generate
    "docker-rootless-daemon.json" {
      "data-root" = "${config.xdg.dataHome}/docker";
    };

  # Install this profile as root on Ubuntu 24.04+; do not disable AppArmor.
  xdg.configFile."docker/rootlesskit.apparmor".text = ''
    abi <abi/4.0>,
    include <tunables/global>

    ${pkgs.rootlesskit}/bin/rootlesskit flags=(unconfined) {
      userns,
    }
  '';

  systemd.user.services.docker = {
    Unit = {
      Description = "Docker Application Container Engine (Rootless)";
      ConditionUser = "!root";
      StartLimitIntervalSec = 60;
      StartLimitBurst = 3;
    };
    Service = {
      Type = "notify";
      ExecStart = "${pkgs.docker}/bin/dockerd-rootless --config-file=${config.xdg.configHome}/docker/daemon.json";
      ExecReload = "${pkgs.procps}/bin/kill -s HUP $MAINPID";
      # The UID-map helpers must be privileged host binaries, not store copies.
      Environment = [
        "PATH=${lib.makeBinPath [ pkgs.coreutils pkgs.findutils pkgs.gnugrep pkgs.gnused pkgs.gawk pkgs.util-linux ]}:/run/wrappers/bin:/usr/bin:/bin"
      ];
      Restart = "on-failure";
      RestartSec = 2;
      TimeoutStartSec = 0;
      TimeoutStopSec = 120;
      LimitNOFILE = "infinity";
      LimitNPROC = "infinity";
      Delegate = true;
      NotifyAccess = "all";
      KillMode = "mixed";
    };
    Install.WantedBy = [ "default.target" ];
  };

  programs.fish.shellInit = lib.mkAfter ''
    if not set -q DOCKER_HOST; and not set -q DOCKER_CONTEXT; and set -q XDG_RUNTIME_DIR
        set -gx DOCKER_HOST "unix://$XDG_RUNTIME_DIR/docker.sock"
    end
  '';
}
