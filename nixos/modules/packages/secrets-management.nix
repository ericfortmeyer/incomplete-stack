{ lib, pkgs, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "vault"
  ];

  environment.defaultPackages = with pkgs; [
    vault
  ];
}
