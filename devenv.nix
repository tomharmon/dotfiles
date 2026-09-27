{ ... }:
{
  machines.mac = {
    system = "aarch64-darwin";
    target.host = "thomasharmon@localhost";
    nix-darwin = import ./home/darwin.nix;
    home-manager = import ./home/mac.nix;
  };

  machines.linux = {
    system = "x86_64-linux";
    home-manager = import ./home/linux.nix;
  };
}
