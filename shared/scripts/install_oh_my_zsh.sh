#!/usr/bin/env bash
set -euo pipefail

install_for_user() {
  local user="$1"
  local home
  home="$(getent passwd "$user" | cut -d: -f6)"

  echo "[oh-my-zsh] Installing for user $user"

  sudo -u "$user" bash -lc "
    export HOME='$home'
    export RUNZSH=no
    export CHSH=no
    if [[ ! -d \"\$HOME/.oh-my-zsh\" ]]; then
      sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\"
    fi
  "
}

install_for_user efortmeyer
install_for_user eric

echo "[oh-my-zsh] Installation complete."
