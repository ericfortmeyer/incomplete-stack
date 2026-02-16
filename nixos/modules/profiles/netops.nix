{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
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
