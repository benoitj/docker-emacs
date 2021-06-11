#!/usr/bin/env bash
set -euo pipefail

docker build -t benoitj/docker-emacs:latest .
docker build -f Dockerfile.dotfiles -t benoitj/docker-emacs-dotfiles:latest .
