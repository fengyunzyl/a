# install PHP

mkdir -p ~/php
cd ~/php
wget windows.php.net/downloads/releases/sha1sum.txt
set $(awk '/php-[^-]*-Win32/ {a=$2} END {print a}' sha1sum.txt)
wget windows.php.net/downloads/releases/$1
unzip $1
chmod +x php.exe php5ts.dll libeay32.dll ssleay32.dll ext/php_curl.dll
echo extension=ext/php_curl.dll > php.ini
