#!/bin/bash
# Create AdobeHDS distribution
cd /tmp

# GITHUB
update(){
  (
    cd /opt
    git clone git://github.com/$1/$2.git
    cd $2
    git pull -q
    git rev-list HEAD | tail -1 | xargs git tag v
    git describe --tags
    cp --parents /opt/$2/$3 /tmp
  ) 2>/dev/null
}
mkdir -p /opt
read v_phpscript < <(update K-S-V Scripts AdobeHDS.php)
read v_shscript < <(update svnpenn etc AdobeHDS.sh)

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
chmod +x Cygwin.bat

# README
read v_date < <(date)
read v_cygwin < <(uname -r | grep -o '[.0-9]*')
read v_php < <(php -v | grep -o '[.0-9]*')
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
