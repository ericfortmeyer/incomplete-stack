{ config, lib, ... }:

let
  # Replace these with `lsblk -f` or `blkid` output
  ssdBtrfsUUID = "REPLACE-SSD-BTRFS-UUID";
  hddBtrfsUUID = "REPLACE-HDD-BTRFS-UUID";

  # Good default Btrfs options
  ssdOpts = [ "noatime" "compress=zstd:3" "space_cache=v2" "ssd" ];
  hddOpts = [ "noatime" "compress=zstd:3" "space_cache=v2" "autodefrag" ];
in
{
  # --- SSD Btrfs filesystem with subvolumes ---
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/${ssdBtrfsUUID}";
    fsType = "btrfs";
    options = ssdOpts ++ [ "subvol=@root" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/${ssdBtrfsUUID}";
    fsType = "btrfs";
    options = ssdOpts ++ [ "subvol=@nix" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/${ssdBtrfsUUID}";
    fsType = "btrfs";
    options = ssdOpts ++ [ "subvol=@home" ];
  };

  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/${ssdBtrfsUUID}";
    fsType = "btrfs";
    options = ssdOpts ++ [ "subvol=@var" ];
  };

  # Optional: keep Docker on SSD explicitly (recommended)
  fileSystems."/var/lib/docker" = {
    device = "/dev/disk/by-uuid/${ssdBtrfsUUID}";
    fsType = "btrfs";
    options = ssdOpts ++ [ "subvol=@docker" ];
  };

  # --- HDD Btrfs filesystem mounted at /data for cold storage ---
  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/${hddBtrfsUUID}";
    fsType = "btrfs";
    options = hddOpts ++ [ "subvol=@data" ];
  };

  fileSystems."/data/backups" = {
    device = "/dev/disk/by-uuid/${hddBtrfsUUID}";
    fsType = "btrfs";
    options = hddOpts ++ [ "subvol=@backups" ];
  };

  fileSystems."/data/archives" = {
    device = "/dev/disk/by-uuid/${hddBtrfsUUID}";
    fsType = "btrfs";
    options = hddOpts ++ [ "subvol=@archives" ];
  };

  fileSystems."/data/media" = {
    device = "/dev/disk/by-uuid/${hddBtrfsUUID}";
    fsType = "btrfs";
    options = hddOpts ++ [ "subvol=@media" ];
  };

  # Optional: snapshots folder on HDD (or keep snapshots on SSD; your call)
  fileSystems."/data/snapshots" = {
    device = "/dev/disk/by-uuid/${hddBtrfsUUID}";
    fsType = "btrfs";
    options = hddOpts ++ [ "subvol=@snapshots" ];
  };
}
