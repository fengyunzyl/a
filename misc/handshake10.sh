#!/bin/sh
# Create RtmpDump build with Handshake 10
git clone git://git.ffmpeg.org/rtmpdump
cd rtmpdump

# Patch with KSV code
git branch KSV
git checkout KSV
git apply -p0 ../Patch.diff
git add -A
git commit -m KSV

# Patch with Xeebo code
git checkout master
git apply ../0001-Handshake-10.patch
git add -A
git commit -m Xeebo

# Merge branches
git merge -X theirs KSV
