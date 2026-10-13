#!/bin/bash
set -euo pipefail

version=2.45.4
# Digest published by the upstream GitHub release asset API for xcodegen.zip.
checksum=090ec29491aad50aec10631bf6e62253fed733c50f3aab0f5ffc86bc170bdbef
install_dir="${1:?Usage: install_xcodegen.sh DESTINATION}"
mkdir -p "$install_dir"
curl --fail --location --silent --show-error \
  "https://github.com/yonaskolb/XcodeGen/releases/download/$version/xcodegen.zip" \
  --output "$install_dir/xcodegen.zip"
printf '%s  %s\n' "$checksum" "$install_dir/xcodegen.zip" | shasum -a 256 -c -
unzip -q -o "$install_dir/xcodegen.zip" -d "$install_dir"
"$install_dir/xcodegen/bin/xcodegen" --version
