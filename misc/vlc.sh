#!/bin/sh
# VLC media player
# Open folder via command line/context menu
# forum.videolan.org/viewtopic.php?p=34321

key='/root/Directory/shell/VLC'

regtool add "$key"
regtool add "$key/command"
regtool set "$key/command/" "$PROGRAMFILES\VideoLAN\VLC\vlc \"%v\""
