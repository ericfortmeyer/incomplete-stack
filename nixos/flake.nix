{
  description = "Fleet of NixOS systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { nixpkgs, ... }:
  let
    system = "x86_64-linux";
    rootPath = ../.;
  in {
    nixosConfigurations.godel = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./hosts/godel.nix
      ];
      specialArgs = {
        projectRoot = rootPath;
      };
    };
  };
}
