{ inputs, ... }:
let
  # The nixpkgs CLI can lag behind the machines API used by this configuration.
  devenvOverlay = final: prev: {
    devenv =
      let
        cli = inputs.nixpkgs-cli.legacyPackages.${prev.stdenv.hostPlatform.system}.devenv;
      in
      assert prev.lib.assertMsg (prev.lib.versionAtLeast cli.version "2.4")
        "The Home Manager devenv CLI must support machines (devenv 2.4+).";
      cli;
  };
in
{
  machines.mac = {
    system = "aarch64-darwin";
    home-manager = {
      imports = [ ./home/mac.nix ];
      nixpkgs.overlays = [ devenvOverlay ];
    };
  };

  machines.linux = {
    system = "x86_64-linux";
    home-manager = {
      imports = [ ./home/linux.nix ];
      nixpkgs.overlays = [ devenvOverlay ];
    };
  };
}
