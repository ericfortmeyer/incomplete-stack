{ pkgs, ... }:
{
  environment.defaultPackages = with pkgs; [
    jfrog-cli
  ];
}
