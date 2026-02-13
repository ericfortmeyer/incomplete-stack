{ config, pkgs, lib, ... }:
{
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = false;
    };
  };

  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = true;
  environment.systemPackages = with pkgs; [ docker-compose ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
