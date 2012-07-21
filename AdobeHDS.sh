#!/bin/bash
LANG=
p=plugin-container.exe

binparse(){
  grep -axzm1 "[ -~]*$1[ -~]*" p.core
}

pidof(){
  read -n9 < <(ps -W | grep $1)
}

red(){
  printf "\e[1;31m%s\e[m\n" "$1"
}

pidof $p
/bin/kill -f $REPLY
printf "ProtectedMode=0" > "${COMSPEC%\\*}/Macromed/Flash/mms.cfg"
red 'Press enter after video starts'; read
red 'Printing results'
pidof $p
timeout 1 dumper p $REPLY
IFS=? read a1 a2 < <(binparse "Frag")
read m < <(binparse "http.*f4m?")
read u < <(binparse "Mozilla/5.0")
set -x
php /opt/Scripts/AdobeHDS.php --auth "$a2" --manifest "$m" --useragent "$u"
