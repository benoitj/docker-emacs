#!/bin/sh
set -e
#set -x

exitCode=1

incExitCode() {
        exitCode="$(echo $exitCode+1 | bc)"
}

create_group() {
        gid="$1"
        groupname="$2"

        test -n "$gid" -o -n "$groupname" || exit "$exitCode"

        getent group "$groupname" >/dev/null 2>&1 ||
                (groupadd -g "$gid" "$groupname" &&
                        echo "done creating group $groupname")
        incExitCode
}

create_user() {
        uid="$1"
        username="$2"
        groupname="$3"

        test -n "$uid" -o -n "$username" -o -n "$groupname" || exit "$exitCode"

        getent passwd "$username" >/dev/null 2>&1 ||
                (useradd -m -u "$uid" -g "$groupname" "$username" &&
                        echo "done creating user $username")
        incExitCode
}

enable_sudo() {
        username="$1"

        test -n "$username" || exit "$exitCode"

        test -f "/etc/sudoers.d/$username" ||
                (echo "emacs ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/emacs &&
                        echo "done enabling sudo for user $username")
        incExitCode

}

mkdir_xdg() {
        username="$1"
        groupname="$2"

        test -n "$username" -o -n "$groupname" || exit "$exitCode"

        for d in .cache .config .local; do
                d_path="/home/$username/$d"
                test -d "$d_path" ||
                        (mkdir "$d_path" &&
                                chown "$username:$groupname" "$d_path" &&
                                echo "created directore $d")
        done
        incExitCode

}

fix_ownership() {
        username="$1"
        groupname="$2"

        test -n "$username" -o -n "$groupname" || exit "$exitCode"

        chown "$username:$groupname" "/home/$username"
        incExitCode
}

#create_user() {
#        test ! -d "$HOME/src/dotfiles" &&
#                git clone https://github.com/benoitj/dotfiles src/dotfiles &&
#                cd src/dotfiles &&
#                git submodule update &&
#                ./install.sh
#}

create_group "$GID" "$GROUP"
create_user "$UID" "$USER" "$GROUP"
enable_sudo "$USER"
mkdir_xdg "$USER" "$GROUP"
fix_ownership "$USER" "$GROUP"

# solve a warning when starting emacs
export NO_AT_BRIDGE=1

cd "/home/$USER"
su-exec "$USER" "$@"
