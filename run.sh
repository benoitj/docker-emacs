#!/bin/sh
set -e

${DOCKER:-docker} run -it \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v "$HOME/.Xauthority:/home/$USER/.Xauthority" \
    -v "$(pwd)/init.d:/init.d" \
    -e DISPLAY="$DISPLAY" \
    -h "$HOSTNAME" \
    benoitj/docker-emacs-dotfiles:latest "$@"
