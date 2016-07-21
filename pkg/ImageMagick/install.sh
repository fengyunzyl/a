#!/bin/dash -e
cd /tmp
j=$(lynx -dump -listonly -nonumbers github.com/svnpenn/a/releases |
grep -m1 imageMagick)
wget -nc "$j"
unzip -n "$(basename "$j")"
ln -f convert magic.xml /usr/local/bin
ln -f convert /usr/local/bin/identify
