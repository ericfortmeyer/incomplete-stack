#!/usr/bin/env bash
set -euo pipefail

ASSETS="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)/assets"

# User pictures
sudo install -m 0644 "${ASSETS}/userpics/efortmeyer.png" \
  /var/lib/AccountsService/icons/efortmeyer

sudo install -m 0644 "${ASSETS}/userpics/eric.png" \
  /var/lib/AccountsService/icons/eric

