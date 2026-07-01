{ config, pkgs, ... }:

{
  imports = [
    ./avahi.nix
    ./desktopManager.nix
    ./displayManager.nix
    ./docker-registry.nix
    ./openssh.nix
    ./systemd.nix
    ./virtualisation.nix
    ./xserver.nix
  ];
}
