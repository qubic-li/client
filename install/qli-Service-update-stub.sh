#!/usr/bin/env bash
# qli-Client update bootstrap stored as TrainerClient.UpdateScript in Redis.
# Everything real lives in qli-Service-update.sh in the install/ dir of
# qubic-li/client; this stub just fetches it. Only the QLI_VERSION line
# changes between releases.
set -uo pipefail
export QLI_VERSION=3.13.3.0
case "$(uname -m)" in
  x86_64|amd64)  export QLI_PLATFORM=Linux-x64 ;;
  aarch64|arm64) export QLI_PLATFORM=Linux-arm64 ;;
esac
URL=https://raw.githubusercontent.com/qubic-li/client/main/install/qli-Service-update.sh
tmp=$(mktemp /tmp/qli-update.XXXXXX.sh) && \
  curl -fsSL --retry 3 --connect-timeout 15 -o "$tmp" "$URL" && \
  [ -n "${QLI_PLATFORM:-}" ] && \
  bash "$tmp"
rm -f -- "$tmp" 2>/dev/null
# Fallback: central script was unreachable, or arch is unknown. Restore the
# 45-byte wrapper and keep the existing qli-Client running.
cat > /q/qli-Service.sh <<'W'
#!/bin/bash
cd /q
exec /q/qli-Client -service
W
chmod u+x /q/qli-Service.sh
[ -x /q/qli-Client ] && exec /bin/bash /q/qli-Service.sh
exit 0
