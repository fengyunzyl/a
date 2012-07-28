#!/bin/bash
# YouTube live
p=plugin-container

pidof(){
  ps -W | grep $1 | cut -c-9
}

red(){
  printf "\e[1;31m%s\e[m\n" "$1"
}

pidof $p | xargs /bin/kill -f
echo ProtectedMode=0 > \\windows/system32/macromed/flash/mms.cfg
red 'Press enter after video starts'; read
pidof $p | xargs timeout 1 dumper p

# Log URL
read < <(tr "\0," "\n" < p.core | grep liveplay | head -1)
echo "$REPLY"
cygstart "$REPLY"
rm p.core
