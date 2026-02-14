{
  description = "Fleet of NixOS systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs, ... }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.godel = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./hosts/godel.nix          # <- singular host file
        ./modules/base.nix
        ./modules/users.nix
        ./modules/services.nix
        ./modules/filesystems.nix
      ];
      specialArgs = {
        projectRoot = self;
      };
    };
  };
}
