#!/bin/sh
# reset Firefox

cd $APPDATA
rm -r mozilla

cd /opt/dotfiles
cp -r mozilla $OLDPWD

cd $APPDATA/mozilla/firefox
