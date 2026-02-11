#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
CFG_DIR="${REPO_ROOT}/hosts/hiram/config"
PREV_APT_PACKAGES=docs/frankenstein/apt-manual.txt

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

if [[ ! -f /etc/apt/keyrings/sury-php.gpg ]]; then
  echo "[20_apt_repos] Installing PHP GPG key..."
  sudo curl -fsSL https://packages.sury.org/php/apt.gpg \
    | sudo tee /etc/apt/keyrings/sury-php.gpg >/dev/null
  sudo chmod 0644 /etc/apt/keyrings/sury-php.gpg
fi

if [[ ! -f /etc/apt/keyrings/slack.gpg ]]; then
  echo "[20_apt_repos] Installing Slack GPG key..."
  sudo install -d -m 0755 /etc/apt/keyrings
  curl -fsSL https://packagecloud.io/slacktechnologies/slack/gpgkey \
    | sudo tee /etc/apt/keyrings/slack.gpg >/dev/null
  sudo chmod 0644 /etc/apt/keyrings/slack.gpg
fi

for source_path in "${CFG_DIR}/*.sources"; do
    src=$(basename $source_path)
    echo "[20_apt_repos] Installing ${src} file..."
    sudo install -m 0644 "${CFG_DIR}/apt-sources/${src}" /etc/apt/sources.list.d/${src}
done


sudo apt update
sudo apt install debian-archive-keyring
xargs -a "$PREV_APT_PACKAGES"  sudo apt install -y

echo "[20_apt_repos] Done."
