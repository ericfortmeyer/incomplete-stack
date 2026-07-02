{ config, ... }:

{
  imports = [
    ../../modules
    ./cpu.nix
    ./docker-registry.nix
    ./efortmeyer.nix
    ./filesystems.nix
    ./firmware.nix
    ./grub.nix
    ./initrd.nix
    ./kernel.nix
    ./networking.nix
  ];
}
