{
  # Minimal /etc/zshrc additions (interactive shells)
  programs.zsh.shellInit = ''
    # Less noisy ctrl-s/ctrl-q
    stty -ixon 2>/dev/null || true
  '';
}
