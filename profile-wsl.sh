#!/bin/sh
set -euo

# detect IP address. may need tweaking
ip="$(powershell.exe -Command 'Get-NetIPAddress | Where-Object -FilterScript { $_.ValidLifetime -Lt ([TimeSpan]::FromDays(1)) }' | grep IPAddress | tr -d '\r\n')"
ip="${ip##*: }"
echo "Detected IP: $ip"

export DISPLAY="${ip}:0"

type xauth || sudo apt install -y xauth pwgen coreutils

# setup the xauth magic cookie
magicCookie="$(pwgen 30 1 | md5sum)"
magicCookie="${magicCookie% *}"
xauth add "$DISPLAY" . "$magicCookie"

# finds the windows user path
userProfile="$(wslpath $(cmd.exe /C \"echo %USERPROFILE%\" 2>/dev/null | tr -d '\r\n'))"

echo "copying .Xauthority to $userProfile"
cp ~/.Xauthority "$userProfile"
