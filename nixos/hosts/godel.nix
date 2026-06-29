{ config, pkgs, lib, projectRoot, self, ... }:

{
  # ════════════════════════════════════════════════════════════════════════════
  # Host: godel
  # Purpose: Homelab NixOS with remote initrd‑SSH LUKS unlock
  # Notes:
  #   - Initrd networking is Ethernet‑only (no Wi‑Fi tooling in BusyBox initrd).
  #   - Broadcom NetLink (BCM57780) requires PHY first, then tg3 in stage‑1.
  #   - Use a dedicated initrd SSH host key (do not reuse the normal host keys).
  # ════════════════════════════════════════════════════════════════════════════

  networking.hostName = "godel";

  # ────────────────────────────────────────────────────────────────────────────
  # Imports (base modules)
  # Keep this lightweight; when the shape stabilizes, consider splitting modules.
  # ────────────────────────────────────────────────────────────────────────────
  imports = [
    ../modules/base.nix
    ../modules/memory.nix
    ../modules/networking.nix
    ../modules/filesystems
    ../modules/users
    ../modules/packages
    ../modules/services
    ../modules/shell
  ];

  # ────────────────────────────────────────────────────────────────────────────
  # Stage‑1 networking & SSH for remote unlock (initrd)
  # - DHCP in stage‑1: explicitly enable udhcpc (required on 23.11+)
  # - Publish hostname during initrd DHCP to allow `ssh root@godel -p 2222`
  # ────────────────────────────────────────────────────────────────────────────
  boot.kernelParams = [
    # ip=<client-ip>::<gateway>:<netmask>:<hostname>:<iface>:<autoconf>:<dns>
    "ip=192.168.4.47::192.168.4.1:255.255.255.0:godel:enp4s0:none:192.168.4.1"
  ];

  boot.initrd = {
    network = {
      enable = true;

      ssh = {
        enable = true;
        port = 2222;

        # Dedicated initrd host key material (NOT your normal host key)
        hostKeys = [ "/etc/ssh/initrd_host_ed25519" ];
        authorizedKeys =
          let
            mkCmdKey = pubkey: ''command="systemctl default" ${pubkey}'';
            keys = import ../authorized_keys.nix { inherit self; };
          in
          map mkCmdKey keys;
      };

    };

    # Map dedicated initrd host key into initrd
    secrets."/etc/ssh/initrd_host_ed25519" =
      lib.mkForce "/var/lib/initrd-ssh/host_ed25519";

    # ──────────────────────────────────────────────────────────────────────────
    # NIC drivers for initrd (order matters): Broadcom PHY first, then tg3 NIC
    # ──────────────────────────────────────────────────────────────────────────
    kernelModules = [ "broadcom" "tg3" ];

    # ──────────────────────────────────────────────────────────────────────────
    # LUKS (root) — remote unlock happens via initrd SSH
    # ──────────────────────────────────────────────────────────────────────────
    luks.devices."cryptroot" = {
      device = "/dev/disk/by-uuid/e49bf8ee-5993-48f7-8013-fee3fb14940d";
      allowDiscards = true;
    };

    # ──────────────────────────────────────────────────────────────────────────
    # Firmware required by tg3 (tigon) — include in initrd explicitly
    # ──────────────────────────────────────────────────────────────────────────
    extraFirmwarePaths = [
      "tigon/tg3.bin"
      "tigon/tg3_tso.bin"
      "tigon/tg3_tso5.bin"
      "tigon/tg357766.bin"
    ];
  };

  # ────────────────────────────────────────────────────────────────────────────
  # Stage‑2: ensure Broadcom PHY module is available after switch to real root
  # ────────────────────────────────────────────────────────────────────────────
  boot.kernelModules = [ "broadcom" ];

  # ────────────────────────────────────────────────────────────────────────────
  # Firmware plumbing (expose linux-firmware to kernel & initrd)
  # ────────────────────────────────────────────────────────────────────────────
  hardware.enableRedistributableFirmware = true;
  hardware.firmware = [ pkgs.linux-firmware ];

  # ────────────────────────────────────────────────────────────────────────────
  # Bootloader (BIOS + GPT with GRUB; copies kernels to /boot)
  # ────────────────────────────────────────────────────────────────────────────
  boot.loader.grub = {
    enable = true;
    device = "/dev/disk/by-path/pci-0000:00:1f.2-ata-2.0";
    forceInstall = true;
    copyKernels = true;
  };

  # ────────────────────────────────────────────────────────────────────────────
  # Filesystems
  # ────────────────────────────────────────────────────────────────────────────
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

  # ────────────────────────────────────────────────────────────────────────────
  # Future layout ideas (only if/when useful to you):
  #   - ./initrd-ssh.nix     (everything under boot.initrd.network + secrets)
  #   - ./filesystems.nix    (fileSystems + LUKS mapping)
  #   - ./firmware.nix       (hardware.* + NIC kernelModules)
  # Keep comments synced until it’s worth splitting.
  # ────────────────────────────────────────────────────────────────────────────
}
