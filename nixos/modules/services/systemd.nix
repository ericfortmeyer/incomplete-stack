{ config, pkgs, lib, ... }:

{
  # Ensure we boot to multi-user.target (default for headless systems)
  systemd.defaultUnit = "multi-user.target";
}
