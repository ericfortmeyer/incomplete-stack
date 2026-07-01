{ config, ... }:

{
  imports = [
    ./base.nix
    ./gc.nix
    ./memory.nix
    ./networking.nix
    ./filesystems
    ./packages
    ./services
    ./shell
    ./users
  ];
}
