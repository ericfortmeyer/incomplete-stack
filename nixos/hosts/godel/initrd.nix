{ config, pkgs, lib, ... }:

{
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
            keys = [
              (builtins.readFile ./authorized_keys/efortmeyer_godel_ed25519.pub)
              (builtins.readFile ./authorized_keys/manna_godel_ed25519.pub)
            ];

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
}
