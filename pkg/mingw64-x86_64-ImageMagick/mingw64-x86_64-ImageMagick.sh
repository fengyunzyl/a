#!/bin/dash -e
ec=imagemagick.org/download/binaries
fo=$(lynx -dump -listonly -nonumbers "$ec" |
  awk '/x64.zip$/ {go = $0} END {print go}')
ho=$(basename "$fo")
cd /tmp
wget -nc "$fo"
unzip -n "$ho" convert.exe magic.xml
chmod +x convert
ln -f convert magic.xml /usr/local/bin
ln -f convert /usr/local/bin/identify
