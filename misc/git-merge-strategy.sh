#!/bin/sh
# Create RtmpDump build with Handshake 10
# help.github.com/articles/working-with-subtree-merge
git clone git://git.ffmpeg.org/rtmpdump
cd rtmpdump

# Patch with KSV code
git apply -p0 ../Patch.diff
git add -A
git commit -m KSV

# Patch with Xeebo code
git checkout 603f
git branch xeebo
git checkout xeebo
git apply ../0001-Handshake-10.patch
git add -A
git commit -m Xeebo

# Merge branches
git checkout master
git merge -s ours xeebo
