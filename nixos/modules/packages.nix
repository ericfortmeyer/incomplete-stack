# keep this separate module or same file, your choice
{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    htop
    git
    vim
    zsh
    oh-my-zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-powerlevel10k
  ];

  # (Optional) manage ssh-agent cleanly rather than eval $(ssh-agent -s) in each shell
  programs.ssh.startAgent = true;
}
