#!/bin/sh
# Create AdobeHDS distribution
distdir=cygwin-svnpenn
mkdir $distdir
cd $distdir

# BIN
binfiles=(
  /bin/bash.exe
  /bin/cut.exe
  /bin/cyggcc_s-1.dll
  /bin/cygiconv-2.dll
  /bin/cygintl-8.dll
  /bin/cygncursesw-10.dll
  /bin/cygpath.exe
  /bin/cygpcre-0.dll
  /bin/cygreadline7.dll
  /bin/cygstdc++-6.dll
  /bin/cygwin1.dll
  /bin/cygz.dll
  /bin/dumper.exe
  /bin/grep.exe
  /bin/kill.exe
  /bin/ps.exe
  /bin/sleep.exe
  /bin/which.exe
  /bin/xargs.exe
)
mkdir bin
cd bin
for file in ${binfiles[@]}; do cp $file .; done
cd -

# DEV
mkdir dev
cd dev
cp -r /dev/fd .
cd -

# ETC
mkdir etc
cd etc
echo PATH=/usr/local/bin:/usr/bin > profile
cd -

# USR/LOCAL/BIN
ulbinfiles=(
  /c/php/ext/php_curl.dll
  /c/php/libeay32.dll
  /c/php/php.exe
  /c/php/php5.dll
  /c/php/ssleay32.dll
  /usr/local/bin/AdobeHDS.php
  ~/etc/AdobeHDS.sh
)
mkdir -p usr/local/bin
cd usr/local/bin
for file in ${ulbinfiles[@]}; do cp $file .; done
echo extension=./php_curl.dll > php.ini
cd -

# CYGWIN.BAT
echo '@start bin\bash -l' > Cygwin.bat

# PACK
packfiles=(
  # bin/bash.exe
  bin/cut.exe
  bin/cyggcc_s-1.dll
  bin/cygiconv-2.dll
  bin/cygintl-8.dll
  bin/cygncursesw-10.dll
  bin/cygpath.exe
  bin/cygpcre-0.dll
  bin/cygreadline7.dll
  bin/cygstdc++-6.dll
  # bin/cygwin1.dll
  bin/cygz.dll
  bin/dumper.exe
  bin/grep.exe
  bin/kill.exe
  bin/ps.exe
  bin/sleep.exe
  bin/which.exe
  # bin/xargs.exe
  usr/local/bin/libeay32.dll
  usr/local/bin/php.exe
  usr/local/bin/php_curl.dll
  usr/local/bin/php5.dll
  usr/local/bin/ssleay32.dll
)
for file in ${packfiles[@]}; do upx -9 $file; done
