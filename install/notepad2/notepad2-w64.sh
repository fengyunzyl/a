#!/bin/bash
# Install WDK
# msdn.microsoft.com/en-us/windows/hardware/gg487428

# Get source
# It is important to include trunk or you
# get the unmodded code as well
url='http://notepad2-mod.googlecode.com/svn/trunk'
read svn_dir < <(svn info $url | awk /Revision/'{print $2}')
svn co $url $svn_dir
cd $svn_dir

# Update revision
# res/Notepad2.exe.manifest.template
# src/VersionRev.h.template

# Build
cd build
cmd /c 'build_wdk.bat'
cd -

# Install
mkdir $HOMEDRIVE/notepad2
cp bin/WDK/Release_x64/Notepad2.exe $HOMEDRIVE/notepad2
touch $HOMEDRIVE/notepad2/notepad2.ini
