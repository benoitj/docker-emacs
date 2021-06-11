#!/usr/bin/env bash
set -euo pipefail

USER="emacs"

${DOCKER:-docker} run -it --rm \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v "$HOME/.Xauthority:/home/$USER/.Xauthority" \
    -v "$HOME/src:/home/$USER/src" \
    -e DISPLAY="$DISPLAY" \
    -e USER="$USER" \
    -h "$HOSTNAME" \
    docker-emacs:latest "$@"
