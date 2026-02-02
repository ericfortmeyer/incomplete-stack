#!/usr/bin/env bash
set -euo pipefail

HOSTNAME="$(hostname -s 2>/dev/null || hostname)"

case "${HOSTNAME}" in
  hiram)
    echo "[setup] Running Hiram bootstrap..."
    bash hosts/hiram/init/bootstrap.sh
    ;;
  *)
    echo "[setup] Unknown host '${HOSTNAME}'."
    echo "Tip: run a host bootstrap directly, e.g.:"
    echo "  bash hosts/hiram/init/bootstrap.sh"
    exit 1
    ;;
esac
