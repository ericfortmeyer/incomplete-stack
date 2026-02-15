{ config, pkgs, lib, ... }:
{
  # Ensure p10k + zsh plugins are available
  environment.systemPackages = with pkgs; [
    htop
    git
    oh-my-zsh
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-powerlevel10k
  ];
}
