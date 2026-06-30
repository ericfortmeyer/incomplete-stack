{ config, ... }:

{
  fileSystems = {
    "/" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/bc9b4b81-0d8c-4340-86fc-bcd57ba6bc92";
      fsType = "ext4";
    };

    "/home" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

    "/mnt/hdd-registry" = {
      device = "/dev/mapper/hdd-storage";
      fsType = "btrfs";
      options = [ "subvol=@registry" "compress=zstd:3" "noatime" ];
    };

    "/mnt/hdd-artifacts" = {
      device = "/dev/mapper/hdd-storage";
      fsType = "btrfs";
      options = [ "subvol=@artifacts" "compress=zstd:3" "noatime" ];
    };

    "/mnt/hdd-scratch" = {
      device = "/dev/mapper/hdd-storage";
      fsType = "btrfs";
      options = [ "subvol=@scratch" "compress=zstd:3" "noatime" ];
    };
  };
}
