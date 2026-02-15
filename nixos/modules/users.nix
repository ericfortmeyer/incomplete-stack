# users + zsh module (e.g., in hosts/godel.nix or your per-host module)
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

  # ─────────────────────────────────────────────────────────────────────────────
  # Zsh (Oh‑My‑Zsh + p10k) — clean, reproducible, no stray /etc edits required
  # ─────────────────────────────────────────────────────────────────────────────
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    # Install external plugins declaratively
    plugins = [
      { name = "zsh-autosuggestions";     src = pkgs.zsh-autosuggestions;     }
      { name = "zsh-syntax-highlighting"; src = pkgs.zsh-syntax-highlighting; }
    ];

    # OMZ will be sourced automatically; DO NOT source $ZSH/oh-my-zsh.sh yourself
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "docker" ];  # keep OMZ's built-ins here only
      # Do NOT set 'theme' since we source p10k from Nix below.
    };

    # Minimal /etc/zshrc additions (interactive shells)
    shellInit = ''
      # History (XDG-friendly)
      HISTSIZE=100000
      SAVEHIST=100000
      setopt HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS EXTENDED_HISTORY SHARE_HISTORY

      # Less noisy ctrl-s/ctrl-q
      stty -ixon 2>/dev/null || true

      # Aliases
      alias ll='ls -alF --color=auto'
      alias la='ls -A --color=auto'
      alias l='ls -CF --color=auto'

      # Tiny header when SSH-ing into godel (stage-2, not initrd)
      if [ "$(hostname)" = "godel" ] && [ -n "$SSH_CONNECTION" ]; then
        printf "\033[36m==> Connected to godel (stage-2)\033[0m\n"
      fi

      export EDITOR=vim
    '';

    # Powerlevel10k from Nix store; DO NOT set ZSH_THEME
    promptInit = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      if [ -f ~/.p10k.zsh ]; then
        source ~/.p10k.zsh
      else
        autoload -Uz colors && colors
        PROMPT="%F{cyan}%n%f@%F{magenta}%m%f %F{yellow}%~%f %# "
      fi
    '';
  };

  # Make zsh the default shell for root and your user
  users.users.root.shell = pkgs.zsh;
}
