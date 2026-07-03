{ config, pkgs, ... }:

{
  imports = [
    ./avahi.nix
    ./desktop-manager.nix
    ./display-manager.nix
    ./docker-registry.nix
    ./openssh.nix
    ./systemd.nix
    ./time.nix
    ./virtualisation.nix
    ./xserver.nix
  ];
}
