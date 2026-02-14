{ config, pkgs, lib, ... }:
{
  time.timeZone = "America/Denver";
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable flakes & new CLI inside Nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
