{ ... }:
{
  # A local Home Manager role avoids SSH and passwordless sudo during Mac setup.
  machines.mac = {
    system = "aarch64-darwin";
    home-manager = import ./home/mac.nix;
  };
}
