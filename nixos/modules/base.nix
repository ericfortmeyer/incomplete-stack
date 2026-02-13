{ config, pkgs, lib, ... }:
{
  networking.hostName = "godel";
  time.timeZone = "America/Denver";
  i18n.defaultLocale = "en_US.UTF-8";

  # Boot (UEFI)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable flakes & new CLI inside Nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Option 1 (easy night-one): import the installer’s hardware config
  # imports = [ /etc/nixos/hardware-configuration.nix ];

  # Option 2: if you encoded filesystems in modules/filesystems.nix, leave imports empty.
}
