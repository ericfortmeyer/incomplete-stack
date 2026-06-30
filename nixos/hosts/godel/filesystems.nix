{ config, ... }:

{
  # Encrypted SSD Unlock
  fileSystems."/" = {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    options = [ "subvol=@" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/bc9b4b81-0d8c-4340-86fc-bcd57ba6bc92";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    options = [ "subvol=@home" ];
  };

  # Encrypted HDD unlock (automatic, no password prompt)
  systemd.cryptsetup.hdd-storage = {
    device = "/dev/sdb5";
    keyFile = "/root/.luks-keys/hdd-cold-storage.key";
  };

  # Mount btrfs subvolumes
  fileSystems."/mnt/hdd-registry" = {
    device = "/dev/mapper/hdd-storage";
    fsType = "btrfs";
    options = [ "subvol=@registry" "compress=zstd:3" "noatime" ];
  };

  fileSystems."/mnt/hdd-artifacts" = {
    device = "/dev/mapper/hdd-storage";
    fsType = "btrfs";
    options = [ "subvol=@artifacts" "compress=zstd:3" "noatime" ];
  };

  fileSystems."/mnt/hdd-scratch" = {
    device = "/dev/mapper/hdd-storage";
    fsType = "btrfs";
    options = [ "subvol=@scratch" "compress=zstd:3" "noatime" ];
  };
}
