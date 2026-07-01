{ config, ... }:

{
  services.docker-registry = {
    enable = true;
    port = 5000;
    basicAuthFile = "/etc/docker-registry/secrets/htpasswd";
    tlsCert = "/etc/docker-registry/certs/cert.pem";
    tlsKey = "/etc/docker-registry/certs/key.pem";
    dataDir = "/mnt/hdd-registry";
    configDir = "/etc/docker-registry";
  };
}
