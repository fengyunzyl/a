#!/bin/sh
# Create RtmpDump build with Handshake 10
# help.github.com/articles/working-with-subtree-merge
git clone git://git.ffmpeg.org/rtmpdump
cd rtmpdump

# Patch with KSV code
git apply -p0 ../Patch.diff
git commit -am ksv

# Patch with Handshake 10
git checkout -b handshake-10 603f
git apply ../0001-Handshake-10.patch
git add .
git commit -m 'Handshake 10'

# Merge branches
git checkout master
git merge -s ours handshake-10
