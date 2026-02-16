{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wireguard-tools
    wireguard-go
    openresolv
    qrencode
    iproute2
    iptables
    nftables
  ];
}
