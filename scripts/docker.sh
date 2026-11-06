#!/usr/bin/env bash

set -euo pipefail

[ "$(id -u)" = 0 ] || { echo "Root privileges required." >&2; exit 1; }

curl -fsSL https://get.docker.com -o get-docker.sh

export DOWNLOAD_URL=https://mirrors.cernet.edu.cn/docker-ce
sh get-docker.sh

rm -f get-docker.sh

if [ -n "${SUDO_USER:-}" ]; then
    usermod -aG docker "$SUDO_USER"
    echo "User '$SUDO_USER' added to the 'docker' group. Re-login or run 'newgrp docker'."
else
    echo "Running as root directly."
fi
