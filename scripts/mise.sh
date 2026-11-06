#!/usr/bin/env bash

set -euo pipefail

[ "$(id -u)" = 0 ] || { echo "Root privileges required." >&2; exit 1; }

apt-get update
apt-get install -y extrepo
extrepo enable mise || true
apt-get update
apt-get install -y mise

cat <<'EOF'
As your normal user (not root), add mise to bash:

activation='eval "$(mise activate bash)"'
grep -qxF "$activation" ~/.bashrc 2>/dev/null || printf '%s\n' "$activation" >> ~/.bashrc

Then run 'source ~/.bashrc', or open a new terminal.
EOF
