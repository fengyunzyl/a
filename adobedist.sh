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
  /bin/cyggcc_s-1.dll # bash
  /bin/cygiconv-2.dll # bash
  /bin/cygintl-8.dll # bash
  /bin/cygncursesw-10.dll # bash
  /bin/cygreadline7.dll # bash
  /bin/cygwin1.dll # bash
  /bin/cygpcre-0.dll # grep
  /bin/cygstdc++-6.dll # dumper
  /bin/cygz.dll # dumper
  /bin/bash.exe
  /bin/dumper.exe
  /bin/grep.exe
  /bin/kill.exe
  /bin/ps.exe
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
echo 'PATH=/usr/local/bin:/usr/bin
cd tmp' > profile
cd -

# USR/LOCAL/BIN
ulbinfiles=(
  /c/php/ext/php_curl.dll
  /c/php/libeay32.dll
  /c/php/php.exe
  /c/php/php5.dll
  /c/php/ssleay32.dll
)
mkdir -p usr/local/bin
cd usr/local/bin
for file in ${ulbinfiles[@]}; do cp $file .; done
echo extension=./php_curl.dll > php.ini
wget https://raw.github.com/K-S-V/Scripts/master/AdobeHDS.php
wget https://raw.github.com/svnpenn/etc/master/AdobeHDS.sh
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
