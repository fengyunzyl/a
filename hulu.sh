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
  ps -W | grep $1 | cut -c-9
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
  echo "usage: $0 [CDN FILETYPE] URL"
  echo
  echo "CDN       content delivery network"
  echo "FILETYPE  quality"
  exit
}

clean ()
{
  rm -f ff.core
  cd "$PROGRAMFILES/mozilla firefox"
  rm -f defaults/pref/local-settings.js mozilla.cfg
  cd ~-
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
  warn waiting for $1 to load...
  rr=()
  until (( ${#rr[*]} > 2000 ))
  do
    mapfile rr </proc/$PID/maps
    sleep 1
  done
  warn dumping $1...
  clean
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
  exec "$PROGRAMFILES/mozilla firefox/firefox" $1
}

[ $1 ] || usage
[ $3 ] || set '' '' $1
arg_cdn=$1
arg_filetype=$2
arg_url=$3
pkill firefox
cd $WINDIR
echo ProtectedMode=0 > system32/macromed/flash/mms.cfg
cd ~-
cd "$PROGRAMFILES/mozilla firefox"
cat > defaults/pref/local-settings.js <<bb
pref("general.config.filename", "mozilla.cfg");
pref("general.config.obscure_value", 0);
bb
cat > mozilla.cfg <<bb
//
lockPref("browser.sessionstore.resume_from_crash", false);
lockPref("browser.startup.page", 1);
bb
cd ~-
MOZ_DISABLE_OOP_PLUGINS=1 firefox $arg_url &
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
clean

if ! [ $arg_cdn ]
then
  exit
fi

read app < <(cut -d/ -f4- <<< ${server}?${token//amp;})

log rtmpdump \
  -W http://download.hulu.com/huludesktop.swf \
  -o a.flv \
  -a $app \
  -r $server \
  -y $stream
