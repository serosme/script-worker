#!/usr/bin/env bash

set -euo pipefail

[ "$(id -u)" = 0 ] || { echo "Root privileges required." >&2; exit 1; }

CONF=/etc/wsl.conf
CONFIG='[interop]
enabled=false
appendWindowsPath=false'

printf '%s\n' "$CONFIG" > "$CONF"
echo "Done."
