#!/bin/bash
# Create AdobeHDS distribution

version(){
  cd "$1"
  git rev-list HEAD | tail -1 | xargs git tag v
  git describe --tags
  cd "$OLDPWD"
}

read v_date < <(date)
read v_phpscript < <(version /opt/Scripts)
read v_shscript < <(version /opt/etc)
read -d\( v_cygwin < <(uname -r)
read -d\( PHP v_php < <(php -v)

# CLONE REPOS
read <<< "$PWD"
mkdir -p /opt
cd $_
cd Scripts && git pull && cd - || git clone git://github.com/K-S-V/Scripts.git
cd etc && git pull && cd - || git clone git://github.com/svnpenn/etc.git
cd "$REPLY"

# BEGIN
mkdir adobehds
cd $_

# OPT
cp --parents /opt/Scripts/AdobeHDS.php .
cp --parents /opt/etc/AdobeHDS.sh .
chmod +x opt/etc/AdobeHDS.sh

# BIN
deps=(
  /dev/fd
  /etc/php5/conf.d/bcmath.ini
  /etc/php5/conf.d/curl.ini
  /etc/php5/conf.d/simplexml.ini
  /bin/bash.exe
  /bin/cut.exe
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
echo 'PATH=/bin:/opt/etc
cd tmp' > etc/profile

# CYGWIN.BAT
echo '@start bin\bash -l' > Cygwin.bat

# README
cat > README <<EOF
AdobeHDS.sh by Steven Penny

Steven’s Home Page: http://svnpenn.github.com

Built on $v_date

The source code for this project can be found at
  http://github.com/svnpenn/etc

Included with this package
  AdobeHDS.php $v_phpscript
  AdobeHDS.sh $v_shscript
  Cygwin $v_cygwin
  PHP $v_php

OPERATING INSTRUCTIONS
  Double click Cygwin.bat
  Input AdobeHDS.sh
  Follow instructions after that
EOF

# ARCHIVE
7z a "adobehds-$v_shscript"
