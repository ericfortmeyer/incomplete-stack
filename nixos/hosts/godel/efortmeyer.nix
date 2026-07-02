# users + zsh module (e.g., in hosts/godel.nix or your per-host module)
{ pkgs, projectRoot, ... }:
{
  users.users.efortmeyer.openssh.authorizedKeys.keyFiles =
    let
      authorizedKeysDir = ./authorized_keys;
      keyFileNames = builtins.filter
        (name: builtins.match ".*\\.pub$" name != null)
        (builtins.attrNames (builtins.readDir authorizedKeysDir));
    in
    map (name: "${authorizedKeysDir}/${name}") keyFileNames;
}
