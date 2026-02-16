{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bat
    eza
    fd
    fzf
    hyperfine
    ripgrep
    sd
    zoxide
  ];
}
