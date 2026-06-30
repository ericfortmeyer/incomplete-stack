{
  description = "Gödel — My Homelab 🧪";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { nixpkgs, ... }:
  let
    system = "x86_64-linux";
    rootPath = ../.;
  in {
    nixosConfigurations.godel = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./hosts/godel
      ];
      specialArgs = {
        projectRoot = rootPath;
      };
    };
  };
}
