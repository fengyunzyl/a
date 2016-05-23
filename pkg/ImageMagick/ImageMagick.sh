#!/bin/dash -e
ec=imagemagick.org/download/binaries
fo=$(lynx -dump -listonly -nonumbers "$ec" |
  awk '/x64.zip$/ {go = $0} END {print go}')
ho=$(basename "$fo")
cd /tmp
wget -nc "$fo"
set convert.exe identify.exe
unzip "$ho" "$@"
install "$@" /usr/local/bin
