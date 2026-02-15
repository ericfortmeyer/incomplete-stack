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
  # Zsh (oh-my-zsh + p10k) for godel (server-friendly, SSH-aware)
  # ─────────────────────────────────────────────────────────────────────────────
  programs.zsh = {
    enable = true;

    # Enable oh-my-zsh managed by Nix instead of manual $ZSH paths
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "docker" "zsh-autosuggestions" "zsh-syntax-highlighting" ];
      # We'll not load chucknorris on the server by default 😄
      theme = "powerlevel10k/powerlevel10k";
    };

    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    # Global /etc/zshrc add-ons (minimal noise; ssh-aware)
    shellInit = ''
      # Use plugins
      plugins=(docker zsh-autosuggestions zsh-syntax-highlighting git chucknorris)

      source $ZSH/oh-my-zsh.sh

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

      # Your commonly used envs (trimmed to practical server-side)
      export EDITOR=vim

      eval $(ssh-agent -s)

      # If you really need brew/go/node/deno paths here, set them per-host
      # or move them into Home Manager; keeping server PATHs lean is best.
    '';

    # Let powerlevel10k initialize if present
    promptInit = ''
      # If a per-user ~/.p10k.zsh exists, source it; otherwise fallback to a lean prompt
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
