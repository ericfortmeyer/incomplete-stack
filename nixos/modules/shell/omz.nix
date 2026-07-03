# users + zsh module (e.g., in hosts/godel.nix or your per-host module)
{ ... }:
{
  # OMZ will be sourced automatically; DO NOT source $ZSH/oh-my-zsh.sh yourself
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [
      "git"
      "docker"
      "man"
      "ssh-agent"
    ];
  };
}
