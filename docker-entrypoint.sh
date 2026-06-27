#!/bin/bash
set -e

# Validation
: "${GIT_USER_EMAIL:?GIT_USER_EMAIL must be set in .env}"
: "${GIT_USER_NAME:?GIT_USER_NAME must be set in .env}"
: "${WORKSPACE_DIR:?WORKSPACE_DIR must be set in .env}"

# 1. Apply git identity
gosu ubuntu git config --global user.email "$GIT_USER_EMAIL"
gosu ubuntu git config --global user.name "$GIT_USER_NAME"

# 2. Overlay nvim custom config from bind-mount
if [ -d /tmp/nvim-custom ] && [ "$(ls -A /tmp/nvim-custom)" ]; then
  cp -r /tmp/nvim-custom/. /home/ubuntu/.config/nvim/
  chown -R ubuntu:ubuntu /home/ubuntu/.config/nvim
fi

# 3. Start D-Bus session bus at a fixed socket path (as ubuntu, before privilege drop)
su -c 'dbus-daemon --session --address=unix:path=/tmp/dbus-session.sock --fork --nopidfile' ubuntu

# 4. Drop privileges and exec CMD
exec gosu ubuntu "$@"
