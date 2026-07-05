# nixos/modules/services/docker-storage.nix
{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.docker-storage;
in
{
  options.services.docker-storage = {
    enable = mkEnableOption "Docker cold storage management";

    coldStoragePath = mkOption {
      type = types.path;
      default = "/mnt/hdd-artifacts";
      description = "Base path for cold storage (HDD)";
    };

    buildCachePath = mkOption {
      type = types.path;
      default = "${cfg.coldStoragePath}/docker/buildx";
      description = "Buildx layer cache directory (on HDD)";
    };

    buildCacheMaxSize = mkOption {
      type = types.str;
      default = "500gb";
      description = "Maximum buildx cache size before GC";
    };

    buildCacheMaxAge = mkOption {
      type = types.str;
      default = "720h"; # 30 days
      description = "Max age for unused cache layers";
    };

    imageCachePath = mkOption {
      type = types.path;
      default = "${cfg.coldStoragePath}/docker/images";
      description = "Final image layers directory";
    };

    registryDataPath = mkOption {
      type = types.path;
      default = "/mnt/hdd-registry";
      description = "Local Docker registry storage";
    };
  };

  config = mkIf cfg.enable {
    # ─────────────────────────────────────────────────────────────────────────
    # Create HDD directories with proper ownership
    # ─────────────────────────────────────────────────────────────────────────
    systemd.tmpfiles.rules = [
      "d ${cfg.buildCachePath} 0750 root docker - -"
      "d ${cfg.imageCachePath} 0750 root docker - -"
      "d ${cfg.coldStoragePath} 0755 root root - -"
    ];

    # ─────────────────────────────────────────────────────────────────────────
    # Bind-mount HDD subdirs into Docker's namespace (SSD → HDD bridges)
    # ─────────────────────────────────────────────────────────────────────────
    fileSystems = {
      "/var/lib/docker/buildx-cache" = {
        device = cfg.buildCachePath;
        fsType = "none";
        options = [ "bind" "nofail" "defaults" ];
      };

      "/var/lib/docker/images" = {
        device = cfg.imageCachePath;
        fsType = "none";
        options = [ "bind" "nofail" "defaults" ];
      };
    };
  };
}
