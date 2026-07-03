# users + zsh module (e.g., in hosts/godel.nix or your per-host module)
{ pkgs, ... }:
{
  imports = [
    ../shell/autocompletion.nix
    ../shell/omz.nix
    ../shell/p10k.nix
    ../shell/syntaxHighlighting.nix
  ];

  users.users.efortmeyer = {
    isNormalUser = true;
    group        = "users";
    extraGroups  = [ "wheel" "networkmanager" "docker" ];
    shell        = pkgs.zsh;
  };
}
