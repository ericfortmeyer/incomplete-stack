{ pkgs, ... }:
{
  environment.defaultPackages = with pkgs; [
    gh
    git
    htop
    jq
    neovim
    vim
    yq
  ];
}
