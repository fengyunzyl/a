#!/bin/bash

quote ()
{
  [[ ${!1/*[ #&;\\]*} ]] || read -r $1 <<< \"${!1}\"
}

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
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
  echo "usage: $0 [CDN FILETYPE] URL"
  echo
  echo "CDN       content delivery network"
  echo "FILETYPE  quality"
  exit
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
  PID=$!
  echo waiting for $1 to load...
  rr=()
  until (( ${#rr[*]} > 1700 ))
  do
    mapfile rr </proc/$PID/maps
    sleep 1
  done
  echo dumping $1...
  read WINPID </proc/$PID/winpid
  dumper ff $WINPID 2>&- &
  until [ -s ff.core ]
  do
    sleep 1
  done
  kill -13 $PID
}

firefox ()
{
  exec "$PROGRAMFILES/mozilla firefox/firefox" $*
}

[ $1 ] || usage
[ $3 ] || set '' '' $1
arg_cdn=$1
arg_filetype=$2
arg_url=$3
arg_pwd=$PWD
cd $WINDIR
echo ProtectedMode=0 > system32/macromed/flash/mms.cfg
# copy cookies
rm -r /tmp
mkdir /tmp
cd $APPDATA
find -name cookies.sqlite -exec cp -t /tmp {} +
cd /tmp
MOZ_DISABLE_OOP_PLUGINS=1 firefox -no-remote -profile . $arg_url &
coredump firefox

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
done < <(grep -ao '<video [^>]*>' ff.core | sort | uniq -w123)

# parse JSON to get file name
# use /dev/tcp to download "jq" if necessary
flv=${arg_url/*\/}.flv
[ $arg_cdn ] || exit
read app < <(cut -d/ -f4- <<< ${server}?${token//amp;})
cd $arg_pwd

log rtmpdump \
  -W http://download.hulu.com/huludesktop.swf \
  -o $flv \
  -a $app \
  -r $server \
  -y $stream
