{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
    ./efortmeyer.nix
    ./root.nix
  ];
}
