{ config, pkgs, lib, ... }:
{
  # Pre-headless GNOME configuration
  services.xserver.enable = true;
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = true;
      X11Forwarding = false;
    };
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      workstation = true;
      addresses = true;
      hinfo = true;
      domain = true;
    };
  };

  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
