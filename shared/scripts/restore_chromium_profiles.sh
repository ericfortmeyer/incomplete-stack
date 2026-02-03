#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

sudo -u eric cp -r "${REPO_ROOT}/shared/dotfiles/vscode/profiles" /home/eric/.config/Code/User/
sudo -u efortmeyer cp -r "${REPO_ROOT}/shared/dotfiles/vscode/profiles" /home/efortmeyer/.config/Code/User/
