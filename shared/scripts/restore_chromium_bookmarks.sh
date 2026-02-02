#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SRC_DEFAULT="${REPO_ROOT}/assets/browser/chromium/Bookmarks.Default.json"

USERS=(efortmeyer eric)

restore_for_user() {
  local user="$1"
  local home dest_dir dest_file
  home="$(getent passwd "$user" | cut -d: -f6)"
  dest_dir="${home}/.config/chromium/Default"
  dest_file="${dest_dir}/Bookmarks"

  if [[ ! -f "${SRC_DEFAULT}" ]]; then
    echo "[chromium] Source bookmarks not found: ${SRC_DEFAULT}"
    return 1
  fi

  # Chromium should be closed for consistency
  if pgrep -u "$user" -f "chromium" >/dev/null 2>&1; then
    echo "[chromium] WARNING: Chromium appears to be running for ${user}."
    echo "          Close it before restoring bookmarks."
  fi

  echo "[chromium] Restoring bookmarks for ${user} -> ${dest_file}"
  sudo -u "$user" mkdir -p "${dest_dir}"
  sudo -u "$user" install -m 0644 "${SRC_DEFAULT}" "${dest_file}"
}

for u in "${USERS[@]}"; do
  if id -u "$u" >/dev/null 2>&1; then
    restore_for_user "$u"
  fi
done

echo "[chromium] ✅ Done."
