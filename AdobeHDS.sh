#!/bin/bash
PATH+=":."
p="plugin-container.exe"

pid(){
  ps -W | grep "$1" | cut -c-9
}

binparse(){
  grep -azm1 "$1" p.core
}

red(){
  printf "\e[1;31m%s\e[m\n" "$1"
}

# Clear Firefox cache
pid "$p" | xargs /bin/kill -f
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
