{ pkgs, ... }:
{
  environment.defaultPackages = with pkgs; [
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
