#!/usr/bin/env bash

set -euo pipefail

SSH_KEY="$HOME/.ssh/id_ed25519"
GIT_DIR="$HOME/.config/git"

usage() {
  cat >&2 <<'EOF'
Usage: curl -fsSL <url>/git | bash -s -- -n <name> -m <email>
EOF
}

main() {
  NAME="" EMAIL=""
  while getopts ':n:m:' o; do
    case "$o" in
      n) NAME="$OPTARG" ;;
      m) EMAIL="$OPTARG" ;;
      *) usage; exit 1 ;;
    esac
  done
  [ -n "$NAME" ] && [ -n "$EMAIL" ] || { usage; exit 1; }

  mkdir -p "$HOME/.ssh" "$GIT_DIR"

  if [ ! -f "$SSH_KEY" ]; then
    ssh-keygen -t ed25519 -f "$SSH_KEY" -N '' -q
    printf '==> created %s\n' "$SSH_KEY"
  fi

  cat >"$GIT_DIR/config" <<EOF
[init]
    defaultBranch = main
[core]
    quotepath = false
    longpaths = true
[color]
    ui = auto
[includeIf "gitdir:~/workspace/"]
    path = "~/.config/git/config-workspace"
[include]
    path = "~/.config/git/config.local"
EOF

  printf '[user]\n' >"$GIT_DIR/config-workspace"
  git config --file "$GIT_DIR/config-workspace" user.name "$NAME"
  git config --file "$GIT_DIR/config-workspace" user.email "$EMAIL"

  cat >"$HOME/.ssh/config" <<'EOF'
Include config.local
Host *
    ServerAliveInterval 60
Host github.com
    Hostname ssh.github.com
    Port 443
EOF

  cat "$SSH_KEY.pub"
}

main "$@"
