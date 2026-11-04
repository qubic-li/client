#!/usr/bin/env bash
set -uo pipefail

VERSION=${QLI_VERSION:?QLI_VERSION not set}
PLATFORM=${QLI_PLATFORM:?QLI_PLATFORM not set}
INSTALL=/q
EXE=qli-Client
WRAPPER=qli-Service.sh
SETTINGS=appsettings.json
PKG=qli-Client-${VERSION}-${PLATFORM}.tar.gz

cd "$INSTALL" || exit 0

restore_wrapper() {
  cat > "$INSTALL/$WRAPPER" <<'W'
#!/bin/bash
cd /q
exec /q/qli-Client -service
W
  chmod u+x "$INSTALL/$WRAPPER"
}
fail() {
  echo "qli-update: $*" >&2
  restore_wrapper
  [ -x "$INSTALL/$EXE" ] && exec /bin/bash "$INSTALL/$WRAPPER"
  exit 0
}

work=$(mktemp -d /tmp/qli-update.XXXXXX) || exit 0
trap 'rm -rf -- "$work"' EXIT

got=""
for base in "https://github.com/qubic-li/client/releases/download/v${VERSION}" "https://dl.qubic.li/downloads"; do
  if curl -fsSL --retry 3 --connect-timeout 15 -o "$work/$PKG" "$base/$PKG" \
  && curl -fsSL --retry 3 --connect-timeout 15 -o "$work/$PKG.sha256" "$base/$PKG.sha256"; then
    got=$base; break
  fi
done
[ -n "$got" ] || fail "download failed for $PKG"

mkdir -p "$work/pkg"
tar -xzf "$work/$PKG" -C "$work/pkg" || fail "extract failed"
[ -f "$work/pkg/$EXE" ] || fail "no $EXE in package"

expected=$(awk '{print $1; exit}' "$work/$PKG.sha256")
actual=$(sha256sum "$work/pkg/$EXE" | awk '{print $1}')
[ -n "$expected" ] && [ "$actual" = "$expected" ] || fail "checksum mismatch $actual vs $expected"

rm -f "$INSTALL"/*.lock "$INSTALL/qli-runner" "$INSTALL/qli-processor" 2>/dev/null || true

for f in "$work/pkg"/*; do
  name=$(basename "$f")
  [ "$name" = "$SETTINGS" ] && continue
  [ "$name" = "$WRAPPER" ] && continue
  cp -a "$f" "$INSTALL/.$name.new" || fail "cp $name"
  mv -f "$INSTALL/.$name.new" "$INSTALL/$name" || fail "mv $name"
done
chmod u+x "$INSTALL/$EXE"

restore_wrapper
exec /bin/bash "$INSTALL/$WRAPPER"
