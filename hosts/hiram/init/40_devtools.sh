#!/usr/bin/env bash
set -euo pipefail

USERS=(efortmeyer eric)
DEFAULT_NODE_MAJOR=24
NVM_VERSION="v0.40.4"

echo "[devtools] Installing VS Code..."
sudo apt install -y code

install_nvm_for_user() {
  local u="$1"
  local home
  home="$(getent passwd "$u" | cut -d: -f6)"

  echo "[devtools] Installing NVM for user '$u' in '$home'..."

  sudo -u "$u" bash -lc "
    set -e
    export HOME='$home'
    if [[ ! -d \"\$HOME/.nvm\" ]]; then
      curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash
    fi

    export NVM_DIR=\"\$HOME/.nvm\"
    [ -s \"\$NVM_DIR/nvm.sh\" ] && . \"\$NVM_DIR/nvm.sh\"

    nvm install ${DEFAULT_NODE_MAJOR}
    nvm alias default ${DEFAULT_NODE_MAJOR}

    echo \"[devtools] \$USER node: \$(node -v) npm: \$(npm -v)\"
  "
}

for u in "${USERS[@]}"; do
  if id -u "$u" >/dev/null 2>&1; then
    install_nvm_for_user "$u"
  else
    echo "[devtools] Skipping NVM install for missing user '$u'"
  fi
done

echo "[devtools] Done."
