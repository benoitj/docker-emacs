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
                (echo "$username ALL=(ALL) NOPASSWD: ALL" >"/etc/sudoers.d/$username" &&
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

run_init() {
        test -d "/init.d" &&
                for init_file in /init.d/*; do
                        echo "init: $init_file"
                        "$init_file"
                done
}

create_group "$GROUPID" "$GROUPNAME"
create_user "$USERID" "$USERNAME" "$GROUPNAME"
enable_sudo "$USERNAME"
mkdir_xdg "$USERNAME" "$GROUPNAME"
fix_ownership "$USERNAME" "$GROUPNAME"
run_init

# solve a warning when starting emacs
export NO_AT_BRIDGE=1

cd "/home/$USERNAME"
su-exec "$USERNAME" "$@"
