#!/usr/bin/env bash
set -euo pipefail

docker run -it --rm \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $HOME/.Xauthority:/home/emacs/.Xauthority \
    -v "$HOME/src":/home/emacs/src \
    -e DISPLAY="$DISPLAY" \
    -h $HOSTNAME \
    docker-emacs:latest
