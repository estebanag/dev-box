#!/bin/bash
set -e

# Fix display
if [[ -n "$DISPLAY" && "$DISPLAY" != :* ]] &&
  [ -n "$(docker compose ps --status running -q devbox 2>/dev/null)" ]; then
  DISP_NUM=$(echo "$DISPLAY" | sed 's/.*:\([0-9]*\).*/\1/')
  COOKIE=$(xauth list | awk -v n=":${DISP_NUM} " '$0 ~ n {print $3; exit}')
  docker compose exec --user ubuntu devbox \
    xauth add "localhost:${DISP_NUM}" MIT-MAGIC-COOKIE-1 "$COOKIE" >/dev/null 2>&1
  docker compose exec --user ubuntu devbox \
    tmux set-environment -g DISPLAY "$DISPLAY" >/dev/null 2>&1 || true
fi

docker compose exec --user ubuntu devbox byobu
