{ config, ... }:

{
  imports = [
    ../../modules
    ./filesystems.nix
    ./firmware.nix
    ./grub.nix
    ./initrd.nix
    ./kernel.nix
    ./networking.nix
  ];
}
