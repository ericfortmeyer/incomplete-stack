#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DOTFILES="${REPO_ROOT}/shared/dotfiles/shell"

USERS=(efortmeyer eric)

restore_for_user() {
  local user="$1"
  local home
  home="$(getent passwd "$user" | cut -d: -f6)"

  echo "[shell] Restoring configs for $user"

  # zshrc
  if [[ -f "${DOTFILES}/zshrc" ]]; then
    sudo -u "$user" install -m 0644 "${DOTFILES}/zshrc" "${home}/.zshrc"
  fi

  # bashrc
  if [[ -f "${DOTFILES}/bashrc" ]]; then
    sudo -u "$user" install -m 0644 "${DOTFILES}/bashrc" "${home}/.bashrc"
  fi
}

for u in "${USERS[@]}"; do
  if id -u "$u" &>/dev/null; then
    restore_for_user "$u"
  fi
done

echo "[shell] Done."
