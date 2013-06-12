# install PHP

mkdir -p ~/php
cd ~/php
wget windows.php.net/downloads/releases/sha1sum.txt
set $(awk 'END {print $2}' RS='\n\n' FS=- sha1sum.txt)
wget windows.php.net/downloads/releases/php-$1-Win32-VC9-x86.zip
unzip php-$1-Win32-VC9-x86.zip
chmod +x php.exe php5.dll libeay32.dll ssleay32.dll ext/php_curl.dll
echo extension=ext/php_curl.dll > php.ini
