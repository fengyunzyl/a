#!/bin/bash
p="plugin-container.exe"

binparse(){
  grep -axzm1 "[--Z]*$1[--Z]*" p.core
}

pidof(){
  ps -W | grep "$1" | cut -c-9
}

red(){
  printf "\e[1;31m%s\e[m\n" "$1"
}

pidof "$p" | xargs /bin/kill -f
printf "ProtectedMode=0" > "${COMSPEC%\\*}/Macromed/Flash/mms.cfg"
red 'Press enter after video starts'; read
red 'Printing results'
pidof "$p" | xargs dumper p &
sleep 1
pidof "$p" | xargs /bin/kill -f
read s < <(which AdobeHDS.php | cygpath -mf-)
read a < <(binparse "Frag" | cut -d? -f2)
read m < <(binparse "http.*f4m?")
read u < <(binparse "Mozilla/5.0")
set -x
php "$s" --auth "$a" --manifest "$m" --useragent "$u"
