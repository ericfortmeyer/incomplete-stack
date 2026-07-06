{ config, ... }:
{
  networking = {
    hostName = "godel";
    firewall = {
      allowedTCPPorts = [
        22
        config.services.docker-registry.port
      ];
    };
  };
}
