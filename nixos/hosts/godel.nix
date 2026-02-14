{ config, pkgs, lib, ... }:
{
  networking.hostName = "godel";
  networking.useDHCP = true;

  imports = [ 
    /etc/nixos/hardware-configuration.nix
    ../modules/base.nix
    ../modules/filesystems.nix
    ../modules/services.nix
    ../modules/user.nix
  ];

  # BIOS + GPT: install GRUB to the disk MBR; copy kernels to /boot (ext4)
  boot.loader.grub = {
    enable = true;
    device = "/dev/disk/by-id/ata-PNY_CS900_500GB_SSD_PNY24142404020100794";
    forceInstall = true;
    copyKernels = true;
  };

}
