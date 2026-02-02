#!/usr/bin/env bash
set -euo pipefail

PERSONAL_USER="efortmeyer"
WORK_USER="eric"

SUDO_PERSONAL=1
SUDO_WORK=1

ensure_user() {
  local u="$1"
  if id -u "$u" >/dev/null 2>&1; then
    echo "[users] User '$u' already exists."
  else
    echo "[users] Creating user '$u'..."
    sudo adduser --gecos "" "$u"
  fi
}

add_group() {
  local u="$1" g="$2"
  echo "[users] Adding '$u' to group '$g'..."
  sudo usermod -aG "$g" "$u"
}

ensure_user "$PERSONAL_USER"
ensure_user "$WORK_USER"

if [[ "$SUDO_PERSONAL" -eq 1 ]]; then add_group "$PERSONAL_USER" sudo; fi
if [[ "$SUDO_WORK" -eq 1 ]]; then add_group "$WORK_USER" sudo; fi

echo "[users] Done."
