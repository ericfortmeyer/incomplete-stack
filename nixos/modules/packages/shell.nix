# keep this separate module or same file, your choice
{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    zsh
    oh-my-zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-powerlevel10k
  ];

  programs.ssh.startAgent = true;
}
