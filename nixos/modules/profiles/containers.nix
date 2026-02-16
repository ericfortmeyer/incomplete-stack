{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    docker-compose
    podman
    podman-compose
  ];
}
