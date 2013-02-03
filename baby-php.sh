#!/bin/bash
set $PWD/php-5.4.11-nts-Win32-VC9-x86
mkdir dist
cd dist

# /
cat > cmd.bat <<q
path %path%;%~dp0/bin
cd root
start cmd.exe
q
read DATE < <(date)
PATH=$1:$PATH
read PHP_VERSION < <(php -v | grep -o '[.0-9]*')
cat > README.txt <<q
Baby PHP by
  Steven Penny

Steven’s Home Page
  http://svnpenn.github.com

Today’s date
  $DATE

The build script for this build can be found at
  http://github.com/svnpenn/a/blob/master/baby-php.sh

Included with this package
  PHP $PHP_VERSION

OPERATING INSTRUCTIONS
  Put any scripts into "root" folder
  Double click cmd.bat
  Use command like "php foo.php"
q
u2d README.txt

# /bin
deps=(
  $1/ext/php_curl.dll
  $1/php.exe
)
mkdir bin
cd bin
cp ${deps[*]} .
ldd ${deps[*]} |
  grep " $1" |
  cut -d\  -f3 |
  sort -u |
  xargs cp -t .
echo extension=./php_curl.dll > php.ini
cd -

# /root
mkdir root

# archive
cd ${0%/*}
read BABY_VERSION < <(git log --oneline $0 | wc -l)
cd -
set cmd.bat README.txt bin root
tar acf baby-php-$BABY_VERSION.tar.gz $*
rm -r $*
