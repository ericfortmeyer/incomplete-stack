#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
CFG_DIR="${REPO_ROOT}/hosts/hiram/config"

echo "[20_apt_repos] Ensuring /etc/apt/sources.list.d exists..."
sudo mkdir -p /etc/apt/sources.list.d
sudo mkdir -p /etc/apt/keyrings

# Install Microsoft key + vscode.sources (preferred modern approach)
# If you already have the key on Frankenstein, export it once and commit it here,
# OR re-fetch it during bootstrap (more common).
if [[ ! -f /etc/apt/keyrings/microsoft.gpg ]]; then
  echo "[20_apt_repos] Installing Microsoft GPG key..."
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/microsoft.gpg >/dev/null
  sudo chmod 0644 /etc/apt/keyrings/microsoft.gpg
fi

if [[ -f "${CFG_DIR}/apt-sources/vscode.sources" ]]; then
  echo "[20_apt_repos] Installing VS Code sources file..."
  sudo install -m 0644 "${CFG_DIR}/apt-sources/vscode.sources" /etc/apt/sources.list.d/vscode.sources
else
  echo "[20_apt_repos] Missing ${CFG_DIR}/apt-sources/vscode.sources"
  exit 1
fi

sudo apt update
xargs -a docs/frankenstein/apt-manual.txt sudo apt install -y

echo "[20_apt_repos] Done."
