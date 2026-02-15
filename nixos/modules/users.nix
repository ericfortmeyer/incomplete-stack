{ pkgs, projectRoot, ... }:
{
  users.mutableUsers = true;

  users.users.efortmeyer = {
    isNormalUser = true;
    group        = "users";
    extraGroups  = [ "wheel" "networkmanager" "docker" ];
    shell        = pkgs.zsh;
    openssh.authorizedKeys.keyFiles = [
      (projectRoot + /hosts/godel/authorized_keys/efortmeyer_godel_ed25519.pub)
      (projectRoot + /hosts/godel/authorized_keys/manna_godel_ed25519.pub)
    ];
  };

  programs.zsh.enable = true;
}
