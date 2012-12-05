#!/bin/bash
# Requires: php-bcmath, php-curl, php-simplexml

binparse ()
{
  grep -Eaozm1 "$1" pg.core
}

pgrep ()
{
  ps -W | awk /$1/'{print$4;exit}'
}

warn ()
{
  echo -e "\e[1;35m$@\e[m"
}

pkill ()
{
  pgrep $1 | xargs kill -f
}

quote ()
{
  [[ ${!1} =~ [\ \&] ]] && read $1 <<< \"${!1}\"
}

try ()
{
  local gh
  for gg
  do
    quote gg
    gh+=("$gg")
  done
  warn "${gh[@]}"
  eval "${gh[@]}"
}

ab=/opt/Scripts/AdobeHDS.php
pc=plugin-container
pkill $pc
echo ProtectedMode=0 2>/dev/null >$WINDIR/system32/macromed/flash/mms.cfg
warn 'Killed flash player for clean dump.
Restart video then press enter here.'
read

until read < <(pgrep $pc)
do
  warn "$pc not found!"
  read
done

rm -f pg.core
dumper pg $REPLY &

until [ -s pg.core ]
do
  sleep 1
done

read ah < <(binparse "pvtoken.*")
read mn < <(tr "[:cntrl:]'<>" "\n" < pg.core | grep 'http://.*\.f4m')
read ur < <(binparse "Mozilla/5.0.*")
echo extension=ext/php_curl.dll > /usr/local/bin/php/php.ini
rm pg.core

try php "$ab" --manifest "$mn" ||
try php "$ab" --manifest "$mn" --auth "$ah" --useragent "$ur"
