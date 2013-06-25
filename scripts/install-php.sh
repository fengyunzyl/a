# install PHP

mkdir -p ~/php
cd ~/php
wget windows.php.net/downloads/releases/sha1sum.txt
set $(awk '/VC9/ {a=$6} END {print a}' RS='\n\n' sha1sum.txt)
wget windows.php.net/downloads/releases/$1
unzip $1
chmod +x php.exe php5ts.dll libeay32.dll ssleay32.dll ext/php_curl.dll
echo extension=ext/php_curl.dll > php.ini
