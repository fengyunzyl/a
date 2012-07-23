#!/bin/bash
LANG=
p=plugin-container.exe

binparse(){
  grep -axzm1 "[ -~]*$1[ -~]*" p.core
}

pidof(){
  ps -W | grep $1 | cut -c-9
}

red(){
  printf "\e[1;31m%s\e[m\n" "$1"
}

pidof $p | xargs /bin/kill -f
echo ProtectedMode=0 > \\windows/system32/macromed/flash/mms.cfg
red 'Press enter after video starts'; read
red 'Printing results'
pidof $p | xargs timeout 1 dumper p
IFS=? read a1 a2 < <(binparse "Frag")
read m < <(binparse "http.*f4m?")
read u < <(binparse "Mozilla/5.0")
set -x
php /opt/Scripts/AdobeHDS.php --auth "$a2" --manifest "$m" --useragent "$u"
