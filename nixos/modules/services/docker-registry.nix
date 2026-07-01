{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.docker-registry;
in
{
  options.services.docker-registry = {
    enable = mkEnableOption "Docker Registry v2";

    port = mkOption {
      type = types.int;
      default = 5000;
      description = "Port to listen on";
    };

    basicAuthFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to htpasswd file";
    };

    tlsCert = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to TLS certificate";
    };

    tlsKey = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to TLS private key";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/registry";
      description = "FHS-compliant data directory for image blobs";
    };

    configDir = mkOption {
      type = types.path;
      default = "/etc/docker-registry";
      description = "FHS-compliant config directory";
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0755 registry registry - -"
      "d ${cfg.configDir} 0755 registry registry - -"
    ];

    users.users.registry = {
      description = "Docker Registry user";
      isSystemUser = true;
      group = "registry";
      home = cfg.dataDir;
    };

    users.groups.registry = {};

    environment.etc."docker-registry/config.yml".text =
      let
        authBlock = optionalString (cfg.basicAuthFile != null) ''
          auth:
            htpasswd:
              realm: Docker Registry
              path: ${cfg.basicAuthFile}
        '';
        tlsBlock = optionalString (cfg.tlsCert != null && cfg.tlsKey != null) ''
          tls:
            certificate: ${cfg.tlsCert}
            key: ${cfg.tlsKey}
        '';
      in
      ''
        version: 0.1
        log:
          level: info
          format: json
        storage:
          filesystem:
            rootdirectory: ${cfg.dataDir}
        http:
          addr: :${toString cfg.port}
          ${tlsBlock}
          headers:
            X-Content-Type-Options:
              - nosniff
        ${authBlock}
      '';

    systemd.services.docker-registry = {
      description = "Docker Registry";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [
        "multi-user.target"
      ];

      serviceConfig = {
        Type = "simple";
        User = "registry";
        Group = "registry";
        ExecStart = "${pkgs.distribution}/bin/registry serve /etc/docker-registry/config.yml";
        Restart = "on-failure";
        RestartSec = "5s";

        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = cfg.dataDir;
      };
    };

    environment.systemPackages = [ pkgs.distribution ];
  };
}
