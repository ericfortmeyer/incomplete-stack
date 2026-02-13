{ config, lib, pkgs, ... }:
let
  # Replace with your real identifiers after install:
  efiUUID = "XXXX-YYYY";          # from blkid
  luksDevice = "/dev/nvme0n1p2";  # or "UUID=...."
in {
  boot.initrd.luks.devices.cryptroot = {
    device = luksDevice;
    preLVM = true;
    allowDiscards = true;
  };

  fileSystems."/" = {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    options = [ "subvol=@"
                "compress=zstd" "ssd" "noatime" "space_cache=v2" ];
  };

  fileSystems."/home" = {
    device = "/dev/mapper/cryptroot"; fsType = "btrfs";
    options = [ "subvol=@home" "compress=zstd" "ssd" "noatime" "space_cache=v2" ];
  };

  fileSystems."/nix" = {
    device = "/dev/mapper/cryptroot"; fsType = "btrfs";
    options = [ "subvol=@nix" "compress=zstd" "ssd" "noatime" "space_cache=v2" ];
  };

  fileSystems."/var/log" = {
    device = "/dev/mapper/cryptroot"; fsType = "btrfs";
    options = [ "subvol=@log" "compress=zstd" "ssd" "noatime" "space_cache=v2" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/${efiUUID}";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  zramSwap = {
    enable = true;
    memoryPercent = 20;
    priority = 100;
  };
}
