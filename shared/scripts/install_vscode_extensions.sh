#!/usr/bin/env bash
set -euo pipefail

EXT_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dotfiles/vscode_extensions.txt"

if [[ ! -f "$EXT_FILE" ]]; then
  echo "Extension list not found: $EXT_FILE"
  exit 1
fi

install_for_user() {
  local user="$1"
  echo "[vscode] Installing extensions for user: $user"

  sudo -u "$user" bash -lc "
    if ! command -v code >/dev/null; then
      echo 'VS Code not installed for $user'
      exit 1
    fi
  "

  sudo -u "$user" xargs -n 1 code --install-extension < "$EXT_FILE"
}

install_for_user efortmeyer
install_for_user eric

echo "[vscode] Extension installation complete."
