#!/bin/sh
# Patch my repo, but do not make a commit
patch_branch=KSV
patch_file=Patch.diff
url_mine=git@github.com:svnpenn/rtmpdump.git
url_upstream=git://git.ffmpeg.org/rtmpdump

# Get my repo
git clone $url_mine dir_mine
cd dir_mine
git checkout $patch_branch
# Empty my repo, except ".git"
rm -r *
cd -

# Get upstream repo
git clone $url_upstream dir_upstream
cd dir_upstream
git apply ../$patch_file 2>/dev/null || git apply -p0 ../$patch_file || {
    echo 'Patch failed!'
    exit
}
# Copy patched files over
cp -r * ../dir_mine
cd -