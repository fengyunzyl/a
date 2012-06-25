#!/bin/sh
# Cygwin prompt here
vbs="C:/home/GitHub/etc/misc/cygwin.vbs"

rt(){
  regtool add "$1"
  regtool add "$1/command"
  regtool set "$1/command/" "wscript $2 \"%v\""
}

rt "/root/Directory/Background/shell/Cygwin" "$vbs"
rt "/root/Directory/shell/Cygwin" "$vbs"

# technet.microsoft.com/en-us/library/cc957410
regtool set '/user/Console/QuickEdit' 1
# 0x01900384 (26215300)
regtool set '/user/Console/WindowPosition' 26215300
# 0x00190050 (1638480)
regtool set '/user/Console/WindowSize' 1638480
