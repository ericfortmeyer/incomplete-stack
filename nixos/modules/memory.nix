{ config, lib, pkgs, ... }:
{
  zramSwap = {
    enable = true;
    memoryPercent = 20;
    priority = 100;
  };
}
