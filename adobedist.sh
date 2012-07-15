#!/bin/bash
# Create AdobeHDS distribution

version(){
  rm -rf version
  git clone -q "git://github.com/$1.git" version
  cd version
  git rev-list HEAD | tail -1 | xargs git tag v
  git describe --tags
  cd ->/dev/null
}

read version_php < <(version K-S-V/Scripts)
read version_sh < <(version svnpenn/etc)
distdir="adobehds-$version_sh"
mkdir $distdir
cd $distdir

# BIN
binfiles=(
  cygcrypto-1.0.0.dll # php
  cygphp5.dll # php
  cygpcre-1.dll # php
  cygssl-1.0.0.dll # php
  cygxml2-2.dll # php
  cyggcc_s-1.dll # bash
  cygiconv-2.dll # bash
  cygintl-8.dll # bash
  cygncursesw-10.dll # bash
  cygreadline7.dll # bash
  cygwin1.dll # bash
  cygpcre-0.dll # grep
  cygstdc++-6.dll # dumper
  cygz.dll # dumper
  bash.exe
  dumper.exe
  grep.exe
  kill.exe
  php.exe
  ps.exe
)
mkdir bin
cd bin
for file in ${binfiles[@]}; do cp /bin/$file .; done
cd -

# DEV
mkdir dev
cd dev
cp -r /dev/fd .
cd -

# ETC
mkdir etc
cd etc
echo 'PATH=/usr/local/bin:/usr/bin
cd tmp' > profile
cd -

# USR/LIB
ulfiles=(
  /usr/lib/php/20090626/curl.dll
  /usr/lib/php/20090626/simplexml.dll
  # /c/php/libeay32.dll
  # /c/php/ssleay32.dll
)
mkdir -p usr/lib/php/20090626
cd usr/lib/php/20090626
for file in ${ulfiles[@]}; do cp $file .; done
cd -

# USR/LOCAL/BIN
#ulbinfiles=(
  # /c/php/libeay32.dll
  # /c/php/ssleay32.dll
#)
mkdir -p usr/local/bin
cd usr/local/bin
# for file in ${ulbinfiles[@]}; do cp $file .; done
# echo extension=./php_curl.dll > php.ini
wget -q https://raw.github.com/K-S-V/Scripts/master/AdobeHDS.php
wget -q https://raw.github.com/svnpenn/etc/master/AdobeHDS.sh
cd -

# CYGWIN.BAT
echo '@start bin\bash -l' > Cygwin.bat

# README
cat > README <<EOF
AdobeHDS.sh by Steven Penny

Steven’s Home Page: http://svnpenn.github.com

Built on $(date)

The source code for this project can be found at
  http://github.com/svnpenn/etc

Included with this package
  AdobeHDS.php $version_php
  AdobeHDS.sh $version_sh
  Cygwin $(uname -r | cut -d\( -f1)
  PHP $(php -v | head -1 | cut -d\  -f2)

OPERATING INSTRUCTIONS
  Double click Cygwin.bat
  Input AdobeHDS.sh
  Follow instructions after that
EOF
