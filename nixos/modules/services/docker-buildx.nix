# nixos/modules/services/docker-buildx.nix
{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.docker-buildx;
  dockerCfg = config.services.docker-storage;
in
{
  options.services.docker-buildx = {
    enable = mkEnableOption "Docker Buildx with HDD cache";

    builderName = mkOption {
      type = types.str;
      default = "cold-storage";
      description = "Name of the buildx builder instance";
    };

    platforms = mkOption {
      type = types.listOf types.str;
      default = [ "linux/amd64" "linux/arm64" ];
      description = "Platforms to build for";
    };

    garbageCollectInterval = mkOption {
      type = types.str;
      default = "7d";
      description = "How often to run buildx cache GC";
    };
  };

  config = mkIf cfg.enable {
    environment.etc."buildkit/buildkitd.toml".text = ''
    root = "/var/lib/buildkit"
    [worker.oci]
      enabled = true
      gc = true
      reservedSpace = "30%"
      maxUsedSpace = "60%"
      minFreeSpace = "20GB"

    [[worker.oci.gcpolicy]]
      keepDuration = "168h"
      filters = [ "type==source.local", "type==exec.cachemount"]

    [[worker.oci.gcpolicy]]
      all = true
      keepDuration = "0s"
    '';
  };
}
