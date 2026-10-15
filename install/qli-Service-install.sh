#!/usr/bin/env bash
#
# qubic.li client — install / update as a systemd service.
#
# Installs the LATEST released qli-Client from github.com/qubic-li/client into /q and
# runs it as the systemd service "qli". Re-running it updates in place.
#
# Usage:
#   qli-Service-install.sh <THREADS> <TOKEN|QUBIC_ADDRESS> [ALIAS]
#
#   <THREADS>        number of CPU threads the client may use
#   <TOKEN>          your access token, or your 60-character Qubic address (payout id)
#   [ALIAS]          optional name for this client (empty = the client picks one)
#
# Environment (optional):
#   QLI_VERSION=3.10.1       install this version instead of the latest
#   QLI_AUTO_UPDATE=true     let the client update itself (default: false; the
#                            -auto / -pps variants of this script set it to true)
#
# One-liner:
#   curl -fsSL https://raw.githubusercontent.com/qubic-li/client/main/install/qli-Service-install.sh | sudo bash -s -- <THREADS> <TOKEN> [ALIAS]
#
set -euo pipefail

REPO="qubic-li/client"
MIRROR="https://dl.qubic.li/downloads"
INSTALL_DIR=/q
EXE=qli-Client
SERVICE_SCRIPT=qli-Service.sh
SERVICE_FILE=/etc/systemd/system/qli.service
SETTINGS=appsettings.json

die() { echo "ERROR: $*" >&2; exit 1; }

if [[ $# -lt 2 || -z "${1:-}" || -z "${2:-}" ]]; then
    sed -n '9,14p' "$0" 2>/dev/null | sed 's/^# \{0,1\}//' || true
    die "need at least two arguments: <THREADS> <TOKEN|QUBIC_ADDRESS> [ALIAS]"
fi
threads=$1
token=$2
minerAlias=${3:-}
autoUpdate=${QLI_AUTO_UPDATE:-false}

[[ "$threads" =~ ^[0-9]+$ && "$threads" -gt 0 ]] || die "<THREADS> must be a positive number (got '$threads')"
[[ "$autoUpdate" == true || "$autoUpdate" == false ]] || die "QLI_AUTO_UPDATE must be true or false"
[[ $EUID -eq 0 ]] || die "run as root (or with sudo) — it installs a systemd service"
command -v systemctl >/dev/null 2>&1 || die "systemd is required (WSL: enable it first)"

# -----------------------------------------------------------------------------
# Download helpers — curl if present, else wget, so a minimal image works either way.
# -----------------------------------------------------------------------------
fetch() {   # fetch <url> <outfile>
    if command -v curl >/dev/null 2>&1; then curl -fsSL --retry 3 -o "$2" "$1"
    else wget -q -4 -O "$2" "$1"; fi
}
# The URL github.com/<repo>/releases/latest redirects to .../releases/tag/vX.Y.Z.
# Reading that redirect needs no API token, has no API rate limit and no jq.
latest_tag() {
    local url
    if command -v curl >/dev/null 2>&1; then
        url=$(curl -fsSLI -o /dev/null -w '%{url_effective}' "https://github.com/$REPO/releases/latest")
    else
        # --max-redirect=0 makes wget exit 8 on the redirect we are reading; that is
        # expected, so the status is discarded and only the Location header counts.
        url=$( { wget -q -S --spider --max-redirect=0 "https://github.com/$REPO/releases/latest" 2>&1 || true; } \
              | awk 'tolower($1)=="location:" {print $2; exit}')
    fi
    url=${url%%[[:space:]]*}
    [[ "$url" == */releases/tag/* ]] || return 1
    echo "${url##*/}"
}

# -----------------------------------------------------------------------------
# What to install
# -----------------------------------------------------------------------------
case "$(uname -m)" in
    x86_64|amd64)  platform=Linux-x64 ;;
    aarch64|arm64) platform=Linux-arm64 ;;
    *) die "unsupported CPU architecture $(uname -m) — only x86_64 and aarch64 builds exist" ;;
esac

