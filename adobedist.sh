#!/bin/bash
# Create AdobeHDS distribution

version(){
  read <<< "$PWD"
  cd /tmp
  rm -rf $2
  git clone -q git://github.com/$1/$2.git
  cd $2
  git rev-list HEAD | tail -1 | xargs git tag v
  git describe --tags
  cd "$REPLY"
}

read version_php < <(version K-S-V Scripts)
read version_sh < <(version svnpenn etc)
distdir="adobehds-$version_sh"
mkdir $distdir
cd $distdir

# BIN
deps=(
  /dev/fd
  /etc/php5/conf.d/bcmath.ini
  /etc/php5/conf.d/curl.ini
  /etc/php5/conf.d/simplexml.ini
  /bin/bash.exe
  /bin/dumper.exe
  /bin/grep.exe
  /bin/kill.exe
  /bin/php.exe
  /bin/ps.exe
  /bin/timeout.exe
  /bin/xargs.exe
  /lib/php/20090626/bcmath.dll
  /lib/php/20090626/curl.dll
  /lib/php/20090626/simplexml.dll
)
cp -r --parents ${deps[@]} .
ldd ${deps[@]:4} \
  | grep usr \
  | sort -u \
  | cut -d\  -f3 \
  | xargs -i% cp % bin

# ETC
echo 'PATH=/usr/local/bin:/usr/bin
cd tmp' > etc/profile

# USR/LOCAL/BIN
mkdir -p usr/local/bin
cd usr/local/bin
cp /tmp/Scripts/AdobeHDS.php .
cp /tmp/etc/AdobeHDS.sh .
chmod +x AdobeHDS.sh
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
