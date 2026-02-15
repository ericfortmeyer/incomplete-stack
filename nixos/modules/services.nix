{ config, pkgs, lib, ... }:
{
  # ─────────────────────────────────────────────────────────────────────────────
  # Headless server mode (no GUI)
  # ─────────────────────────────────────────────────────────────────────────────
  services.xserver.enable = false;           # Ensure no X11 stack
  services.displayManager.enable = false;    # Just in case (DM abstraction)
  services.desktopManager.enable = false;    # Just in case (DE abstraction)

  # Ensure we boot to multi-user.target (default for headless systems)
  # Not usually necessary to set explicitly, but leaving as doc:
  # systemd.defaultUnit = "multi-user.target";

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
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
