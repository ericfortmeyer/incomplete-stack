{ config, lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # IMPORTANT:
  # These are the LUKS *container* devices, not the Btrfs UUIDs.
  # After decrypt, you’ll have /dev/mapper/crypt-ssd and crypt-hdd which contain Btrfs.

  boot.initrd.luks.devices."crypt-ssd" = {
    device = "/dev/disk/by-uuid/REPLACE-SSD-LUKS-UUID";
    allowDiscards = true;  # good for SSD
  };

  boot.initrd.luks.devices."crypt-hdd" = {
    device = "/dev/disk/by-uuid/REPLACE-HDD-LUKS-UUID";
    allowDiscards = false; # usually irrelevant for HDD
  };

  # If you use systemd in initrd (modern default on NixOS), this is typically fine:
  boot.initrd.systemd.enable = true;

  # EFI partition example (replace UUID)
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/REPLACE-ESP-UUID";
    fsType = "vfat";
  };

  # Swap: optional. If you want swapfile on Btrfs SSD, do it later carefully.
  swapDevices = [ ];
}
