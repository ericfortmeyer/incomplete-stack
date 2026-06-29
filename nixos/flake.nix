{
  description = "Fleet of NixOS systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs, ... }:
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
        inherit self;
        projectRoot = rootPath;
      };
    };
  };
}
