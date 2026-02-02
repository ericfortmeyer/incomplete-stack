#!/usr/bin/env bash
set -euo pipefail

sudo -u cp -r shared/dotfiles/vscode/profiles /home/eric/.config/Code/User/
sudo -u efortmeyer cp -r shared/dotfiles/vscode/profiles /home/efortmeyer/.config/Code/User/
