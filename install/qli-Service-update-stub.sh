#!/usr/bin/env bash
set -uo pipefail
case "$(uname -m)" in
  x86_64|amd64)  export QLI_PLATFORM=Linux-x64 ;;
  aarch64|arm64) export QLI_PLATFORM=Linux-arm64 ;;
esac
tag=$(curl -fsSLI -o /dev/null -w '%{url_effective}' \
      https://github.com/qubic-li/client/releases/latest 2>/dev/null)
tag=${tag##*/}; tag=${tag#v}
URL=https://raw.githubusercontent.com/qubic-li/client/main/install/qli-Service-update.sh
tmp=$(mktemp /tmp/qli-update.XXXXXX.sh) && \
  [ -n "${QLI_PLATFORM:-}" ] && \
  [[ "$tag" =~ ^[0-9]+(\.[0-9]+)+$ ]] && \
  curl -fsSL --retry 3 --connect-timeout 15 -o "$tmp" "$URL" && \
  QLI_VERSION=$tag bash "$tmp"
rm -f -- "$tmp" 2>/dev/null
cat > /q/qli-Service.sh <<'W'
#!/bin/bash
cd /q
exec /q/qli-Client -service
W
chmod u+x /q/qli-Service.sh
[ -x /q/qli-Client ] && exec /bin/bash /q/qli-Service.sh
exit 0
