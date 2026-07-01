{ config, ... }:

{
  imports = [
    ../../modules
    ./cpu.nix
    ./docker-registry.nix
    ./filesystems.nix
    ./firmware.nix
    ./grub.nix
    ./initrd.nix
    ./kernel.nix
    ./networking.nix
  ];
}
