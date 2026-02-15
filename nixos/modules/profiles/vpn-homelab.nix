{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wireguard-tools
    wireguard-go
    resolvconf
    qrencode
    iproute2
    iptables
    nftables
  ];
}
