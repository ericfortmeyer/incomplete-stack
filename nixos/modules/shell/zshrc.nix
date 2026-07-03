# users + zsh module (e.g., in hosts/godel.nix or your per-host module)
{ ... }:
{
  # Minimal /etc/zshrc additions (interactive shells)
  programs.zsh.shellInit = ''
    # Less noisy ctrl-s/ctrl-q
    stty -ixon 2>/dev/null || true

    # Aliases
    alias ll='ls -alF --color=auto'
    alias la='ls -A --color=auto'
    alias l='ls -CF --color=auto'

    # Tiny header when SSH-ing into godel (stage-2, not initrd)
    #if [ "$(hostname)" = "godel" ] && [ -n "$SSH_CONNECTION" ]; then
    #  printf "\033[36m==> Connected to godel (stage-2)\033[0m\n"
    #fi

    export EDITOR=vim
  '';
}
