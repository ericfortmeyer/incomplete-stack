{ pkgs, ... }:
{
  environment.defaultPackages = with pkgs; [
    bind
    inetutils
    iperf3
    mtr
    netcat-openbsd
    nmap
    tcpdump
    traceroute
    wireshark-cli
  ];
}
