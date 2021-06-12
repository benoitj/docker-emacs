#!/bin/sh

if test "$(docker ps -qa -f name=docker-emacs)" != ""; then
    docker start docker-emacs
else
    docker run -it \
        --name "docker-emacs" \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v "$HOME/.Xauthority:/home/$USER/.Xauthority" \
        -v "$(pwd)/init.d:/init.d" \
        -e DISPLAY="$DISPLAY" \
        -h "$HOSTNAME" \
        benoitj/docker-emacs-dotfiles:latest "$@"
fi
