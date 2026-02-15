{ config, pkgs, lib, ... }:
{
  time.timeZone = "America/Denver";
  i18n.defaultLocale = "en_US.UTF-8";
  system.stateVersion = "25.11";

  # Enable flakes & new CLI inside Nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