if [[ -n "${QLI_VERSION:-}" ]]; then
    version=${QLI_VERSION#v}
else
    tag=$(latest_tag) || die "could not determine the latest release from github.com/$REPO — set QLI_VERSION=x.y.z to install a specific one"
    version=${tag#v}
fi
[[ "$version" =~ ^[0-9]+(\.[0-9]+)+$ ]] || die "unexpected version '$version'"
package="qli-Client-$version-$platform.tar.gz"
echo "Installing qli-Client $version ($platform) into $INSTALL_DIR, autoUpdate=$autoUpdate"

# -----------------------------------------------------------------------------
# Download + verify into a scratch dir FIRST. The running service is only touched once
# a complete, verified package is on disk — a failed download no longer leaves the
# miner stopped.
# -----------------------------------------------------------------------------
work=$(mktemp -d)
trap 'rm -rf -- "$work"' EXIT

downloaded=""
for base in "https://github.com/$REPO/releases/download/v$version" "$MIRROR"; do
    if fetch "$base/$package" "$work/$package" && fetch "$base/$package.sha256" "$work/$package.sha256"; then
        downloaded=$base; break
    fi
    echo "  not available from $base, trying the next source" >&2
done
[[ -n "$downloaded" ]] || die "could not download $package"
echo "  downloaded from $downloaded"

mkdir -p "$work/pkg"
tar -xzf "$work/$package" -C "$work/pkg"
[[ -f "$work/pkg/$EXE" ]] || die "$package does not contain $EXE"
# The .sha256 published with each release is the hash of the qli-Client BINARY (not of
# the archive), so verify after extracting.
expected=$(awk '{print $1; exit}' "$work/$package.sha256")
actual=$(sha256sum "$work/pkg/$EXE" | awk '{print $1}')
[[ -n "$expected" && "$actual" == "$expected" ]] || die "checksum mismatch for $EXE (expected $expected, got $actual) — not installing"
echo "  checksum verified ($actual)"

# -----------------------------------------------------------------------------
# Install
# -----------------------------------------------------------------------------
systemctl is-active --quiet qli && systemctl stop qli || true

mkdir -p "$INSTALL_DIR"
rm -f "$INSTALL_DIR"/qli-worker*.lock "$INSTALL_DIR"/workerConfig*.lock
cp -a "$work/pkg/." "$INSTALL_DIR/"

# JSON-escape user-supplied values: an alias containing " or \ used to produce a broken
# appsettings.json.
json_escape() { local s=${1//\\/\\\\}; s=${s//\"/\\\"}; printf '%s' "$s"; }
a=$(json_escape "$minerAlias"); t=$(json_escape "$token")
# A 60-character value is a Qubic address (payout id); anything longer is an access token.
if [[ ${#token} -ge 61 ]]; then
    auth="\"accessToken\": \"$t\""
else
    auth="\"accessToken\": null, \"qubicAddress\": \"$t\""
fi
cat > "$INSTALL_DIR/$SETTINGS" <<EOF
{"ClientSettings":{"poolAddress": "wss://wps.qubic.li/ws","trainer":{"cpuThreads": $threads},"alias": "$a",$auth, "autoUpdate": $autoUpdate}}
EOF
chmod 600 "$INSTALL_DIR/$SETTINGS"   # holds the token

cat > "$SERVICE_FILE" <<EOF
[Unit]
After=network-online.target
[Service]
StandardOutput=append:/var/log/qli.log
StandardError=append:/var/log/qli.error.log
ExecStart=/bin/bash $INSTALL_DIR/$SERVICE_SCRIPT
Restart=on-failure
RestartSec=1s
[Install]
WantedBy=default.target
EOF
chmod 644 "$SERVICE_FILE"
chmod u+x "$INSTALL_DIR/$SERVICE_SCRIPT" "$INSTALL_DIR/$EXE"

systemctl daemon-reload
systemctl enable --quiet qli
systemctl restart --no-block qli

# The classic flow downloads this script as ./qli-Service-install.sh; tidy it up as before.
[[ -f "qli-Service-install.sh" ]] && rm -f qli-Service-install.sh

echo "Done. qli-Client $version is running as service 'qli'."
echo "  status: systemctl status qli     logs: tail -f /var/log/qli.log"
