{ config, ... }:

{
  networking = {
    nameservers = [ "192.168.4.1" "8.8.8.8" ];
    networkmanager = {
      enable = true;
    };
  };
}
