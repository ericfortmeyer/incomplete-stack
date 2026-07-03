{
  # ─────────────────────────────────────────────────────────────────────────────
  # Zsh (Oh‑My‑Zsh + p10k) — clean, reproducible, no stray /etc edits required
  # ─────────────────────────────────────────────────────────────────────────────
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    histSize = 100000;
    setOptions = [
      "HIST_IGNORE_ALL_DUPS"
      "HIST_FIND_NO_DUPS"
      "EXTENDED_HISTORY"
      "SHARE_HISTORY"
    ];


    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;

    # OMZ will be sourced automatically; DO NOT source $ZSH/oh-my-zsh.sh yourself
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
        "man"
        "ssh-agent"
      ];
    };
  };
}
