{ pkgs, ... }:
{
  environment.defaultPackages = with pkgs; [
    wireguard-tools
    wireguard-go
    openresolv
    qrencode
    iproute2
    iptables
    nftables
  ];
}
