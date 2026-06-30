{ config, pkgs, ... }:

{
  # ────────────────────────────────────────────────────────────────────────────
  # Firmware plumbing (expose linux-firmware to kernel & initrd)
  # ────────────────────────────────────────────────────────────────────────────
  hardware.enableRedistributableFirmware = true;
  hardware.firmware = [ pkgs.linux-firmware ];
}
