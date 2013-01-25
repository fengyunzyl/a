#!/bin/bash
# Requires: php-bcmath, php-curl, php-simplexml

pgrep ()
{
  ps -W | awk /$1/'{print$4;exit}'
}

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

pkill ()
{
  pgrep $1 | xargs kill -f
}

quote ()
{
  [[ ${!1/*[ #&;\\]*} ]] || read -r $1 <<< \"${!1}\"
}

usage ()
{
  echo usage: $0 DELAY
  exit
}

clean ()
{
  rm -f a.core
}

coredump ()
{
  pkill $2
  warn Killed $2 for clean dump.
  warn Script will automatically continue after $2 is restarted.
  until read < <(pgrep $2)
  do
    sleep 1
  done
  sleep $1
  clean
  dumper a $REPLY &
  until [ -s a.core ]
  do
    sleep 1
  done
  kill -13 %%
}

log ()
{
  local pp
  for oo
  do
    quote oo
    pp+=($oo)
  done
  warn ${pp[*]}
  eval ${pp[*]}
}

[ $1 ] || usage
echo ProtectedMode=0 2>/dev/null >$WINDIR/system32/macromed/flash/mms.cfg
coredump $1 plugin-container
read ah < <(grep -Eaozm1 'pvtoken.*' a.core)
read mn < <(tr "[:cntrl:]'<>" '\n' < a.core | grep '^http://[^?]*\.f4m')
read ur < <(grep -Eaozm1 'Mozilla/5.0.*' a.core)
echo extension=ext/php_curl.dll > /usr/local/bin/php/php.ini
set /opt/Scripts/AdobeHDS.php
clean

log php "$1" --manifest "$mn" ||
log php "$1" --manifest "$mn" --auth "$ah" --useragent "$ur"
