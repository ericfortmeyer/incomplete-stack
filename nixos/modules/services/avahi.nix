{ config, ... }:

{
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      workstation = true;
      addresses = true;
      hinfo = true;
      domain = true;
    };
  };
}
