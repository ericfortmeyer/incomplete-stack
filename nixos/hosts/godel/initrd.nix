{ config, pkgs, lib, ... }:

{
  boot.initrd = {
    network = {
      enable = true;

      ssh = {
        enable = true;
        port = 2222;

        # Dedicated initrd host key material (NOT your normal host key)
        hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519" ];
        authorizedKeys =
          let
            mkCmdKey = pubkey: ''command="systemctl default" ${pubkey}'';
            keys = [
              (builtins.readFile ./authorized_keys/efortmeyer_godel_ed25519.pub)
              (builtins.readFile ./authorized_keys/manna_godel_ed25519.pub)
            ];

          in
          map mkCmdKey keys;
      };

    };

    secrets = {
      "/luks-keys/hdd-cold-storage.key" = "/root/.luks-keys/hdd-cold-storage.key";
    };

    # ──────────────────────────────────────────────────────────────────────────
    # NIC drivers for initrd (order matters): Broadcom PHY first, then tg3 NIC
    # ──────────────────────────────────────────────────────────────────────────
    kernelModules = [ "broadcom" "tg3" ];
    availableKernelModules = [
      "ahci"
      "ehci_pci"
      "firewire_ohci"
      "sd_mod"
      "usb_storage"
      "usbhid"
    ];

    luks.devices = {
      # ──────────────────────────────────────────────────────────────────────────
      # LUKS (root) — remote unlock happens via initrd SSH
      # ──────────────────────────────────────────────────────────────────────────
      "cryptroot" = {
        device = "/dev/disk/by-uuid/e49bf8ee-5993-48f7-8013-fee3fb14940d";
        allowDiscards = true;
      };

      # ──────────────────────────────────────────────────────────────────────────
      # Encrypted HDD unlock (automatic, no password prompt)
      # ──────────────────────────────────────────────────────────────────────────
      "hdd-storage" = {
        device = "/dev/disk/by-uuid/be21076d-b869-4d32-9179-a6b167745169";
        keyFile = "/luks-keys/hdd-cold-storage.key";
      };
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
}
