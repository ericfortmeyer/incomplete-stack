{ config, lib, ... }:

{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  imports = [
    ./cli-qol.nix
    ./containers.nix
    ./dev-base.nix
    ./fp-stack.nix
    ./k8s-homelab.nix
    ./netops.nix
    ./php.nix
    ./shell.nix
    ./vpn-homelab.nix
  ];
}
