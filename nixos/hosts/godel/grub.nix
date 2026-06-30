{ config, ... }:

{
  # ────────────────────────────────────────────────────────────────────────────
  # Bootloader (BIOS + GPT with GRUB; copies kernels to /boot)
  # ────────────────────────────────────────────────────────────────────────────
  boot.loader.grub = {
    enable = true;
    device = "/dev/disk/by-path/pci-0000:00:1f.2-ata-2.0";
    forceInstall = true;
    copyKernels = true;
  };

}
