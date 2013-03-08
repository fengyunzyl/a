#!/bin/bash

quote ()
{
  set $1 '[ #&;\]'
  [[ ${!1} =~ $2 ]] && read -r $1 <<< \"${!1}\"
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

usage ()
{
  echo "usage: $0 [CDN FILETYPE] URL"
  echo
  echo "CDN       content delivery network"
  echo "FILETYPE  quality"
  echo
  echo "run with just URL to get CDN and FILETYPE params"
  exit
}

serialize_xml ()
{
  set "${!1/<}"
  eval set ${1/>}
  for oo
  do
    set ${oo/=/ }
    read ${1/[-:]} <<< $2
  done
}

coredump ()
{
  PID=$!
  echo waiting for $1 to load...
  qq=0
  while sleep 1
  do
    mapfile rr </proc/$PID/maps
    if (( ${#rr[*]} - $qq < -1 ))
    then
      break
    fi
    qq=${#rr[*]}
  done
  echo dumping $1...
  read WINPID </proc/$PID/winpid
  dumper hulu $WINPID 2>&- &
  until [ -s hulu.core ]
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
rm -r /tmp
mkdir /tmp
cd "$APPDATA"
find -name cookies.sqlite -exec cp -t /tmp {} ';'
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
  else
    false
  fi
done < <(grep -ao '<video [^>]*>' hulu.core | sort | uniq -w123)

[ $? = 0 ] || usage
[ $arg_cdn ] || exit
[[ $arg_url =~ [0-9]+ ]]

if [ -a /usr/local/bin/jq ]
then
  set www.hulu.com
  exec 3< "/dev/tcp/$1/80"
  echo "GET /api/2.0/video?id=$BASH_REMATCH HTTP/1.1" >&3
  echo "connection: close" >&3
  echo "host: $1" >&3
  echo >&3
  sed '1,/^$/d' <&3 > hulu.json
  read uu < <(jq -r .show.name hulu.json)
  read vv < <(jq .season_number hulu.json)
  read ww < <(jq .episode_number hulu.json)
  read xx < <(jq -r .title hulu.json)
  flv="${uu} ${vv}x${ww} ${xx}"
else
  flv="$BASH_REMATCH"
fi

cd "$arg_pwd"
app="${server#*//*/}?${token//amp;}"

log rtmpdump \
  -W http://download.hulu.com/huludesktop.swf \
  -r $server \
  -a $app \
  -y $stream \
  -o "$flv.flv"

if [ -a /usr/local/bin/ffmpeg ]
then
  log ffmpeg -i "$flv.flv" -c copy -v warning "$flv.mp4"
  log rm "$flv.flv"
fi
