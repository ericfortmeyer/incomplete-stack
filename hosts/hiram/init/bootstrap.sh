#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

bash "${REPO_ROOT}/hosts/hiram/init/10_users.sh"
bash "${REPO_ROOT}/hosts/hiram/init/20_apt_repos.sh"
bash "${REPO_ROOT}/hosts/hiram/init/30_docker.sh"
bash "${REPO_ROOT}/hosts/hiram/init/40_devtools.sh"
bash "${REPO_ROOT}/shared/scripts/restore_shell_configs.sh"
bash "${REPO_ROOT}/shared/scripts/install_oh_my_zsh.sh"



echo
echo "[hiram] ✅ Bootstrap complete."
echo "[hiram] NOTE: log out and log back in (for docker group membership)."
