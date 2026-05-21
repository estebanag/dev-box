#!/bin/bash
set -e

# Validation
: "${GIT_USER_EMAIL:?GIT_USER_EMAIL must be set in .env}"
: "${GIT_USER_NAME:?GIT_USER_NAME must be set in .env}"
: "${WORKSPACE_DIR:?WORKSPACE_DIR must be set in .env}"

# Derive UID/GID from the mounted workspace ownership
HOST_UID="$(stat -c '%u' /workspace)"
HOST_GID="$(stat -c '%g' /workspace)"

# 1. Adjust ubuntu user UID/GID to match host user
groupmod -g "$HOST_GID" ubuntu
usermod -u "$HOST_UID" ubuntu

# 2. Fix ownership of home directory after UID/GID shift
chown -R ubuntu:ubuntu /home/ubuntu

# 3. Fix ownership of workspace mount
chown ubuntu:ubuntu /workspace

# 4. Apply git identity
gosu ubuntu git config --global user.email "$GIT_USER_EMAIL"
gosu ubuntu git config --global user.name "$GIT_USER_NAME"

# 5. Overlay nvim custom config from bind-mount
if [ -d /tmp/nvim-custom ] && [ "$(ls -A /tmp/nvim-custom)" ]; then
  cp -r /tmp/nvim-custom/. /home/ubuntu/.config/nvim/
  chown -R ubuntu:ubuntu /home/ubuntu/.config/nvim
fi

# 6. Start D-Bus session bus at a fixed socket path (as ubuntu, before privilege drop)
su -c 'dbus-daemon --session --address=unix:path=/tmp/dbus-session.sock --fork --nopidfile' ubuntu

# 7. Drop privileges and exec CMD
exec gosu ubuntu "$@"
