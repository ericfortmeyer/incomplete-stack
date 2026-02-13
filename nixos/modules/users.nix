{ config, pkgs, lib, ... }:
let
  efortmeyerKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC4S1JbkgQ3xXSQRwpfJH8zny48XeBu5u9WzuQh4rFap Clutch Property Management";

in {
  users.mutableUsers = true;

  users.users.efortmeyer = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    openssh.authorizedKeys.keys = [ efortmeyerKey ];
  };

  security.sudo.wheelNeedsPassword = false;  # flip to true if you want
}
