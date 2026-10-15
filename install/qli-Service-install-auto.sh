#!/usr/bin/env bash
#
# qubic.li client — install as a systemd service WITH auto-update.
# Same as qli-Service-install.sh, with QLI_AUTO_UPDATE=true. Kept under this name so
# existing cloud-init configs and the documented download URLs keep working.
#
# Usage: qli-Service-install-auto.sh <THREADS> <TOKEN|QUBIC_ADDRESS> [ALIAS]
#
set -euo pipefail
url="https://raw.githubusercontent.com/qubic-li/client/main/install/qli-Service-install.sh"
if command -v curl >/dev/null 2>&1; then script=$(curl -fsSL "$url")
else script=$(wget -q -4 -O - "$url"); fi
[[ -n "$script" ]] || { echo "ERROR: could not download $url" >&2; exit 1; }
QLI_AUTO_UPDATE="${QLI_AUTO_UPDATE:-true}" bash -c "$script" qli-Service-install.sh "$@"
