# users + zsh module (e.g., in hosts/godel.nix or your per-host module)
{ pkgs, ... }:

{
  # Make zsh the default shell for root and your user
  users.users.root.shell = pkgs.zsh;
}
