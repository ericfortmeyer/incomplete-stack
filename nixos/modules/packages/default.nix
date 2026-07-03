{ config, lib, pkgs, ... }:

{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  imports = [
    ./artifactory.nix
    ./aws.nix
    ./cli-qol.nix
    ./containers.nix
    ./dev-base.nix
    ./fp-stack.nix
    ./k8s-homelab.nix
    ./netops.nix
    ./php.nix
    ./secrets-management.nix
    ./shell.nix
    ./vpn-homelab.nix
  ];

  environment.defaultPackages = with pkgs; [
    perl
    rsync
    strace
  ];
}
