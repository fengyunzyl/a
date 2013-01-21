#!/bin/bash

quote ()
{
  [[ ${!1} =~ [\ \&] ]] && read $1 <<< \"${!1}\"
}

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

pgrep ()
{
  ps -W | awk /$1/'{print$4;exit}'
}

pkill ()
{
  pgrep $1 | xargs kill -f
}

log ()
{
  local pp
  for oo
  do
    quote oo
    pp+=($oo)
  done
  echo ${pp[*]} >> a.txt
  warn ${pp[*]}
  eval ${pp[*]}
}

bsplit ()
{
  IFS=\" read -a $1 <<< "${!2}"
}

usage ()
{
  echo "usage: $0 DELAY CDN FILETYPE URL"
  echo
  echo "To see available CDNs and filetypes run script with just DELAY."
  exit
}

clean ()
{
  rm -f a.core a.flv a.txt
  echo 'user_pref("browser.startup.page",3);' \
    >$APPDATA/moonch~1/palemo~1/profiles/default/user.js
}

serialize_xml ()
{
  [[ ${!1} =~ [^\ ]*\ (.*)/\> ]]
  xs=${BASH_REMATCH[1]}
  bsplit xa xs
  aa=0
  while [ ${xa[aa]} ]
  do
    read ${xa[aa]//[-:=]} <<< ${xa[aa+1]}
    (( aa += 2 ))
  done
}

coredump ()
{
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

[ $4 ] || usage
echo ProtectedMode=0 2>/dev/null >$WINDIR/system32/macromed/flash/mms.cfg
echo 'user_pref("browser.startup.page",1);' \
  >$APPDATA/moonch~1/palemo~1/profiles/default/user.js
pkill palemoon
open $4
coredump $1 plugin-container

while read video
do
  serialize_xml video
  if ! [ $1 ]
  then
    printf '%-9s  %9s\n' $cdn $filetype
  elif [ $cdn$filetype = $2$3 ]
  then
    break
  fi
done < <(grep -ao '<video [^>]*>' a.core | sort | uniq -w123)

if ! [ $1 ]
then
  clean
  exit
fi

read app < <(cut -d/ -f4- <<< ${server}?${token//amp;})

log rtmpdump \
  -W http://download.hulu.com/huludesktop.swf \
  -o a.flv \
  -a $app \
  -r $server \
  -y $stream

log ffmpeg -i a.flv -c copy -v warning a.mp4
clean
