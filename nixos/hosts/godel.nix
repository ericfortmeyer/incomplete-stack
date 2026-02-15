{ config, pkgs, lib, ... }:
{
  networking.hostName = "godel";
  imports = [
    ../modules/base.nix
    ../modules/filesystems.nix
    ../modules/memory.nix
    ../modules/networking.nix
    ../modules/services.nix
    ../modules/users.nix
  ];
  # initrd: enable ssh session while system boots
  boot.kernelParams = [ "ip=::::${config.networking.hostName}::dhcp" ];
  boot.initrd = {
    kernelModules = [
      "broadcom"
      "tg3"
    ];
    extraFirmwarePaths = [
      "tigon/tg3.bin"
      "tigon/tg3_tso.bin"
      "tigon/tg3_tso5.bin"
      "tigon/tg357766.bin"
    ];
    network = {
      enable = true;
      flushBeforeStage2 = true;
      udhcpc.enable = true;
      ssh = {
        enable = true;
        port = 2222;
        hostKeys = [ "/etc/ssh/initrd_host_ed25519" ];
        authorizedKeys = import ../../hosts/godel/authorized_keys.nix;
        shell = "/bin/cryptsetup-askpass";
      };
    };
    secrets."/etc/ssh/initrd_host_ed25519" =
      lib.mkForce "/var/lib/initrd-ssh/host_ed25519";
    luks.devices."cryptroot" = {
      device = "/dev/disk/by-uuid/e49bf8ee-5993-48f7-8013-fee3fb14940d";
      allowDiscards = true;
    };
  };
  hardware.enableRedistributableFirmware = true;
  hardware.firmware = [ pkgs.linux-firmware ];





  # BIOS + GPT: install GRUB to the disk MBR; copy kernels to /boot (ext4)
  boot.loader.grub = {
    enable = true;
    device = "/dev/disk/by-path/pci-0000:00:1f.2-ata-2.0";
    forceInstall = true;
    copyKernels = true;
  };

  # fileSystems."/srv" = {
  #   device = "/dev/disk/by-uuid/<HDD_UUID>";
  #   fsType = "btrfs";
  # }

  # fileSystems."/var/log" = {
  #   device = "/srv/logs/local";
  #   fsType = "none";
  #   options = [ "bind" ];
  # };

  fileSystems."/" =
    { device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/bc9b4b81-0d8c-4340-86fc-bcd57ba6bc92";
      fsType = "ext4";
    };

  fileSystems."/home" =
    { device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

}
