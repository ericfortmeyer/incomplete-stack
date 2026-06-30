{ config, ... }:

{
  imports = [
    ./base.nix
    ./memory.nix
    ./networking.nix
    ./filesystems
    ./users
    ./packages
    ./services
    ./shell
  ];

}