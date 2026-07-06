# nixos/modules/services/virtualisation.nix
{ config, pkgs, lib, ... }:

with lib;

let
  networkingCfg = config.networking;
  registryCfg = config.services.docker-registry;
  dockerCfg = config.virtualisation.docker;
  storageCfg = config.services.docker-storage;
in
{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;

    # ───────────────────────────────────────────────────────────────────────
    # Use btrfs for efficient snapshots + compression (matches your HDD fs)
    # ───────────────────────────────────────────────────────────────────────
    storageDriver = "btrfs";

    # ───────────────────────────────────────────────────────────────────────
    # Daemon options for optimal performance
    # ───────────────────────────────────────────────────────────────────────
    daemon.settings = {
      # Storage optimization for btrfs
      storage-driver = "btrfs";
      storage-opts = [
        "btrfs.min_space=2GB"
      ];

      # Logging
      log-driver = "local";
      log-opts = {
        "max-size" = "10m";
        "max-file" = "3";
      };

      # Insecure registry (your local one—adjust as needed)
      insecure-registries = [ 
        "127.0.0.1:${toString registryCfg.port}" 
        "localhost:${toString registryCfg.port}" 
        "${networkingCfg.hostName}:${toString registryCfg.port}" 
      ];

      registry-mirrors = [
        "http://${networkingCfg.hostName}:${toString registryCfg.port}" 
      ];

      # BuildKit for modern builds
      features = {
        buildkit = true;
      };

      builder = {
        gc = {
          enabled = true;
          policy = [
            {
              reservedSpace = "300GB";
              keepDuration = ["4320h"];
              filter = [
                "type=source.local"
              ];
            }
            {
              reservedSpace = "300GB";
              keepDuration = ["4320h"];
              filter = [
                "type=exec.cachemount"
              ];
            }
            {
              reservedSpace = "500GB";
            }
            {
              reservedSpace = "750GB";
              all = true;
            }
          ];
        };
      };
    };
  };

  # ─────────────────────────────────────────────────────────────────────────
  # Optionally wire in cold storage modules
  # ─────────────────────────────────────────────────────────────────────────
  services.docker-storage.enable = mkDefault true;
}
