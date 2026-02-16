{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gh
    git
    htop
    jq
    neovim
    vim
    yq
  ];
}
