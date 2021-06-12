#!/bin/sh
set -e
set -x

SU="su $USERNAME -c "

#su $USERNAME -c "/home/benoit/src"

test -d "/home/$USERNAME/src/dotfiles" ||
    ($SU "git clone https://github.com/benoitj/dotfiles /home/$USERNAME/src/dotfiles" &&
        cd "/home/$USERNAME/src/dotfiles" &&
        $SU "git submodule init" &&
        $SU "git submodule update" &&
        $SU ./install.sh &&
        $SU "/home/$USERNAME/.config/doom-emacs/bin/doom sync")
