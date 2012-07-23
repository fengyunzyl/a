#!/bin/bash
# Create AdobeHDS distribution

update(){
  (
    mkdir -p /opt
    cd /opt
    git clone $1
    : ${1##*/}
    cd ${_%.*}
    git pull
    git rev-list HEAD | tail -1 | xargs git tag v
  ) 2>/dev/null
}

read v_cygwin < <(uname -r | grep -o '[.0-9]*')
read v_date < <(date)
read v_php < <(php -v | grep -o '[.0-9]*')
read v_phpscript < <(cd /opt/Scripts; git describe --tags)
read v_shscript < <(cd /opt/etc; git describe --tags)
update git://github.com/K-S-V/Scripts.git
update git://github.com/svnpenn/etc.git
mkdir adobehds
cd $_

# OPT
cp --parents /opt/Scripts/AdobeHDS.php .
cp --parents /opt/etc/AdobeHDS.sh .

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
