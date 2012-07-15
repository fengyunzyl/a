#!/bin/bash
# Create AdobeHDS distribution

version(){
  rm -rf /tmp
  git clone -q "git://github.com/$1.git" /tmp
  cd /tmp
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
deps=(
  /bin/bash.exe
  /bin/dumper.exe
  /bin/grep.exe
  /bin/kill.exe
  /bin/php.exe
  /bin/ps.exe
  /bin/timeout.exe
  /dev/fd
  /etc/php5/conf.d/bcmath.ini
  /etc/php5/conf.d/curl.ini
  /etc/php5/conf.d/simplexml.ini
  /lib/php/20090626/bcmath.dll
  /lib/php/20090626/curl.dll
  /lib/php/20090626/simplexml.dll
)
cp -r --parents ${deps[@]} .
ldd ${deps[@]} \
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
wget -q https://raw.github.com/K-S-V/Scripts/master/AdobeHDS.php
wget -q https://raw.github.com/svnpenn/etc/master/AdobeHDS.sh
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
