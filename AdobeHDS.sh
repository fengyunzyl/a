#!/bin/bash
PATH+=":."
cache="$(cygpath -F28)/*/*/Profiles/*/Cache/_*"
p="plugin-container.exe"
red="\e[1;31m%s\e[m\n"

pid(){
  ps -W | grep "$1" | cut -c-9
}

binparse(){
  cat $1 | grep -azm1 "$2" | cut -d "$3" -f "$4"
}

# Clear Firefox cache
pid "$p" | xargs /bin/kill -f
: | tee $cache
printf $red 'Press enter after video starts'; read
printf $red 'Printing results'

# Script
read script < <(which AdobeHDS.php | cygpath -mf-)

# Auth
read auth < <(binparse "$cache" "Seg.*?" "?" "2")

# Manifest
read manifest < <(binparse "$cache" "f4m?" "/" "3-")

# Run
set -x
php "$script" --auth "$auth" --manifest "$manifest"
