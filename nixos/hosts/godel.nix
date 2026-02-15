{ config, pkgs, lib, ... }:

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
    ../modules/filesystems.nix
    ../modules/memory.nix
    ../modules/networking.nix
    ../modules/services.nix
    ../modules/users.nix
  ];

  # ────────────────────────────────────────────────────────────────────────────
  # Stage‑1 networking & SSH for remote unlock (initrd)
  # - DHCP in stage‑1: explicitly enable udhcpc (required on 23.11+)
  # - Publish hostname during initrd DHCP to allow `ssh root@godel -p 2222`
  # - MOTD flair: colorized Gödel‑Number banner via /root/.profile
  # ────────────────────────────────────────────────────────────────────────────
  boot.kernelParams = [ "ip=::::${config.networking.hostName}::dhcp" ];

  boot.initrd = {
    network = {
      enable = true;
      udhcpc.enable = true;
      flushBeforeStage2 = true;

      ssh = {
        enable = true;
        port = 2222;

        # Dedicated initrd host key material (NOT your normal host key)
        hostKeys = [ "/etc/ssh/initrd_host_ed25519" ];
        authorizedKeys = import ../../hosts/godel/authorized_keys.nix;

        # Present the unlock prompt immediately on login
        shell = "/bin/ash";
      };

      # ── Initrd MOTD: Gödel Numbers (colorized, BusyBox/printf‑safe) ─────────
      postCommands = ''
        cat > /root/.profile << 'EOF'

# ------------------------- Gödel-Number MOTD (initrd) --------------------------
# Use printf with ANSI escapes (BusyBox-safe) to avoid echo -e portability issues.
# Colors: CYAN header/body, YELLOW prompt, RESET at the end.

printf "\033[36m"  # set cyan
echo ""
echo "  ┌──────────────────────────────────────────────────────────────┐"
echo "  │        Gödel Numbering — godel initrd remote unlock          │"
echo "  ├──────────────────────────────────────────────────────────────┤"
echo "  │  Let ⟦ϕ⟧ denote the Gödel number of formula ϕ.               │"
echo "  │                                                              │"
echo "  │  Define the statement G such that:                           │"
echo "  │                                                              │"
echo "  │         G  ≡  ¬Provable( ⟦G⟧ )                               │"
echo "  │                                                              │"
echo "  │  i.e., G asserts its own unprovability via arithmetic        │"
echo "  │  encoded into ℕ.                                             │"
echo "  ├──────────────────────────────────────────────────────────────┤"
echo "  │  Current evaluation:                                         │"
echo "  │      Γ ⊢ Unlock(godel) : True   only if passphrase provided. │"
echo "  │                                                              │"
echo "  │  You now act as the external oracle deciding the truth       │"
echo "  │  of a statement the system cannot prove internally.          │"
echo "  └──────────────────────────────────────────────────────────────┘"
echo ""
printf "\033[33m"  # set yellow
echo "  godel:initrd > supply the oracle value (LUKS passphrase)…"
printf "\033[0m"   # reset
echo ""
# ------------------------------------------------------------------------------

# Hand off to the unlock prompt and leave the shell
exec /bin/cryptsetup-askpass
EOF
      '';
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
