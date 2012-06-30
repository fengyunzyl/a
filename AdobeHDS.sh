#!/bin/bash
PATH+=":."
p="plugin-container.exe"

binparse(){
  grep -azm1 "$1" p.core
}

pid(){
  ps -W | grep "$1" | cut -c-9
}

red(){
  printf "\e[1;31m%s\e[m\n" "$1"
}

# Kill flash player
pid "$p" | xargs /bin/kill -f
# Disable protected mode, 32 and 64 bit Windows
printf "ProtectedMode=0" > "$(cygpath -S)/Macromed/Flash/mms.cfg"
red 'Press enter after video starts'; read
red 'Printing results'
# Dump flash player
pid "$p" | xargs dumper p &
sleep 1

# Script
read s < <(which AdobeHDS.php | cygpath -mf-)

# Auth
read a < <(binparse "Frag.?" | cut -d? -f2)

# Manifest
read m < <(binparse "http.*f4m?")

# Useragent
read u < <(binparse "Mozilla/5.0")

# Run
set -x
php "$s" --auth "$a" --manifest "$m" --useragent "$u"
