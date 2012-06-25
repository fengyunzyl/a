#!/bin/sh
# VLC media player
# Open folder via command line/context menu
# forum.videolan.org/viewtopic.php?p=34321

vlc='C:\Program Files (x86)\VideoLAN\VLC\vlc.exe'

reg add 'HKCR\Directory\shell\VLC\command' -d "$vlc \"%v\""
