#!/bin/bash

quote ()
{
  [[ ${!1/*[ #&;\\]*} ]] || read -r $1 <<< \"${!1}\"
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
  for oo
  do
    quote oo
    set -- "$@" $oo
    shift
  done
  warn $*
  eval $*
}

bsplit ()
{
  IFS=\" read -a $1 <<< "${!2}"
}

usage ()
{
  echo "usage: $0 DELAY [CDN FILETYPE] URL"
  echo
  echo "CDN       content delivery network"
  echo "DELAY     wait time before coredump"
  echo "FILETYPE  quality"
  exit
}

clean ()
{
  rm -f a.core
  set $APPDATA/moonch~1/palemo~1/profiles/default/user.js
  echo 'user_pref("browser.startup.page",3);' >$1
}

serialize_xml ()
{
  [[ ${!1} =~ [^\ ]*.(.*)/\> ]]
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
  sleep ${!1}
  clean
  dumper a $REPLY &
  until [ -s a.core ]
  do
    sleep 1
  done
  kill -13 %%
}

[ $2 ] || usage
[ $4 ] || set $1 '' '' $2
arg_delay=$1
arg_cdn=$2
arg_filetype=$3
arg_url=$4
echo ProtectedMode=0 2>/dev/null >$WINDIR/system32/macromed/flash/mms.cfg
set $APPDATA/moonch~1/palemo~1/profiles/default/user.js
echo 'user_pref("browser.startup.page",1);' >$1
pkill palemoon
open $arg_url
coredump arg_delay plugin-container

while read video
do
  serialize_xml video
  if ! [ $arg_cdn ]
  then
    printf '%-9s  %9s\n' $cdn $filetype
  elif [ $cdn$filetype = $arg_cdn$arg_filetype ]
  then
    break
  fi
done < <(grep -ao '<video [^>]*>' a.core | sort | uniq -w123)

if ! [ $arg_cdn ]
then
  clean
  exit
fi

read app < <(cut -d/ -f4- <<< ${server}?${token//amp;})
clean

# parse JSON to get file name

log rtmpdump \
  -W http://download.hulu.com/huludesktop.swf \
  -o a.flv \
  -a $app \
  -r $server \
  -y $stream
